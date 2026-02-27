.class public final synthetic Lcz/icanteen/app/network/SharedPrefsCookieJar$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Lokhttp3/Cookie;


# direct methods
.method public synthetic constructor <init>(Lokhttp3/Cookie;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcz/icanteen/app/network/SharedPrefsCookieJar$$ExternalSyntheticLambda0;->f$0:Lokhttp3/Cookie;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 1

    iget-object v0, p0, Lcz/icanteen/app/network/SharedPrefsCookieJar$$ExternalSyntheticLambda0;->f$0:Lokhttp3/Cookie;

    check-cast p1, Lokhttp3/Cookie;

    invoke-static {v0, p1}, Lcz/icanteen/app/network/SharedPrefsCookieJar;->lambda$saveFromResponse$0(Lokhttp3/Cookie;Lokhttp3/Cookie;)Z

    move-result p1

    return p1
.end method
