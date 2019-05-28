package stash;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.util.Base64;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import static android.content.Context.MODE_WORLD_READABLE;

public class Storage {
    public static final String PREF_NAME = "main";
    public static final String KEY_PACKAGE = "package";
    public static final String KEY_SIGNATURES = "signatures";
    public static final String KEY_SAVED = "saved";
    public static final String KEY_APPLIED = "KEY_APPLIED";
    final PackageManager pm;
    final Context ctx;

    public Storage(PackageManager pm, Context ctx) {
        this.pm = pm;
        this.ctx = ctx;
    }

    public void save(App app) {
        PackageInfo pi;
        try {
            pi = pm.getPackageInfo(app.packageName, PackageManager.GET_SIGNATURES);
        } catch (PackageManager.NameNotFoundException e) {
            throw new RuntimeException(e);
        }
        app.signatures = pi.signatures;
        JSONObject jsonObject = toJson(app);

        SharedPreferences pref = ctx.getSharedPreferences(PREF_NAME, MODE_WORLD_READABLE);
        String value = pref.getString(KEY_SAVED, "[]");
        JSONArray prev;
        try {
            prev = new JSONArray(value);
        } catch (JSONException e) {
            pref.edit().clear().commit();
            throw new RuntimeException(e);
        }
        prev.put(jsonObject);
        pref.edit()
                .putString(KEY_SAVED, prev.toString())
                .apply();


    }

    private JSONObject toJson(App app) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put(KEY_PACKAGE, app.packageName);
            JSONArray arr = new JSONArray();
            for (Signature sig : app.signatures) {
                String strSig = new String(Base64.encode(sig.toByteArray(), 0));
                arr.put(strSig);
            }
            jsonObject.put(KEY_SIGNATURES, arr);
        } catch (JSONException e) {
            throw new RuntimeException();
        }
        return jsonObject;
    }

    public List<App> getAll() {
        List<ApplicationInfo> packages = pm.getInstalledApplications(PackageManager.GET_META_DATA);
        ArrayList<App> allApps = new ArrayList<>();
        for (ApplicationInfo aPackage : packages) {
            allApps.add(new Storage.App(aPackage.packageName));
        }
        return allApps;
    }

    public List<App> getSaved() {
        SharedPreferences pref = ctx.getSharedPreferences(PREF_NAME, MODE_WORLD_READABLE);
        String value = pref.getString(KEY_SAVED, "[]");
        JSONArray prev;
        try {
            prev = new JSONArray(value);
            List<App> apps = new ArrayList<>();
            for (int i = 0; i < prev.length(); i++) {
                JSONObject it = prev.getJSONObject(i);
                apps.add(parse(it));
            }
            return apps;
        } catch (JSONException e) {
            pref.edit().clear().commit();
            throw new RuntimeException(e);
        }
    }

    public static App parse(JSONObject it) throws JSONException {
        String packageName = it.getString(KEY_PACKAGE);
        JSONArray signatures = it.getJSONArray(KEY_SIGNATURES);
        Signature[] jSignatures = new Signature[signatures.length()];
        for (int j = 0; j < signatures.length(); j++) {
            String strSig = signatures.getString(j);
            byte[] bs = Base64.decode(strSig, 0);
            jSignatures[j] = new Signature(bs);
        }
        App e = new App(packageName);
        e.signatures = jSignatures;
        return e;
    }

    public Map<String, App> getApplied() {
        SharedPreferences pref = ctx.getSharedPreferences(PREF_NAME, MODE_WORLD_READABLE);
        String strMap = pref.getString(KEY_APPLIED, "{}");

        try {
            return getAppliedImpl(strMap);
        } catch (JSONException e) {
            pref.edit().clear().commit();
            throw new AssertionError();
        }
    }

    public static Map<String, App> getAppliedImpl(String strMap) throws JSONException {
        JSONObject jsonObject;
        Map<String, App> res = new HashMap<>();
        jsonObject = new JSONObject(strMap);
        Iterator<String> keys = jsonObject.keys();
        while (keys.hasNext()) {
            String key = keys.next();
            App e = parse(jsonObject.getJSONObject(key));
            res.put(key, e);
        }
        return res;
    }

    public void unapply(App target) {
        Map<String, App> applied = getApplied();
        applied.remove(target.packageName);
        saveApplied(applied);
    }

    public void remove(App app) {
        List<App> saved = getSaved();
        JSONArray prev = new JSONArray();;
        for (int i = saved.size() - 1; i >= 0; i--) {
            App app1 = saved.get(i);
            if (app1.packageName.equals(app.packageName)) {
                saved.remove(app1);
            } else {
                prev.put(toJson(app1));
            }
        }


        SharedPreferences pref = ctx.getSharedPreferences(PREF_NAME, MODE_WORLD_READABLE);
        pref.edit()
                .putString(KEY_SAVED, prev.toString())
                .apply();

    }


    public void apply(App target, App signatureSource) {
        if (signatureSource.signatures == null) {
            throw new AssertionError();
        }
        Map<String, App> applied = getApplied();
        applied.put(target.packageName, signatureSource);
        saveApplied(applied);
    }

    private void saveApplied(Map<String, App> applied) {
        SharedPreferences pref = ctx.getSharedPreferences(PREF_NAME, MODE_WORLD_READABLE);
        JSONObject jsonObject = new JSONObject();
        for (Map.Entry<String, App> it : applied.entrySet()) {
            try {
                jsonObject.put(it.getKey(), toJson(it.getValue()));
            } catch (JSONException e) {
                pref.edit().clear().commit();
                throw new RuntimeException(e);
            }
        }
        pref.edit().putString(KEY_APPLIED, jsonObject.toString()).apply();
    }

    static class App {
        final String packageName;
        Signature[] signatures;

        App(String packageName) {
            this.packageName = packageName;
        }
    }
}
