package icanteen.samcejko.eu;

import androidx.appcompat.app.AppCompatActivity;
import android.annotation.SuppressLint;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebChromeClient;
import android.webkit.ConsoleMessage;
import android.util.Log;
import cz.icanteen.app.network.ApiManager;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import android.content.pm.PackageManager;
import android.Manifest;
import org.json.JSONArray;
import org.json.JSONObject;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Calendar;
import android.os.Build;

public class MainActivity extends AppCompatActivity {
    private WebView webView;

    @SuppressLint("SetJavaScriptEnabled")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Request Notification Permission on Android 13+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.POST_NOTIFICATIONS}, 101);
            }
        }

        // Fullscreen immersive mode
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN,
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        );

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            getWindow().setStatusBarColor(Color.TRANSPARENT);
            getWindow().setNavigationBarColor(Color.TRANSPARENT);
        }

        androidx.core.view.WindowCompat.setDecorFitsSystemWindows(getWindow(), false);
        
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
            WindowManager.LayoutParams layoutParams = getWindow().getAttributes();
            layoutParams.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
            getWindow().setAttributes(layoutParams);
        }

        setContentView(R.layout.activity_main);
        
        webView = findViewById(R.id.webView);
        WebSettings settings = webView.getSettings();
        
        // Critical WebView settings for the Web App
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setDatabaseEnabled(true);
        settings.setSaveFormData(true); // For Autofill
        
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                
                // Parse Incoming Android Shortcuts
                Intent intent = getIntent();
                if (intent != null && intent.getAction() != null) {
                    if (intent.getAction().equals("icanteen.samcejko.eu.ACTION_OPEN_BURZA")) {
                        webView.evaluateJavascript("if (typeof navigateToPage === 'function') navigateToPage('burza');", null);
                    } else if (intent.getAction().equals("icanteen.samcejko.eu.ACTION_OPEN_SETTINGS")) {
                        webView.evaluateJavascript("if (typeof navigateToPage === 'function') navigateToPage('nastaveni');", null);
                    }
                }
            }
        });
        
        // Register the OkHttp Bridge
        webView.addJavascriptInterface(new JsAppBridge(), "AndroidHttp");

        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
                Log.d("IcanteenJS", consoleMessage.message() + " -- From line "
                        + consoleMessage.lineNumber() + " of "
                        + consoleMessage.sourceId());
                return super.onConsoleMessage(consoleMessage);
            }
        });

        webView.clearCache(true);
        WebView.setWebContentsDebuggingEnabled(true);

        // Load the local robust frontend from the web subdirectory
        webView.loadUrl("file:///android_asset/web/index.html");
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent); // Update the activity intent so onResume/WebView parses it
        
        if (intent != null && intent.getAction() != null && webView != null) {
            if (intent.getAction().equals("icanteen.samcejko.eu.ACTION_OPEN_BURZA")) {
                webView.evaluateJavascript("if (typeof navigateToPage === 'function') navigateToPage('burza');", null);
            } else if (intent.getAction().equals("icanteen.samcejko.eu.ACTION_OPEN_SETTINGS")) {
                webView.evaluateJavascript("if (typeof navigateToPage === 'function') navigateToPage('nastaveni');", null);
            }
        }
    }

    // Bridge Class
    public class JsAppBridge {
        @JavascriptInterface
        public String get(String url) {
            return ApiManager.getInstance(MainActivity.this).get(url);
        }

        @JavascriptInterface
        public String post(String url, String body) {
            return ApiManager.getInstance(MainActivity.this).post(url, body);
        }

        @JavascriptInterface
        public void getAsync(String url, String callbackId) {
            new Thread(() -> {
                String result = ApiManager.getInstance(MainActivity.this).get(url);
                String b64 = android.util.Base64.encodeToString(result.getBytes(java.nio.charset.StandardCharsets.UTF_8), android.util.Base64.NO_WRAP);
                
                runOnUiThread(() -> {
                    webView.evaluateJavascript("window.handleAndroidResponse('" + callbackId + "', '" + b64 + "');", null);
                });
            }).start();
        }

        @JavascriptInterface
        public void postAsync(String url, String body, String callbackId) {
            new Thread(() -> {
                String result = ApiManager.getInstance(MainActivity.this).post(url, body);
                String b64 = android.util.Base64.encodeToString(result.getBytes(java.nio.charset.StandardCharsets.UTF_8), android.util.Base64.NO_WRAP);
                
                runOnUiThread(() -> {
                    webView.evaluateJavascript("window.handleAndroidResponse('" + callbackId + "', '" + b64 + "');", null);
                });
            }).start();
        }

        @JavascriptInterface
        public void scheduleMeals(String json) {
            try {
                AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
                if (alarmManager == null) return;
                
                JSONArray meals = new JSONArray(json);
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
                
                for (int i = 0; i < meals.length(); i++) {
                    JSONObject meal = meals.getJSONObject(i);
                    String dateStr = meal.getString("date");
                    String text = meal.getString("text");
                    
                    Date date = sdf.parse(dateStr);
                    if (date == null) continue;
                    
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(date);
                    calendar.set(Calendar.HOUR_OF_DAY, 11);
                    calendar.set(Calendar.MINUTE, 20);
                    calendar.set(Calendar.SECOND, 0);
                    
                    if (calendar.getTimeInMillis() > System.currentTimeMillis()) {
                        Intent intent = new Intent(MainActivity.this, NotificationReceiver.class);
                        intent.putExtra("mealText", text);
                        
                        int requestCode = dateStr.hashCode();
                        PendingIntent pendingIntent = PendingIntent.getBroadcast(
                                MainActivity.this,
                                requestCode,
                                intent,
                                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
                        );
                        
                        try {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
                            } else {
                                alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
                            }
                        } catch (SecurityException e) {
                            Log.e("IcanteenJS", "Cannot schedule exact alarm", e);
                        }
                    }
                }
            } catch (Exception e) {
                Log.e("IcanteenJS", "Error scheduling meals: " + e.getMessage());
            }
        }

        @JavascriptInterface
        public void cacheData(String key, String data) {
            android.content.SharedPreferences prefs = MainActivity.this.getSharedPreferences("iCanteenCache", Context.MODE_PRIVATE);
            prefs.edit().putString(key, data).apply();
        }

        @JavascriptInterface
        public String getCachedData(String key) {
            android.content.SharedPreferences prefs = MainActivity.this.getSharedPreferences("iCanteenCache", Context.MODE_PRIVATE);
            return prefs.getString(key, null);
        }

        @JavascriptInterface
        public String getSystemAccentColor() {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                try {
                    int colorObj = ContextCompat.getColor(MainActivity.this, android.R.color.system_accent1_500);
                    return String.format("#%06X", (0xFFFFFF & colorObj));
                } catch (Exception e) {
                    return "#39FF14"; // Fallback to green
                }
            }
            return "#39FF14"; // Fallback for pre-Android 12
        }
    }
}
