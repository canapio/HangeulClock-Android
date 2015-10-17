package com.hangulclock.hansi;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.app.Activity;
import android.preference.PreferenceManager;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;

import sdk.adenda.lockscreen.AdendaAgent;
import sdk.adenda.widget.AdendaButton;

public class OptionActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_option);

        final AdendaHansiCallback mAdendaCallback = new AdendaHansiCallback(this);
        // Set Adenda button
        AdendaButton button = (AdendaButton) findViewById(R.id.lock_on_button);

        button.setAdendaCallback(mAdendaCallback);

        AdendaAgent.setEnableAds(this, false);

        Button exitBtn = (Button) findViewById(R.id.btn_close_option);
        exitBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }
}
