package cz.icanteen.app.network;

import android.content.Context;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

public class ApiManager {
    private static ApiManager instance;
    private final OkHttpClient client;

    private ApiManager(Context context) {
        client = new OkHttpClient.Builder()
                .connectTimeout(5, TimeUnit.SECONDS)
                .readTimeout(8, TimeUnit.SECONDS)
                .writeTimeout(8, TimeUnit.SECONDS)
                .cookieJar(new SharedPrefsCookieJar(context.getApplicationContext()))
                .build();
    }

    public static synchronized ApiManager getInstance(Context context) {
        if (instance == null) {
            instance = new ApiManager(context);
        }
        return instance;
    }

    public String get(String url) {
        try {
            Request req = new Request.Builder()
                    .url(url)
                    .header("X-Requested-With", "XMLHttpRequest")
                    .header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
                    .header("Referer", url.substring(0, url.indexOf("/", 8)) + "/faces/secured/main.jsp")
                    .build();
            
            try (Response res = client.newCall(req).execute()) {
                if (!res.isSuccessful()) {
                    return "ERROR: HTTP " + res.code();
                }
                if (res.body() != null) {
                    return res.body().string();
                }
                return "";
            }
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }

    public String post(String url, String bodyData) {
        try {
            MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
            RequestBody body = RequestBody.create(bodyData, mediaType);
            
            Request req = new Request.Builder()
                    .url(url)
                    .post(body)
                    .header("X-Requested-With", "XMLHttpRequest")
                    .header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
                    .header("Referer", url.substring(0, url.indexOf("/", 8)) + "/faces/secured/main.jsp")
                    .build();

            try (Response res = client.newCall(req).execute()) {
                // Note: iCanteen often returns 403 on failed login, but redirects otherwise
                if (!res.isSuccessful() && res.code() != 403) {
                    return "ERROR: HTTP " + res.code();
                }
                if (res.body() != null) {
                    return res.body().string();
                }
                return "";
            }
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}
