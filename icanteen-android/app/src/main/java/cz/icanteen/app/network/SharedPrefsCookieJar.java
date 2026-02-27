package cz.icanteen.app.network;

import android.content.Context;
import android.content.SharedPreferences;
import okhttp3.Cookie;
import okhttp3.CookieJar;
import okhttp3.HttpUrl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class SharedPrefsCookieJar implements CookieJar {
    private final SharedPreferences sharedPreferences;
    private final ConcurrentHashMap<String, List<Cookie>> cache = new ConcurrentHashMap<>();

    public SharedPrefsCookieJar(Context context) {
        sharedPreferences = context.getSharedPreferences("CookiePrefs", Context.MODE_PRIVATE);
        loadCookiesFromPrefs();
    }

    @Override
    public void saveFromResponse(HttpUrl url, List<Cookie> cookies) {
        String host = url.host();
        List<Cookie> currentCookies = cache.getOrDefault(host, new ArrayList<>());
        
        // Add or update cookies
        for (Cookie newCookie : cookies) {
            currentCookies.removeIf(c -> c.name().equals(newCookie.name()));
            if (newCookie.expiresAt() > System.currentTimeMillis()) {
                currentCookies.add(newCookie);
            }
        }
        
        cache.put(host, currentCookies);
        saveCookiesToPrefs();
    }

    @Override
    public List<Cookie> loadForRequest(HttpUrl url) {
        String host = url.host();
        List<Cookie> validCookies = new ArrayList<>();
        List<Cookie> currentCookies = cache.getOrDefault(host, new ArrayList<>());
        
        boolean modified = false;
        long now = System.currentTimeMillis();
        
        for (Cookie cookie : currentCookies) {
            if (cookie.expiresAt() > now) {
                validCookies.add(cookie);
            } else {
                modified = true;
            }
        }
        
        if (modified) {
            cache.put(host, validCookies);
            saveCookiesToPrefs();
        }
        
        return validCookies;
    }
    
    public void clear() {
        cache.clear();
        sharedPreferences.edit().clear().apply();
    }

    private void saveCookiesToPrefs() {
        SharedPreferences.Editor editor = sharedPreferences.edit();
        for (Map.Entry<String, List<Cookie>> entry : cache.entrySet()) {
            StringBuilder sb = new StringBuilder();
            for (Cookie cookie : entry.getValue()) {
                sb.append(cookie.toString()).append("|||");
            }
            editor.putString(entry.getKey(), sb.toString());
        }
        editor.apply();
    }

    private void loadCookiesFromPrefs() {
        Map<String, ?> allEntries = sharedPreferences.getAll();
        for (Map.Entry<String, ?> entry : allEntries.entrySet()) {
            String value = (String) entry.getValue();
            if (value != null && !value.isEmpty()) {
                String[] cookieStrings = value.split("\\|\\|\\|");
                List<Cookie> cookies = new ArrayList<>();
                for (String cookieString : cookieStrings) {
                    if (!cookieString.isEmpty()) {
                        // Assuming HttpUrl.get(...) can be used if we build a dummy URL.
                        // Actually, OkHttp Cookie.parse needs a url, but since we saved toString(),
                        // we can parse it back if we build an HttpUrl for the host.
                        HttpUrl url = new HttpUrl.Builder().scheme("https").host(entry.getKey()).build();
                        Cookie cookie = Cookie.parse(url, cookieString);
                        if (cookie != null) {
                            cookies.add(cookie);
                        }
                    }
                }
                cache.put(entry.getKey(), cookies);
            }
        }
    }
}
