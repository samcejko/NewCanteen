<?php
// Simple PHP Proxy for iCanteen to bypass Web Browser CORS / Cookie restrictions
// Author: Antigravity

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: text/html; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Get session token
$token = $_GET['token'] ?? 'default';
$token = preg_replace('/[^a-zA-Z0-9]/', '', $token);
if (!$token)
    $token = 'default';

if (!is_dir(__DIR__ . '/cookies')) {
    mkdir(__DIR__ . '/cookies', 0777, true);
}

// A generic session file for curl to store JSESSIONID and XSRF-TOKEN
$cookie_file = __DIR__ . "/cookies/proxy_{$token}.txt";

if (!isset($_GET['url'])) {
    die("Error: url parameter missing");
}

$target_url = $_GET['url'];
$action = $_GET['action'] ?? 'fetch'; // 'login' or 'fetch'

// Helper function to execute curl
function exec_curl($url, $method = 'GET', $post_data = null)
{
    global $cookie_file;
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file);
    curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

    // Mimic a real browser to avoid 403s
    curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');

    if ($method === 'POST') {
        curl_setopt($ch, CURLOPT_POST, true);
        if ($post_data) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($post_data));
        }
    }

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    return ['code' => $http_code, 'body' => $response];
}

// ==========================================
// ACTION: LOGIN
// Perform the 2-step login process (CSRF Pre-flight -> POST)
// ==========================================
if ($action === 'login') {
    // Clear old cookies to ensure a fresh session
    if (file_exists($cookie_file)) {
        unlink($cookie_file);
    }

    $user = $_POST['user'] ?? '';
    $pass = $_POST['pass'] ?? '';

    // Step 1: Pre-flight GET to retrieve _csrf
    $preflight = exec_curl("https://" . $target_url . "/faces/login.jsp");

    $csrf_token = '';
    if (preg_match('/name="_csrf" value="([^"]+)"/', $preflight['body'], $matches)) {
        $csrf_token = $matches[1];
    } else {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'error' => 'Failed to extract CSRF token from login page.']);
        exit;
    }

    // Step 2: Perform the actual POST login to j_spring_security_check
    $login_data = [
        'j_username' => $user,
        'j_password' => $pass,
        'terminal' => 'false',
        '_csrf' => $csrf_token
    ];

    $login_res = exec_curl("https://" . $target_url . "/j_spring_security_check", 'POST', $login_data);

    // Verify successful login by checking if we were redirected away from error/login pages
    // iCanteen redirects to /faces/secured/main.jsp on success
    if (strpos($login_res['body'], 'přihlášení uživatele') !== false || $login_res['code'] == 403) {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'error' => 'Login rejected by iCanteen (Bad credentials or CSRF fail)']);
    } else {
        header('Content-Type: application/json');
        echo json_encode(['success' => true]);
    }
    exit;
}

// ==========================================
// ACTION: FETCH
// Fetch an arbitrary URL using the established proxy cookie session
// ==========================================
if ($action === 'fetch') {
    $path = $_GET['path'] ?? '/faces/secured/main.jsp';
    $full_url = "https://" . $target_url . $path;

    $res = exec_curl($full_url);
    echo $res['body'];
    exit;
}

// ==========================================
// ACTION: POST
// Post to an arbitrary URL (like ordering meals)
// ==========================================
if ($action === 'post') {
    $path = $_GET['path'] ?? '';
    $full_url = "https://" . $target_url . $path;

    $res = exec_curl($full_url, 'POST', $_POST);
    echo $res['body'];
    exit;
}
?>