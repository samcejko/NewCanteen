.class Licanteen/samcejko/eu/MainActivity$1;
.super Landroid/webkit/WebViewClient;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Licanteen/samcejko/eu/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Licanteen/samcejko/eu/MainActivity;


# direct methods
.method constructor <init>(Licanteen/samcejko/eu/MainActivity;)V
    .locals 0

    .line 80
    iput-object p1, p0, Licanteen/samcejko/eu/MainActivity$1;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    return-void
.end method


# virtual methods
.method public onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 1

    .line 83
    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V

    .line 86
    iget-object p1, p0, Licanteen/samcejko/eu/MainActivity$1;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-virtual {p1}, Licanteen/samcejko/eu/MainActivity;->getIntent()Landroid/content/Intent;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 87
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p2

    if-eqz p2, :cond_1

    .line 88
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p2

    const-string v0, "icanteen.samcejko.eu.ACTION_OPEN_BURZA"

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    const/4 v0, 0x0

    if-eqz p2, :cond_0

    .line 89
    iget-object p1, p0, Licanteen/samcejko/eu/MainActivity$1;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-static {p1}, Licanteen/samcejko/eu/MainActivity;->-$$Nest$fgetwebView(Licanteen/samcejko/eu/MainActivity;)Landroid/webkit/WebView;

    move-result-object p1

    const-string p2, "if (typeof navigateToPage === \'function\') navigateToPage(\'burza\');"

    invoke-virtual {p1, p2, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    goto :goto_0

    .line 90
    :cond_0
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string p2, "icanteen.samcejko.eu.ACTION_OPEN_SETTINGS"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 91
    iget-object p1, p0, Licanteen/samcejko/eu/MainActivity$1;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-static {p1}, Licanteen/samcejko/eu/MainActivity;->-$$Nest$fgetwebView(Licanteen/samcejko/eu/MainActivity;)Landroid/webkit/WebView;

    move-result-object p1

    const-string p2, "if (typeof navigateToPage === \'function\') navigateToPage(\'nastaveni\');"

    invoke-virtual {p1, p2, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    :cond_1
    :goto_0
    return-void
.end method
