package com.hangulclock.hansi;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.app.Activity;
import android.preference.PreferenceManager;

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
