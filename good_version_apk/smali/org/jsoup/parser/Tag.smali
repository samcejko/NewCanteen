.class public Lorg/jsoup/parser/Tag;
.super Ljava/lang/Object;
.source "Tag.java"

# interfaces
.implements Ljava/lang/Cloneable;


# static fields
.field private static final Tags:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lorg/jsoup/parser/Tag;",
            ">;"
        }
    .end annotation
.end field

.field private static final blockTags:[Ljava/lang/String;

.field private static final emptyTags:[Ljava/lang/String;

.field private static final formListedTags:[Ljava/lang/String;

.field private static final formSubmitTags:[Ljava/lang/String;

.field private static final formatAsInlineTags:[Ljava/lang/String;

.field private static final inlineTags:[Ljava/lang/String;

.field private static final namespaces:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "[",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static final preserveWhitespaceTags:[Ljava/lang/String;


# instance fields
.field private empty:Z

.field private formList:Z

.field private formSubmit:Z

.field private formatAsBlock:Z

.field private isBlock:Z

.field private namespace:Ljava/lang/String;

.field private final normalName:Ljava/lang/String;

.field private preserveWhitespace:Z

.field private selfClosing:Z

.field private tagName:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 77

    .line 16
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lorg/jsoup/parser/Tag;->Tags:Ljava/util/Map;

    const-string v1, "html"

    const-string v2, "head"

    const-string v3, "body"

    const-string v4, "frameset"

    const-string v5, "script"

    const-string v6, "noscript"

    const-string v7, "style"

    const-string v8, "meta"

    const-string v9, "link"

    const-string v10, "title"

    const-string v11, "frame"

    const-string v12, "noframes"

    const-string v13, "section"

    const-string v14, "nav"

    const-string v15, "aside"

    const-string v16, "hgroup"

    const-string v17, "header"

    const-string v18, "footer"

    const-string v19, "p"

    const-string v20, "h1"

    const-string v21, "h2"

    const-string v22, "h3"

    const-string v23, "h4"

    const-string v24, "h5"

    const-string v25, "h6"

    const-string v26, "ul"

    const-string v27, "ol"

    const-string v28, "pre"

    const-string v29, "div"

    const-string v30, "blockquote"

    const-string v31, "hr"

    const-string v32, "address"

    const-string v33, "figure"

    const-string v34, "figcaption"

    const-string v35, "form"

    const-string v36, "fieldset"

    const-string v37, "ins"

    const-string v38, "del"

    const-string v39, "dl"

    const-string v40, "dt"

    const-string v41, "dd"

    const-string v42, "li"

    const-string v43, "table"

    const-string v44, "caption"

    const-string v45, "thead"

    const-string v46, "tfoot"

    const-string v47, "tbody"

    const-string v48, "colgroup"

    const-string v49, "col"

    const-string v50, "tr"

    const-string v51, "th"

    const-string v52, "td"

    const-string v53, "video"

    const-string v54, "audio"

    const-string v55, "canvas"

    const-string v56, "details"

    const-string v57, "menu"

    const-string v58, "plaintext"

    const-string v59, "template"

    const-string v60, "article"

    const-string v61, "main"

    const-string v62, "svg"

    const-string v63, "math"

    const-string v64, "center"

    const-string v65, "template"

    const-string v66, "dir"

    const-string v67, "applet"

    const-string v68, "marquee"

    const-string v69, "listing"

    .line 262
    filled-new-array/range {v1 .. v69}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lorg/jsoup/parser/Tag;->blockTags:[Ljava/lang/String;

    const-string v1, "object"

    const-string v2, "base"

    const-string v3, "font"

    const-string v4, "tt"

    const-string v5, "i"

    const-string v6, "b"

    const-string v7, "u"

    const-string v8, "big"

    const-string v9, "small"

    const-string v10, "em"

    const-string v11, "strong"

    const-string v12, "dfn"

    const-string v13, "code"

    const-string v14, "samp"

    const-string v15, "kbd"

    const-string v16, "var"

    const-string v17, "cite"

    const-string v18, "abbr"

    const-string v19, "time"

    const-string v20, "acronym"

    const-string v21, "mark"

    const-string v22, "ruby"

    const-string v23, "rt"

    const-string v24, "rp"

    const-string v25, "rtc"

    const-string v26, "a"

    const-string v27, "img"

    const-string v28, "br"

    const-string v29, "wbr"

    const-string v30, "map"

    const-string v31, "q"

    const-string v32, "sub"

    const-string v33, "sup"

    const-string v34, "bdo"

    const-string v35, "iframe"

    const-string v36, "embed"

    const-string v37, "span"

    const-string v38, "input"

    const-string v39, "select"

    const-string v40, "textarea"

    const-string v41, "label"

    const-string v42, "button"

    const-string v43, "optgroup"

    const-string v44, "option"

    const-string v45, "legend"

    const-string v46, "datalist"

    const-string v47, "keygen"

    const-string v48, "output"

    const-string v49, "progress"

    const-string v50, "meter"

    const-string v51, "area"

    const-string v52, "param"

    const-string v53, "source"

    const-string v54, "track"

    const-string v55, "summary"

    const-string v56, "command"

    const-string v57, "device"

    const-string v58, "area"

    const-string v59, "basefont"

    const-string v60, "bgsound"

    const-string v61, "menuitem"

    const-string v62, "param"

    const-string v63, "source"

    const-string v64, "track"

    const-string v65, "data"

    const-string v66, "bdi"

    const-string v67, "s"

    const-string v68, "strike"

    const-string v69, "nobr"

    const-string v70, "rb"

    const-string v71, "text"

    const-string v72, "mi"

    const-string v73, "mo"

    const-string v74, "msup"

    const-string v75, "mn"

    const-string v76, "mtext"

    .line 271
    filled-new-array/range {v1 .. v76}, [Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lorg/jsoup/parser/Tag;->inlineTags:[Ljava/lang/String;

    const-string v2, "meta"

    const-string v3, "link"

    const-string v4, "base"

    const-string v5, "frame"

    const-string v6, "img"

    const-string v7, "br"

    const-string v8, "wbr"

    const-string v9, "embed"

    const-string v10, "hr"

    const-string v11, "input"

    const-string v12, "keygen"

    const-string v13, "col"

    const-string v14, "command"

    const-string v15, "device"

    const-string v16, "area"

    const-string v17, "basefont"

    const-string v18, "bgsound"

    const-string v19, "menuitem"

    const-string v20, "param"

    const-string v21, "source"

    const-string v22, "track"

    .line 282
    filled-new-array/range {v2 .. v22}, [Ljava/lang/String;

    move-result-object v2

    sput-object v2, Lorg/jsoup/parser/Tag;->emptyTags:[Ljava/lang/String;

    const-string v3, "title"

    const-string v4, "a"

    const-string v5, "p"

    const-string v6, "h1"

    const-string v7, "h2"

    const-string v8, "h3"

    const-string v9, "h4"

    const-string v10, "h5"

    const-string v11, "h6"

    const-string v12, "pre"

    const-string v13, "address"

    const-string v14, "li"

    const-string v15, "th"

    const-string v16, "td"

    const-string v17, "script"

    const-string v18, "style"

    const-string v19, "ins"

    const-string v20, "del"

    const-string v21, "s"

    .line 287
    filled-new-array/range {v3 .. v21}, [Ljava/lang/String;

    move-result-object v3

    sput-object v3, Lorg/jsoup/parser/Tag;->formatAsInlineTags:[Ljava/lang/String;

    const-string v4, "pre"

    const-string v5, "plaintext"

    const-string v6, "title"

    const-string v7, "textarea"

    .line 291
    filled-new-array {v4, v5, v6, v7}, [Ljava/lang/String;

    move-result-object v4

    sput-object v4, Lorg/jsoup/parser/Tag;->preserveWhitespaceTags:[Ljava/lang/String;

    const-string v8, "button"

    const-string v9, "fieldset"

    const-string v10, "input"

    const-string v11, "keygen"

    const-string v12, "object"

    const-string v13, "output"

    const-string v14, "select"

    const-string v15, "textarea"

    .line 296
    filled-new-array/range {v8 .. v15}, [Ljava/lang/String;

    move-result-object v5

    sput-object v5, Lorg/jsoup/parser/Tag;->formListedTags:[Ljava/lang/String;

    const-string v6, "input"

    const-string v8, "keygen"

    const-string v9, "object"

    const-string v10, "select"

    .line 299
    filled-new-array {v6, v8, v9, v10, v7}, [Ljava/lang/String;

    move-result-object v6

    sput-object v6, Lorg/jsoup/parser/Tag;->formSubmitTags:[Ljava/lang/String;

    .line 303
    new-instance v7, Ljava/util/HashMap;

    invoke-direct {v7}, Ljava/util/HashMap;-><init>()V

    sput-object v7, Lorg/jsoup/parser/Tag;->namespaces:Ljava/util/Map;

    const-string v8, "math"

    const-string v9, "mi"

    const-string v10, "mo"

    const-string v11, "msup"

    const-string v12, "mn"

    const-string v13, "mtext"

    .line 305
    filled-new-array/range {v8 .. v13}, [Ljava/lang/String;

    move-result-object v8

    const-string v9, "http://www.w3.org/1998/Math/MathML"

    invoke-interface {v7, v9, v8}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v8, "svg"

    const-string v9, "text"

    .line 306
    filled-new-array {v8, v9}, [Ljava/lang/String;

    move-result-object v8

    const-string v9, "http://www.w3.org/2000/svg"

    invoke-interface {v7, v9, v8}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 322
    new-instance v8, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda0;

    invoke-direct {v8}, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda0;-><init>()V

    invoke-static {v0, v8}, Lorg/jsoup/parser/Tag;->setupTags([Ljava/lang/String;Ljava/util/function/Consumer;)V

    .line 327
    new-instance v0, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda1;

    invoke-direct {v0}, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda1;-><init>()V

    invoke-static {v1, v0}, Lorg/jsoup/parser/Tag;->setupTags([Ljava/lang/String;Ljava/util/function/Consumer;)V

    .line 332
    new-instance v0, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda2;

    invoke-direct {v0}, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda2;-><init>()V

    invoke-static {v2, v0}, Lorg/jsoup/parser/Tag;->setupTags([Ljava/lang/String;Ljava/util/function/Consumer;)V

    .line 333
    new-instance v0, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda3;-><init>()V

    invoke-static {v3, v0}, Lorg/jsoup/parser/Tag;->setupTags([Ljava/lang/String;Ljava/util/function/Consumer;)V

    .line 334
    new-instance v0, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda4;

    invoke-direct {v0}, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda4;-><init>()V

    invoke-static {v4, v0}, Lorg/jsoup/parser/Tag;->setupTags([Ljava/lang/String;Ljava/util/function/Consumer;)V

    .line 335
    new-instance v0, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda5;

    invoke-direct {v0}, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda5;-><init>()V

    invoke-static {v5, v0}, Lorg/jsoup/parser/Tag;->setupTags([Ljava/lang/String;Ljava/util/function/Consumer;)V

    .line 336
    new-instance v0, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda6;

    invoke-direct {v0}, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda6;-><init>()V

    invoke-static {v6, v0}, Lorg/jsoup/parser/Tag;->setupTags([Ljava/lang/String;Ljava/util/function/Consumer;)V

    .line 337
    invoke-interface {v7}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 338
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, [Ljava/lang/String;

    new-instance v3, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda7;

    invoke-direct {v3, v1}, Lorg/jsoup/parser/Tag$$ExternalSyntheticLambda7;-><init>(Ljava/util/Map$Entry;)V

    invoke-static {v2, v3}, Lorg/jsoup/parser/Tag;->setupTags([Ljava/lang/String;Ljava/util/function/Consumer;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    .line 29
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    .line 21
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->isBlock:Z

    .line 22
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->formatAsBlock:Z

    const/4 v0, 0x0

    .line 23
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->empty:Z

    .line 24
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->selfClosing:Z

    .line 25
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->preserveWhitespace:Z

    .line 26
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->formList:Z

    .line 27
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->formSubmit:Z

    .line 30
    iput-object p1, p0, Lorg/jsoup/parser/Tag;->tagName:Ljava/lang/String;

    .line 31
    invoke-static {p1}, Lorg/jsoup/internal/Normalizer;->lowerCase(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lorg/jsoup/parser/Tag;->normalName:Ljava/lang/String;

    .line 32
    iput-object p2, p0, Lorg/jsoup/parser/Tag;->namespace:Ljava/lang/String;

    return-void
.end method

.method public static isKnownTag(Ljava/lang/String;)Z
    .locals 1

    .line 183
    sget-object v0, Lorg/jsoup/parser/Tag;->Tags:Ljava/util/Map;

    invoke-interface {v0, p0}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method static synthetic lambda$static$0(Lorg/jsoup/parser/Tag;)V
    .locals 1

    const/4 v0, 0x1

    .line 323
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->isBlock:Z

    .line 324
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->formatAsBlock:Z

    return-void
.end method

.method static synthetic lambda$static$1(Lorg/jsoup/parser/Tag;)V
    .locals 1

    const/4 v0, 0x0

    .line 328
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->isBlock:Z

    .line 329
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->formatAsBlock:Z

    return-void
.end method

.method static synthetic lambda$static$2(Lorg/jsoup/parser/Tag;)V
    .locals 1

    const/4 v0, 0x1

    .line 332
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->empty:Z

    return-void
.end method

.method static synthetic lambda$static$3(Lorg/jsoup/parser/Tag;)V
    .locals 1

    const/4 v0, 0x0

    .line 333
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->formatAsBlock:Z

    return-void
.end method

.method static synthetic lambda$static$4(Lorg/jsoup/parser/Tag;)V
    .locals 1

    const/4 v0, 0x1

    .line 334
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->preserveWhitespace:Z

    return-void
.end method

.method static synthetic lambda$static$5(Lorg/jsoup/parser/Tag;)V
    .locals 1

    const/4 v0, 0x1

    .line 335
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->formList:Z

    return-void
.end method

.method static synthetic lambda$static$6(Lorg/jsoup/parser/Tag;)V
    .locals 1

    const/4 v0, 0x1

    .line 336
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->formSubmit:Z

    return-void
.end method

.method static synthetic lambda$static$7(Ljava/util/Map$Entry;Lorg/jsoup/parser/Tag;)V
    .locals 0

    .line 338
    invoke-interface {p0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    iput-object p0, p1, Lorg/jsoup/parser/Tag;->namespace:Ljava/lang/String;

    return-void
.end method

.method private static setupTags([Ljava/lang/String;Ljava/util/function/Consumer;)V
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Ljava/lang/String;",
            "Ljava/util/function/Consumer<",
            "Lorg/jsoup/parser/Tag;",
            ">;)V"
        }
    .end annotation

    .line 311
    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 312
    sget-object v3, Lorg/jsoup/parser/Tag;->Tags:Ljava/util/Map;

    invoke-interface {v3, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lorg/jsoup/parser/Tag;

    if-nez v4, :cond_0

    .line 314
    new-instance v4, Lorg/jsoup/parser/Tag;

    const-string v5, "http://www.w3.org/1999/xhtml"

    invoke-direct {v4, v2, v5}, Lorg/jsoup/parser/Tag;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 315
    iget-object v2, v4, Lorg/jsoup/parser/Tag;->tagName:Ljava/lang/String;

    invoke-interface {v3, v2, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 317
    :cond_0
    invoke-interface {p1, v4}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lorg/jsoup/parser/Tag;
    .locals 2

    .line 104
    sget-object v0, Lorg/jsoup/parser/ParseSettings;->preserveCase:Lorg/jsoup/parser/ParseSettings;

    const-string v1, "http://www.w3.org/1999/xhtml"

    invoke-static {p0, v1, v0}, Lorg/jsoup/parser/Tag;->valueOf(Ljava/lang/String;Ljava/lang/String;Lorg/jsoup/parser/ParseSettings;)Lorg/jsoup/parser/Tag;

    move-result-object p0

    return-object p0
.end method

.method public static valueOf(Ljava/lang/String;Ljava/lang/String;Lorg/jsoup/parser/ParseSettings;)Lorg/jsoup/parser/Tag;
    .locals 3

    .line 68
    invoke-static {p0}, Lorg/jsoup/helper/Validate;->notEmpty(Ljava/lang/String;)V

    .line 69
    invoke-static {p1}, Lorg/jsoup/helper/Validate;->notNull(Ljava/lang/Object;)V

    .line 70
    sget-object v0, Lorg/jsoup/parser/Tag;->Tags:Ljava/util/Map;

    invoke-interface {v0, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/jsoup/parser/Tag;

    if-eqz v1, :cond_0

    .line 71
    iget-object v2, v1, Lorg/jsoup/parser/Tag;->namespace:Ljava/lang/String;

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    return-object v1

    .line 74
    :cond_0
    invoke-virtual {p2, p0}, Lorg/jsoup/parser/ParseSettings;->normalizeTag(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 75
    invoke-static {p0}, Lorg/jsoup/helper/Validate;->notEmpty(Ljava/lang/String;)V

    .line 76
    invoke-static {p0}, Lorg/jsoup/internal/Normalizer;->lowerCase(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 77
    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/jsoup/parser/Tag;

    if-eqz v0, :cond_2

    .line 78
    iget-object v2, v0, Lorg/jsoup/parser/Tag;->namespace:Ljava/lang/String;

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 79
    invoke-virtual {p2}, Lorg/jsoup/parser/ParseSettings;->preserveTagCase()Z

    move-result p1

    if-eqz p1, :cond_1

    invoke-virtual {p0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_1

    .line 80
    invoke-virtual {v0}, Lorg/jsoup/parser/Tag;->clone()Lorg/jsoup/parser/Tag;

    move-result-object v0

    .line 81
    iput-object p0, v0, Lorg/jsoup/parser/Tag;->tagName:Ljava/lang/String;

    :cond_1
    return-object v0

    .line 87
    :cond_2
    new-instance p2, Lorg/jsoup/parser/Tag;

    invoke-direct {p2, p0, p1}, Lorg/jsoup/parser/Tag;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p0, 0x0

    .line 88
    iput-boolean p0, p2, Lorg/jsoup/parser/Tag;->isBlock:Z

    return-object p2
.end method

.method public static valueOf(Ljava/lang/String;Lorg/jsoup/parser/ParseSettings;)Lorg/jsoup/parser/Tag;
    .locals 1

    const-string v0, "http://www.w3.org/1999/xhtml"

    .line 119
    invoke-static {p0, v0, p1}, Lorg/jsoup/parser/Tag;->valueOf(Ljava/lang/String;Ljava/lang/String;Lorg/jsoup/parser/ParseSettings;)Lorg/jsoup/parser/Tag;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method protected bridge synthetic clone()Ljava/lang/Object;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/CloneNotSupportedException;
        }
    .end annotation

    .line 15
    invoke-virtual {p0}, Lorg/jsoup/parser/Tag;->clone()Lorg/jsoup/parser/Tag;

    move-result-object v0

    return-object v0
.end method

.method protected clone()Lorg/jsoup/parser/Tag;
    .locals 2

    .line 254
    :try_start_0
    invoke-super {p0}, Ljava/lang/Object;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/jsoup/parser/Tag;
    :try_end_0
    .catch Ljava/lang/CloneNotSupportedException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    move-exception v0

    .line 256
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 4

    const/4 v0, 0x1

    if-ne p0, p1, :cond_0

    return v0

    .line 219
    :cond_0
    instance-of v1, p1, Lorg/jsoup/parser/Tag;

    const/4 v2, 0x0

    if-nez v1, :cond_1

    return v2

    .line 221
    :cond_1
    check-cast p1, Lorg/jsoup/parser/Tag;

    .line 223
    iget-object v1, p0, Lorg/jsoup/parser/Tag;->tagName:Ljava/lang/String;

    iget-object v3, p1, Lorg/jsoup/parser/Tag;->tagName:Ljava/lang/String;

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    return v2

    .line 224
    :cond_2
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->empty:Z

    iget-boolean v3, p1, Lorg/jsoup/parser/Tag;->empty:Z

    if-eq v1, v3, :cond_3

    return v2

    .line 225
    :cond_3
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->formatAsBlock:Z

    iget-boolean v3, p1, Lorg/jsoup/parser/Tag;->formatAsBlock:Z

    if-eq v1, v3, :cond_4

    return v2

    .line 226
    :cond_4
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->isBlock:Z

    iget-boolean v3, p1, Lorg/jsoup/parser/Tag;->isBlock:Z

    if-eq v1, v3, :cond_5

    return v2

    .line 227
    :cond_5
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->preserveWhitespace:Z

    iget-boolean v3, p1, Lorg/jsoup/parser/Tag;->preserveWhitespace:Z

    if-eq v1, v3, :cond_6

    return v2

    .line 228
    :cond_6
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->selfClosing:Z

    iget-boolean v3, p1, Lorg/jsoup/parser/Tag;->selfClosing:Z

    if-eq v1, v3, :cond_7

    return v2

    .line 229
    :cond_7
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->formList:Z

    iget-boolean v3, p1, Lorg/jsoup/parser/Tag;->formList:Z

    if-eq v1, v3, :cond_8

    return v2

    .line 230
    :cond_8
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->formSubmit:Z

    iget-boolean p1, p1, Lorg/jsoup/parser/Tag;->formSubmit:Z

    if-ne v1, p1, :cond_9

    goto :goto_0

    :cond_9
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public formatAsBlock()Z
    .locals 1

    .line 137
    iget-boolean v0, p0, Lorg/jsoup/parser/Tag;->formatAsBlock:Z

    return v0
.end method

.method public getName()Ljava/lang/String;
    .locals 1

    .line 41
    iget-object v0, p0, Lorg/jsoup/parser/Tag;->tagName:Ljava/lang/String;

    return-object v0
.end method

.method public hashCode()I
    .locals 2

    .line 235
    iget-object v0, p0, Lorg/jsoup/parser/Tag;->tagName:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v0

    mul-int/lit8 v0, v0, 0x1f

    .line 236
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->isBlock:Z

    add-int/2addr v0, v1

    mul-int/lit8 v0, v0, 0x1f

    .line 237
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->formatAsBlock:Z

    add-int/2addr v0, v1

    mul-int/lit8 v0, v0, 0x1f

    .line 238
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->empty:Z

    add-int/2addr v0, v1

    mul-int/lit8 v0, v0, 0x1f

    .line 239
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->selfClosing:Z

    add-int/2addr v0, v1

    mul-int/lit8 v0, v0, 0x1f

    .line 240
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->preserveWhitespace:Z

    add-int/2addr v0, v1

    mul-int/lit8 v0, v0, 0x1f

    .line 241
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->formList:Z

    add-int/2addr v0, v1

    mul-int/lit8 v0, v0, 0x1f

    .line 242
    iget-boolean v1, p0, Lorg/jsoup/parser/Tag;->formSubmit:Z

    add-int/2addr v0, v1

    return v0
.end method

.method public isBlock()Z
    .locals 1

    .line 128
    iget-boolean v0, p0, Lorg/jsoup/parser/Tag;->isBlock:Z

    return v0
.end method

.method public isEmpty()Z
    .locals 1

    .line 155
    iget-boolean v0, p0, Lorg/jsoup/parser/Tag;->empty:Z

    return v0
.end method

.method public isFormListed()Z
    .locals 1

    .line 200
    iget-boolean v0, p0, Lorg/jsoup/parser/Tag;->formList:Z

    return v0
.end method

.method public isFormSubmittable()Z
    .locals 1

    .line 208
    iget-boolean v0, p0, Lorg/jsoup/parser/Tag;->formSubmit:Z

    return v0
.end method

.method public isInline()Z
    .locals 1

    .line 146
    iget-boolean v0, p0, Lorg/jsoup/parser/Tag;->isBlock:Z

    xor-int/lit8 v0, v0, 0x1

    return v0
.end method

.method public isKnownTag()Z
    .locals 2

    .line 173
    sget-object v0, Lorg/jsoup/parser/Tag;->Tags:Ljava/util/Map;

    iget-object v1, p0, Lorg/jsoup/parser/Tag;->tagName:Ljava/lang/String;

    invoke-interface {v0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method public isSelfClosing()Z
    .locals 1

    .line 164
    iget-boolean v0, p0, Lorg/jsoup/parser/Tag;->empty:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lorg/jsoup/parser/Tag;->selfClosing:Z

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    :goto_1
    return v0
.end method

.method public namespace()Ljava/lang/String;
    .locals 1

    .line 53
    iget-object v0, p0, Lorg/jsoup/parser/Tag;->namespace:Ljava/lang/String;

    return-object v0
.end method

.method public normalName()Ljava/lang/String;
    .locals 1

    .line 49
    iget-object v0, p0, Lorg/jsoup/parser/Tag;->normalName:Ljava/lang/String;

    return-object v0
.end method

.method public preserveWhitespace()Z
    .locals 1

    .line 192
    iget-boolean v0, p0, Lorg/jsoup/parser/Tag;->preserveWhitespace:Z

    return v0
.end method

.method setSelfClosing()Lorg/jsoup/parser/Tag;
    .locals 1

    const/4 v0, 0x1

    .line 212
    iput-boolean v0, p0, Lorg/jsoup/parser/Tag;->selfClosing:Z

    return-object p0
.end method

.method public toString()Ljava/lang/String;
    .locals 1

    .line 248
    iget-object v0, p0, Lorg/jsoup/parser/Tag;->tagName:Ljava/lang/String;

    return-object v0
.end method
