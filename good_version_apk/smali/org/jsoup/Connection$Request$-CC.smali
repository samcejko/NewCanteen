.class public final synthetic Lorg/jsoup/Connection$Request$-CC;
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
.method public static $default$auth(Lorg/jsoup/Connection$Request;Lorg/jsoup/helper/RequestAuthenticator;)Lorg/jsoup/Connection$Request;
    .locals 0
    .param p0, "_this"    # Lorg/jsoup/Connection$Request;

    .line 794
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    throw p1
.end method

.method public static $default$auth(Lorg/jsoup/Connection$Request;)Lorg/jsoup/helper/RequestAuthenticator;
    .locals 1
    .param p0, "_this"    # Lorg/jsoup/Connection$Request;

    .line 804
    new-instance v0, Ljava/lang/UnsupportedOperationException;

    invoke-direct {v0}, Ljava/lang/UnsupportedOperationException;-><init>()V

    throw v0
.end method
