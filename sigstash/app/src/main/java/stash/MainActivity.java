package stash;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;

public class MainActivity extends Activity {


    private FrameLayout frame;
    private LinearLayout tabbar;
    private PackageManager pm;
    private int bgClickable;
//    private ArrayList<Storage.App> allApps;
    private Storage storage;

    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        pm = getPackageManager();
        storage = new Storage(pm, this);




        final AppClick saver = new AppClick() {
            @Override
            public void clicked(Storage.App app) {
                storage.save(app);
            }
        };
        final AppClick apply = new AppClick() {
            @Override
            public void clicked(final Storage.App app) {
                final AppClick thizz = this;
                String[] listItems = {"remove", "apply"};

                AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
                builder.setTitle("what you wana do?");

                builder.setItems(listItems, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if (which == 0) {
                            storage.remove(app);
                            ScrollView scrollView = createList(storage.getSaved(), thizz);
                            frame.removeAllViews();
                            frame.addView(scrollView, MATCH_PARENT, MATCH_PARENT);
                        } else {
                            Toast.makeText(MainActivity.this, "select app to replace the signature", Toast.LENGTH_LONG).show();
                            AppClick clicker = new AppClick() {
                                @Override
                                public void clicked(Storage.App app2) {
                                    storage.apply(app2, app);
                                    ScrollView scrollView = createList(storage.getSaved(), thizz);
                                    frame.removeAllViews();
                                    frame.addView(scrollView, MATCH_PARENT, MATCH_PARENT);
                                }
                            };
                            ScrollView scrollView = createList(storage.getAll(), clicker);
                            frame.removeAllViews();
                            frame.addView(scrollView, MATCH_PARENT, MATCH_PARENT);
                        }
                    }
                });

                AlertDialog dialog = builder.create();
                dialog.show();
            }
        };



        TypedValue outValue = new TypedValue();
        getTheme().resolveAttribute(android.R.attr.selectableItemBackground, outValue, true);
        bgClickable = outValue.resourceId;
        createTabbar();
        addTab("all").setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                ScrollView scrollView = createList(storage.getAll(), saver);
                frame.removeAllViews();
                frame.addView(scrollView, MATCH_PARENT, MATCH_PARENT);
            }
        });
        addTab("saved").setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ScrollView scrollView = createList(storage.getSaved(), apply);
                frame.removeAllViews();
                frame.addView(scrollView, MATCH_PARENT, MATCH_PARENT);
            }
        });

        addTab("applied").setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                final View.OnClickListener onClickListener = this;
                Collection<Storage.App> values = storage.getApplied().values();
                ScrollView scrollView = createList(new ArrayList<>(values), new AppClick() {
                    @Override
                    public void clicked(Storage.App app) {
                        storage.unapply(app);
                        onClickListener.onClick(v);
                    }
                });
                frame.removeAllViews();
                frame.addView(scrollView, MATCH_PARENT, MATCH_PARENT);
            }
        });

        ScrollView scrollView = createList(storage.getAll(), saver);
        frame.addView(scrollView, MATCH_PARENT, MATCH_PARENT);
    }



    private TextView addTab(String all) {


        TextView tab1 = new TextView(this);
        tab1.setGravity(Gravity.CENTER);
        int dip48 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 48, getResources().getDisplayMetrics());
        tabbar.addView(tab1, new LinearLayout.LayoutParams(0, dip48, 1));
        tab1.setText(all);


        tab1.setBackgroundResource(bgClickable);

        return tab1;
    }

    private void createTabbar() {

        tabbar = new LinearLayout(this);
        tabbar.setOrientation(LinearLayout.HORIZONTAL);
        tabbar.setBackgroundColor(0xffeeeeee);

        frame = new FrameLayout(this);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.addView(frame, new LinearLayout.LayoutParams(MATCH_PARENT, 0, 1));
        root.addView(tabbar, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        setContentView(root);
    }

    private ScrollView createList(List<Storage.App> appList, final AppClick clicker) {
        ScrollView scrollView = new ScrollView(this);
        int dip48 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 48, getResources().getDisplayMetrics());
        int dip16 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 16, getResources().getDisplayMetrics());
        LinearLayout list = new LinearLayout(this);
        list.setOrientation(LinearLayout.VERTICAL);
        for (final Storage.App p : appList) {
            ImageView img = new ImageView(this);

            try {
                img.setImageDrawable(pm.getApplicationIcon(p.packageName));
            } catch (Exception e) {
            }

            TextView child = new TextView(this);
            child.setPadding(dip16, 0, 0, 0);
            child.setTextSize(16f);
            child.setEllipsize(TextUtils.TruncateAt.END);
            child.setMaxLines(1);
            child.setText(p.packageName);
            child.setGravity(Gravity.CENTER_VERTICAL);


            LinearLayout item = new LinearLayout(this);
            item.setPadding(dip16, 0, dip16, 0);
            item.setOrientation(LinearLayout.HORIZONTAL);
            item.addView(img, dip48, dip48);
            item.addView(child, MATCH_PARENT, dip48);
            item.setBackgroundResource(bgClickable);
            item.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    clicker.clicked(p);
                }
            });

            list.addView(item, MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        }
        scrollView.addView(list, MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        scrollView.setPadding(0, dip16, 0, dip16);
        scrollView.setClipToPadding(false);
        return scrollView;
    }

    interface AppClick {

        void clicked(Storage.App app);
    }
}
