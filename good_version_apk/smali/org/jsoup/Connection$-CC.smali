.class public final synthetic Lorg/jsoup/Connection$-CC;
.super Ljava/lang/Object;
.source "Connection.java"


# annotations
.annotation build Lcom/android/tools/r8/annotations/SynthesizedClassV2;
    kind = 0x7
    versionHash = "5e5398f0546d1d7afd62641edb14d82894f11ddc41bce363a0c8d0dac82c9c5a"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;"
    }
.end annotation


# direct methods
.method public static $default$auth(Lorg/jsoup/Connection;Lorg/jsoup/helper/RequestAuthenticator;)Lorg/jsoup/Connection;
    .locals 0
    .param p0, "_this"    # Lorg/jsoup/Connection;

    .line 405
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    throw p1
.end method

.method public static $default$newRequest(Lorg/jsoup/Connection;Ljava/lang/String;)Lorg/jsoup/Connection;
    .locals 1
    .param p0, "_this"    # Lorg/jsoup/Connection;

    .line 82
    invoke-interface {p0}, Lorg/jsoup/Connection;->newRequest()Lorg/jsoup/Connection;

    move-result-object v0

    invoke-interface {v0, p1}, Lorg/jsoup/Connection;->url(Ljava/lang/String;)Lorg/jsoup/Connection;

    move-result-object p1

    return-object p1
.end method

.method public static $default$newRequest(Lorg/jsoup/Connection;Ljava/net/URL;)Lorg/jsoup/Connection;
    .locals 1
    .param p0, "_this"    # Lorg/jsoup/Connection;

    .line 93
    invoke-interface {p0}, Lorg/jsoup/Connection;->newRequest()Lorg/jsoup/Connection;

    move-result-object v0

    invoke-interface {v0, p1}, Lorg/jsoup/Connection;->url(Ljava/net/URL;)Lorg/jsoup/Connection;

    move-result-object p1

    return-object p1
.end method
