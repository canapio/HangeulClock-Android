package com.hangulclock.hansi;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.app.Activity;
import android.preference.PreferenceManager;
import android.view.Window;
import android.view.WindowManager;

import sdk.adenda.lockscreen.AdendaAgent;
import sdk.adenda.widget.AdendaButton;

public class OptionActivity extends Activity {
    private static final String IS_OPTED_IN = "isOptedIn";
    private SharedPreferences mPreference;
    private AdendaHansiCallback mAdendaCallback;

    private boolean isOptedIn;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_option);

        mPreference = PreferenceManager.getDefaultSharedPreferences(this);
        isOptedIn = mPreference.getBoolean(IS_OPTED_IN, false);

        mAdendaCallback = new AdendaHansiCallback(this);
        // Set Adenda button
        AdendaButton button = (AdendaButton) findViewById(R.id.lock_on_button);
        if (isOptedIn)
            button.setText("잠금화면 비활성화");
        else
            button.setText("잠금화면 활성화");

        button.setAdendaCallback(mAdendaCallback);

        AdendaAgent.setEnableAds(this, false);
    }

}
