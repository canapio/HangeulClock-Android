package com.hangulclock.hansi;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;


public class FontSelectorActivity extends FragmentActivity {
    public final static int PAGES = 2;

    public final static int LOOPS = 1000;
    public final static int FIRST_PAGE = PAGES * LOOPS / 2;
    public final static float BIG_SCALE = 1.0f;
    public final static float SMALL_SCALE = 1.0f;
    public final static float DIFF_SCALE = BIG_SCALE - SMALL_SCALE;
    private final static String PREF_FONT = "FONTPREF";

    public MyPagerAdapter adapter;
    public ViewPager pager;
    private Button confirmButton;

    private SharedPreferences mSharedPreferences;
    private SharedPreferences.Editor mEditor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_NOSENSOR);

        setContentView(R.layout.activity_font_selector);

        mSharedPreferences = getSharedPreferences(PREF_FONT, Context.MODE_PRIVATE);
        mEditor = mSharedPreferences.edit();

        pager = (ViewPager) findViewById(R.id.font_selector_pager);

        adapter = new MyPagerAdapter(this, this.getSupportFragmentManager());
        pager.setAdapter(adapter);
        pager.setOnPageChangeListener(adapter);


        // Set current item to the middle page so we can fling to both directions left and right
        pager.setCurrentItem(FIRST_PAGE);

        // Necessary or the pager will only have one extra page to show make this at least however many pages you can see
        pager.setOffscreenPageLimit(3);

        // Set margin for pages as a negative number, so a part of next and previous pages will be showed
        pager.setPageMargin(-200);

        confirmButton = (Button) findViewById(R.id.btn_confirm_font_select);

        confirmButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                switch (FontSelectorPager.getPos()) {
                    case 0: mEditor.putString("font", "yanolja"); FontChanger.setFont(getApplicationContext(), "yanolja"); break;
                    case 1: mEditor.putString("font", "nanumgothic"); FontChanger.setFont(getApplicationContext(), "nanumgothic"); break;
                }
                mEditor.apply();
                Log.d("FontSelectorActivity", " Current font in preference -- " + mSharedPreferences.getString("font", "nanumgothic"));
                finish();
            }
        });
    }
}
