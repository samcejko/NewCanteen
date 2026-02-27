.class public final synthetic Lorg/jsoup/nodes/Element$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Lorg/jsoup/select/NodeVisitor;


# instance fields
.field public final synthetic f$0:Ljava/lang/StringBuilder;


# direct methods
.method public synthetic constructor <init>(Ljava/lang/StringBuilder;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lorg/jsoup/nodes/Element$$ExternalSyntheticLambda2;->f$0:Ljava/lang/StringBuilder;

    return-void
.end method


# virtual methods
.method public final head(Lorg/jsoup/nodes/Node;I)V
    .locals 1

    iget-object v0, p0, Lorg/jsoup/nodes/Element$$ExternalSyntheticLambda2;->f$0:Ljava/lang/StringBuilder;

    invoke-static {v0, p1, p2}, Lorg/jsoup/nodes/Element;->lambda$data$2(Ljava/lang/StringBuilder;Lorg/jsoup/nodes/Node;I)V

    return-void
.end method

.method public synthetic tail(Lorg/jsoup/nodes/Node;I)V
    .locals 0

    invoke-static {p0, p1, p2}, Lorg/jsoup/select/NodeVisitor$-CC;->$default$tail(Lorg/jsoup/select/NodeVisitor;Lorg/jsoup/nodes/Node;I)V

    return-void
.end method
