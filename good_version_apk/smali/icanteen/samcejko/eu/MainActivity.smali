.class public Licanteen/samcejko/eu/MainActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Licanteen/samcejko/eu/MainActivity$JsAppBridge;
    }
.end annotation


# instance fields
.field private webView:Landroid/webkit/WebView;


# direct methods
.method static bridge synthetic -$$Nest$fgetwebView(Licanteen/samcejko/eu/MainActivity;)Landroid/webkit/WebView;
    .locals 0

    iget-object p0, p0, Licanteen/samcejko/eu/MainActivity;->webView:Landroid/webkit/WebView;

    return-object p0
.end method

.method public constructor <init>()V
    .locals 0

    .line 34
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 3

    .line 40
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 43
    sget p1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v0, 0x21

    if-lt p1, v0, :cond_0

    const-string p1, "android.permission.POST_NOTIFICATIONS"

    .line 44
    invoke-static {p0, p1}, Landroidx/core/content/ContextCompat;->checkSelfPermission(Landroid/content/Context;Ljava/lang/String;)I

    move-result v0

    if-eqz v0, :cond_0

    .line 45
    filled-new-array {p1}, [Ljava/lang/String;

    move-result-object p1

    const/16 v0, 0x65

    invoke-static {p0, p1, v0}, Landroidx/core/app/ActivityCompat;->requestPermissions(Landroid/app/Activity;[Ljava/lang/String;I)V

    :cond_0
    const/4 p1, 0x1

    .line 50
    invoke-virtual {p0, p1}, Licanteen/samcejko/eu/MainActivity;->requestWindowFeature(I)Z

    .line 51
    invoke-virtual {p0}, Licanteen/samcejko/eu/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    const/16 v1, 0x400

    invoke-virtual {v0, v1, v1}, Landroid/view/Window;->setFlags(II)V

    .line 56
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    const/4 v2, 0x0

    if-lt v0, v1, :cond_1

    .line 57
    invoke-virtual {p0}, Licanteen/samcejko/eu/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/Window;->setStatusBarColor(I)V

    .line 58
    invoke-virtual {p0}, Licanteen/samcejko/eu/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/Window;->setNavigationBarColor(I)V

    .line 61
    :cond_1
    invoke-virtual {p0}, Licanteen/samcejko/eu/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-static {v0, v2}, Landroidx/core/view/WindowCompat;->setDecorFitsSystemWindows(Landroid/view/Window;Z)V

    .line 63
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1c

    if-lt v0, v1, :cond_2

    .line 64
    invoke-virtual {p0}, Licanteen/samcejko/eu/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    .line 65
    iput p1, v0, Landroid/view/WindowManager$LayoutParams;->layoutInDisplayCutoutMode:I

    .line 66
    invoke-virtual {p0}, Licanteen/samcejko/eu/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    :cond_2
    const v0, 0x7f0b001c

    .line 69
    invoke-virtual {p0, v0}, Licanteen/samcejko/eu/MainActivity;->setContentView(I)V

    const v0, 0x7f0801d3

    .line 71
    invoke-virtual {p0, v0}, Licanteen/samcejko/eu/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/webkit/WebView;

    iput-object v0, p0, Licanteen/samcejko/eu/MainActivity;->webView:Landroid/webkit/WebView;

    .line 72
    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v0

    .line 75
    invoke-virtual {v0, p1}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    .line 76
    invoke-virtual {v0, p1}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V

    .line 77
    invoke-virtual {v0, p1}, Landroid/webkit/WebSettings;->setDatabaseEnabled(Z)V

    .line 78
    invoke-virtual {v0, p1}, Landroid/webkit/WebSettings;->setSaveFormData(Z)V

    .line 80
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity;->webView:Landroid/webkit/WebView;

    new-instance v1, Licanteen/samcejko/eu/MainActivity$1;

    invoke-direct {v1, p0}, Licanteen/samcejko/eu/MainActivity$1;-><init>(Licanteen/samcejko/eu/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    .line 98
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity;->webView:Landroid/webkit/WebView;

    new-instance v1, Licanteen/samcejko/eu/MainActivity$JsAppBridge;

    invoke-direct {v1, p0}, Licanteen/samcejko/eu/MainActivity$JsAppBridge;-><init>(Licanteen/samcejko/eu/MainActivity;)V

    const-string v2, "AndroidHttp"

    invoke-virtual {v0, v1, v2}, Landroid/webkit/WebView;->addJavascriptInterface(Ljava/lang/Object;Ljava/lang/String;)V

    .line 100
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity;->webView:Landroid/webkit/WebView;

    new-instance v1, Licanteen/samcejko/eu/MainActivity$2;

    invoke-direct {v1, p0}, Licanteen/samcejko/eu/MainActivity$2;-><init>(Licanteen/samcejko/eu/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setWebChromeClient(Landroid/webkit/WebChromeClient;)V

    .line 110
    invoke-static {p1}, Landroid/webkit/WebView;->setWebContentsDebuggingEnabled(Z)V

    .line 113
    iget-object p1, p0, Licanteen/samcejko/eu/MainActivity;->webView:Landroid/webkit/WebView;

    const-string v0, "file:///android_asset/index.html"

    invoke-virtual {p1, v0}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    return-void
.end method

.method protected onNewIntent(Landroid/content/Intent;)V
    .locals 2

    .line 118
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onNewIntent(Landroid/content/Intent;)V

    .line 119
    invoke-virtual {p0, p1}, Licanteen/samcejko/eu/MainActivity;->setIntent(Landroid/content/Intent;)V

    if-eqz p1, :cond_1

    .line 121
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity;->webView:Landroid/webkit/WebView;

    if-eqz v0, :cond_1

    .line 122
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    const-string v1, "icanteen.samcejko.eu.ACTION_OPEN_BURZA"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 123
    iget-object p1, p0, Licanteen/samcejko/eu/MainActivity;->webView:Landroid/webkit/WebView;

    const-string v0, "if (typeof navigateToPage === \'function\') navigateToPage(\'burza\');"

    invoke-virtual {p1, v0, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    goto :goto_0

    .line 124
    :cond_0
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v0, "icanteen.samcejko.eu.ACTION_OPEN_SETTINGS"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 125
    iget-object p1, p0, Licanteen/samcejko/eu/MainActivity;->webView:Landroid/webkit/WebView;

    const-string v0, "if (typeof navigateToPage === \'function\') navigateToPage(\'nastaveni\');"

    invoke-virtual {p1, v0, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    :cond_1
    :goto_0
    return-void
.end method
