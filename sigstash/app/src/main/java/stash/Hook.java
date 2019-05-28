package stash;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Binder;
import android.util.Log;

import java.lang.reflect.Method;
import java.net.HttpURLConnection;
import java.net.Proxy;
import java.net.URL;
import java.security.cert.Certificate;
import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

import javax.net.ssl.HttpsURLConnection;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XSharedPreferences;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

import static de.robv.android.xposed.XposedHelpers.findAndHookConstructor;
import static de.robv.android.xposed.XposedHelpers.findAndHookMethod;
import static de.robv.android.xposed.XposedHelpers.findClass;

public class Hook implements IXposedHookLoadPackage {

    public static final String TAG = "sigstash";


    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam p) throws Exception {
        if (p.packageName.equals("com.vkontakte.android")) {
            XSharedPreferences pref = new XSharedPreferences("sig.stash", Storage.PREF_NAME);
            String strMap = pref.getString(Storage.KEY_APPLIED, "{}");
            Log.d(TAG, "hook config " + strMap);


            Class Thread = findClass("java.lang.Thread", p.classLoader);
            final XC_MethodHook threadLogger = new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                    Log.d(TAG, "thread created " + param.thisObject + " " + Arrays.toString(param.args), new Exception());
                }
            };
            try {
                findAndHookConstructor(Thread, threadLogger);
                findAndHookConstructor(Thread, Runnable.class, threadLogger);
                findAndHookConstructor(Thread, Runnable.class, String.class, threadLogger);
                findAndHookConstructor(Thread, ThreadGroup.class, Runnable.class, threadLogger);
                findAndHookConstructor(Thread, ThreadGroup.class, Runnable.class, String.class, threadLogger);
                findAndHookConstructor(Thread, ThreadGroup.class, Runnable.class, String.class, long.class, threadLogger);
                findAndHookConstructor(Thread, ThreadGroup.class, String.class, threadLogger);
                findAndHookConstructor(Thread, ThreadGroup.class, String.class, int.class, boolean.class, threadLogger);
            } catch (Exception e) {
                Log.d(TAG, "err", e);
            }

            final Map<String, Storage.App> appliedImpl = Storage.getAppliedImpl(strMap);
            Class ApplicationPackageManager = findClass("android.app.ApplicationPackageManager", p.classLoader);
            findAndHookMethod(ApplicationPackageManager, "getPackageInfo", String.class, int.class, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                    String packageName = (String) param.args[0];
                    int flags = (int) param.args[1];
                    Log.d(TAG, "getPackageInfo( "  + packageName + " , " + Integer.toHexString(flags) + " )" );
                    if ((flags & PackageManager.GET_SIGNATURES) != 0) {
                        Storage.App app = appliedImpl.get(packageName);
                        if (app != null && !param.hasThrowable()) {
                            String log = "replaced " + java.lang.Thread.currentThread() + " " + Binder.getCallingPid();
                            Log.d(TAG, log, new Exception());

//                            PackageInfo res = (PackageInfo) param.getResult();
//                            res.signatures = app.signatures;
                        }
                    }
                }
            });
            Log.d(TAG, "hook done " );
        }
    }

}
