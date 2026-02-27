.class public Licanteen/samcejko/eu/MainActivity$JsAppBridge;
.super Ljava/lang/Object;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Licanteen/samcejko/eu/MainActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "JsAppBridge"
.end annotation


# instance fields
.field final synthetic this$0:Licanteen/samcejko/eu/MainActivity;


# direct methods
.method public static synthetic $r8$lambda$-nJ7XlWTef1bdUsiKL3rLuB_B8M(Licanteen/samcejko/eu/MainActivity$JsAppBridge;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->lambda$postAsync$2(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$GLp1nJ5ocLV-5ghE2XPvlSVU5GM(Licanteen/samcejko/eu/MainActivity$JsAppBridge;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->lambda$getAsync$1(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$bCVdc7C00EhXwO_22EvazCKKnso(Licanteen/samcejko/eu/MainActivity$JsAppBridge;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->lambda$postAsync$3(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$mQSDKxUSpScdH9tvZjjJPC8Ms7k(Licanteen/samcejko/eu/MainActivity$JsAppBridge;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->lambda$getAsync$0(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>(Licanteen/samcejko/eu/MainActivity;)V
    .locals 0

    .line 131
    iput-object p1, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private synthetic lambda$getAsync$0(Ljava/lang/String;Ljava/lang/String;)V
    .locals 3

    .line 149
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-static {v0}, Licanteen/samcejko/eu/MainActivity;->-$$Nest$fgetwebView(Licanteen/samcejko/eu/MainActivity;)Landroid/webkit/WebView;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "window.handleAndroidResponse(\'"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\', \'"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\');"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 p2, 0x0

    invoke-virtual {v0, p1, p2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    return-void
.end method

.method private synthetic lambda$getAsync$1(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 145
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-static {v0}, Lcz/icanteen/app/network/ApiManager;->getInstance(Landroid/content/Context;)Lcz/icanteen/app/network/ApiManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcz/icanteen/app/network/ApiManager;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 146
    sget-object v0, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    const/4 v0, 0x2

    invoke-static {p1, v0}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p1

    .line 148
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    new-instance v1, Licanteen/samcejko/eu/MainActivity$JsAppBridge$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0, p2, p1}, Licanteen/samcejko/eu/MainActivity$JsAppBridge$$ExternalSyntheticLambda2;-><init>(Licanteen/samcejko/eu/MainActivity$JsAppBridge;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Licanteen/samcejko/eu/MainActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

.method private synthetic lambda$postAsync$2(Ljava/lang/String;Ljava/lang/String;)V
    .locals 3

    .line 161
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-static {v0}, Licanteen/samcejko/eu/MainActivity;->-$$Nest$fgetwebView(Licanteen/samcejko/eu/MainActivity;)Landroid/webkit/WebView;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "window.handleAndroidResponse(\'"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\', \'"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\');"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 p2, 0x0

    invoke-virtual {v0, p1, p2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    return-void
.end method

.method private synthetic lambda$postAsync$3(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    .line 157
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-static {v0}, Lcz/icanteen/app/network/ApiManager;->getInstance(Landroid/content/Context;)Lcz/icanteen/app/network/ApiManager;

    move-result-object v0

    invoke-virtual {v0, p1, p2}, Lcz/icanteen/app/network/ApiManager;->post(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 158
    sget-object p2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, p2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    const/4 p2, 0x2

    invoke-static {p1, p2}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p1

    .line 160
    iget-object p2, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    new-instance v0, Licanteen/samcejko/eu/MainActivity$JsAppBridge$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0, p3, p1}, Licanteen/samcejko/eu/MainActivity$JsAppBridge$$ExternalSyntheticLambda3;-><init>(Licanteen/samcejko/eu/MainActivity$JsAppBridge;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p2, v0}, Licanteen/samcejko/eu/MainActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method


# virtual methods
.method public cacheData(Ljava/lang/String;Ljava/lang/String;)V
    .locals 3
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .line 219
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    const-string v1, "iCanteenCache"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Licanteen/samcejko/eu/MainActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 220
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method public get(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .line 134
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-static {v0}, Lcz/icanteen/app/network/ApiManager;->getInstance(Landroid/content/Context;)Lcz/icanteen/app/network/ApiManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcz/icanteen/app/network/ApiManager;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method public getAsync(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .line 144
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Licanteen/samcejko/eu/MainActivity$JsAppBridge$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0, p1, p2}, Licanteen/samcejko/eu/MainActivity$JsAppBridge$$ExternalSyntheticLambda1;-><init>(Licanteen/samcejko/eu/MainActivity$JsAppBridge;Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 151
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public getCachedData(Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .line 225
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    const-string v1, "iCanteenCache"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Licanteen/samcejko/eu/MainActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const/4 v1, 0x0

    .line 226
    invoke-interface {v0, p1, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method public getSystemAccentColor()Ljava/lang/String;
    .locals 6
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .line 231
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const-string v1, "#39FF14"

    const/16 v2, 0x1f

    if-lt v0, v2, :cond_0

    .line 233
    :try_start_0
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    const v2, 0x106003e

    invoke-static {v0, v2}, Landroidx/core/content/ContextCompat;->getColor(Landroid/content/Context;I)I

    move-result v0

    const-string v2, "#%06X"

    const/4 v3, 0x1

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    const v5, 0xffffff

    and-int/2addr v0, v5

    .line 234
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v3, v4

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    :cond_0
    return-object v1
.end method

.method public post(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .line 139
    iget-object v0, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    invoke-static {v0}, Lcz/icanteen/app/network/ApiManager;->getInstance(Landroid/content/Context;)Lcz/icanteen/app/network/ApiManager;

    move-result-object v0

    invoke-virtual {v0, p1, p2}, Lcz/icanteen/app/network/ApiManager;->post(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method public postAsync(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .line 156
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Licanteen/samcejko/eu/MainActivity$JsAppBridge$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, p1, p2, p3}, Licanteen/samcejko/eu/MainActivity$JsAppBridge$$ExternalSyntheticLambda0;-><init>(Licanteen/samcejko/eu/MainActivity$JsAppBridge;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 163
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public scheduleMeals(Ljava/lang/String;)V
    .locals 13
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    const-string v0, "IcanteenJS"

    .line 169
    :try_start_0
    iget-object v1, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    const-string v2, "alarm"

    invoke-virtual {v1, v2}, Licanteen/samcejko/eu/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/AlarmManager;

    if-nez v1, :cond_0

    return-void

    .line 172
    :cond_0
    new-instance v2, Lorg/json/JSONArray;

    invoke-direct {v2, p1}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    .line 173
    new-instance p1, Ljava/text/SimpleDateFormat;

    const-string v3, "yyyy-MM-dd"

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v4

    invoke-direct {p1, v3, v4}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    const/4 v3, 0x0

    const/4 v4, 0x0

    .line 175
    :goto_0
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v5

    if-ge v4, v5, :cond_4

    .line 176
    invoke-virtual {v2, v4}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v5

    const-string v6, "date"

    .line 177
    invoke-virtual {v5, v6}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    const-string v7, "text"

    .line 178
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 180
    invoke-virtual {p1, v6}, Ljava/text/SimpleDateFormat;->parse(Ljava/lang/String;)Ljava/util/Date;

    move-result-object v7

    if-nez v7, :cond_1

    goto :goto_1

    .line 183
    :cond_1
    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v8

    .line 184
    invoke-virtual {v8, v7}, Ljava/util/Calendar;->setTime(Ljava/util/Date;)V

    const/16 v7, 0xb

    .line 185
    invoke-virtual {v8, v7, v7}, Ljava/util/Calendar;->set(II)V

    const/16 v7, 0xc

    const/16 v9, 0x14

    .line 186
    invoke-virtual {v8, v7, v9}, Ljava/util/Calendar;->set(II)V

    const/16 v7, 0xd

    .line 187
    invoke-virtual {v8, v7, v3}, Ljava/util/Calendar;->set(II)V

    .line 189
    invoke-virtual {v8}, Ljava/util/Calendar;->getTimeInMillis()J

    move-result-wide v9

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v11

    cmp-long v7, v9, v11

    if-lez v7, :cond_3

    .line 190
    new-instance v7, Landroid/content/Intent;

    iget-object v9, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    const-class v10, Licanteen/samcejko/eu/NotificationReceiver;

    invoke-direct {v7, v9, v10}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v9, "mealText"

    .line 191
    invoke-virtual {v7, v9, v5}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 193
    invoke-virtual {v6}, Ljava/lang/String;->hashCode()I

    move-result v5

    .line 194
    iget-object v6, p0, Licanteen/samcejko/eu/MainActivity$JsAppBridge;->this$0:Licanteen/samcejko/eu/MainActivity;

    const/high16 v9, 0xc000000

    invoke-static {v6, v5, v7, v9}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v5
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    .line 202
    :try_start_1
    sget v6, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v7, 0x17

    if-lt v6, v7, :cond_2

    .line 203
    invoke-virtual {v8}, Ljava/util/Calendar;->getTimeInMillis()J

    move-result-wide v6

    invoke-virtual {v1, v3, v6, v7, v5}, Landroid/app/AlarmManager;->setExactAndAllowWhileIdle(IJLandroid/app/PendingIntent;)V

    goto :goto_1

    .line 205
    :cond_2
    invoke-virtual {v8}, Ljava/util/Calendar;->getTimeInMillis()J

    move-result-wide v6

    invoke-virtual {v1, v3, v6, v7, v5}, Landroid/app/AlarmManager;->setExact(IJLandroid/app/PendingIntent;)V
    :try_end_1
    .catch Ljava/lang/SecurityException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    :catch_0
    move-exception v5

    :try_start_2
    const-string v6, "Cannot schedule exact alarm"

    .line 208
    invoke-static {v0, v6, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    :cond_3
    :goto_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :catch_1
    move-exception p1

    .line 213
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Error scheduling meals: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_4
    return-void
.end method
