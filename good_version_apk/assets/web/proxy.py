import http.server
import socketserver
import urllib.parse
import urllib.request
import json
import ssl
import re
import os

PORT = 8000
COOKIE_DIR = "cookies"

if not os.path.exists(COOKIE_DIR):
    os.makedirs(COOKIE_DIR)

def get_cookie_file(token):
    # Sanitize token to be alphanumeric
    token = "".join(c for c in str(token) if c.isalnum())
    if not token: token = "default"
    return os.path.join(COOKIE_DIR, f"proxy_{token}.txt")

class ProxyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def do_POST(self):
        self._set_cors_headers()
        parsed_path = urllib.parse.urlparse(self.path)
        qs = urllib.parse.parse_qs(parsed_path.query)

        if 'action' not in qs or 'url' not in qs:
            self.send_error(400, "Missing action or url")
            return

        action = qs['action'][0]
        target_url = qs['url'][0]
        token = qs.get('token', ['default'])[0]
        
        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length) if content_length > 0 else b""

        if action == 'login':
            self._handle_login(token, target_url, post_data)
        elif action == 'post':
            path_suffix = qs.get('path', [''])[0]
            self._handle_proxy(token, target_url, path_suffix, 'POST', post_data)
        else:
            self.send_error(400, "Invalid POST action")

    def do_GET(self):
        parsed_path = urllib.parse.urlparse(self.path)
        qs = urllib.parse.parse_qs(parsed_path.query)

        if 'action' in qs and 'url' in qs:
             token = qs.get('token', ['default'])[0]
             if qs['action'][0] == 'fetch':
                 path_suffix = qs.get('path', ['/faces/secured/main.jsp'])[0]
                 self._handle_proxy(token, qs['url'][0], path_suffix, 'GET')
             else:
                 self._set_cors_headers()
                 self.send_error(400, "Invalid GET action")
             return
             
        # Fallback to serving static files for standard GET
        super().do_GET()

    def _set_cors_headers(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.send_header('Content-type', 'application/json')
        self.end_headers()

    def _get_opener(self, token):
        import urllib.request
        import http.cookiejar
        import ssl
        
        # Insecure SSL context for SSTEBrno internally if needed
        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE
        
        cookie_file = get_cookie_file(token)
        cookie_jar = http.cookiejar.MozillaCookieJar(cookie_file)
        if os.path.exists(cookie_file):
             try:
                 cookie_jar.load(ignore_discard=True, ignore_expires=True)
             except Exception:
                 pass
                 
        opener = urllib.request.build_opener(
            urllib.request.HTTPCookieProcessor(cookie_jar),
            urllib.request.HTTPSHandler(context=ctx)
        )
        opener.addheaders = [('User-agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')]
        return opener, cookie_jar

    def _handle_login(self, token, target_url, post_data):
        try:
            cookie_file = get_cookie_file(token)
            # Clear old cookies
            if os.path.exists(cookie_file):
                os.remove(cookie_file)
                
            opener, cookie_jar = self._get_opener(token)
            
            form_data = urllib.parse.parse_qs(post_data.decode('utf-8'))
            user = form_data.get('user', [''])[0]
            password = form_data.get('pass', [''])[0]

            # 1. Preflight GET
            req1 = urllib.request.Request(f"https://{target_url}/faces/login.jsp")
            res1 = opener.open(req1)
            html = res1.read().decode('utf-8')
            cookie_jar.save(ignore_discard=True, ignore_expires=True)

            csrf_token = ''
            match = re.search(r'name="_csrf"\s+value="([^"]+)"', html)
            if match:
                csrf_token = match.group(1)
            else:
                 self.wfile.write(json.dumps({'success': False, 'error': 'Failed to extract CSRF token.'}).encode('utf-8'))
                 return

            # 2. Actual Login POST
            login_payload = {
                'j_username': user,
                'j_password': password,
                'terminal': 'false',
                '_csrf': csrf_token
            }
            encoded_data = urllib.parse.urlencode(login_payload).encode('utf-8')
            req2 = urllib.request.Request(f"https://{target_url}/j_spring_security_check", data=encoded_data)
            try:
                 res2 = opener.open(req2)
                 body2 = res2.read().decode('utf-8')
                 cookie_jar.save(ignore_discard=True, ignore_expires=True)
                 
                 if 'přihlášení uživatele' in body2.lower():
                     self.wfile.write(json.dumps({'success': False, 'error': 'Bad credentials'}).encode('utf-8'))
                 else:
                     self.wfile.write(json.dumps({'success': True}).encode('utf-8'))
            except urllib.error.HTTPError as e:
                 # Spring security sometimes sends 403 on failed CSRF, or redirects using 302
                 self.wfile.write(json.dumps({'success': False, 'error': f'HTTP Error {e.code}: {e.reason}'}).encode('utf-8'))

        except Exception as e:
            self.wfile.write(json.dumps({'success': False, 'error': str(e)}).encode('utf-8'))

    def _handle_proxy(self, token, target_url, path_suffix, method, post_data=None):
        try:
             opener, cookie_jar = self._get_opener(token)
             url = f"https://{target_url}{path_suffix}"
             
             # If GET request, rewrite cors-header to html
             if method == 'GET':
                 self.send_response(200)
                 self.send_header('Access-Control-Allow-Origin', '*')
                 self.send_header('Content-type', 'text/html; charset=utf-8')
                 self.end_headers()
                 
             req = urllib.request.Request(url, data=post_data)
             
             try:
                 res = opener.open(req)
                 self.wfile.write(res.read())
                 cookie_jar.save(ignore_discard=True, ignore_expires=True)
             except urllib.error.HTTPError as e:
                 self.wfile.write(f"HTTP Error {e.code}: {e.reason}".encode('utf-8'))
                 
        except Exception as e:
            self.wfile.write(str(e).encode('utf-8'))

with socketserver.TCPServer(("", PORT), ProxyHTTPRequestHandler) as httpd:
    print(f"Serving proxy at port {PORT}")
    httpd.serve_forever()
