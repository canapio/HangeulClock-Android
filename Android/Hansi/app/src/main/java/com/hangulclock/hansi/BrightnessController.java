package com.hangulclock.hansi;

import android.app.Activity;
import android.util.Log;
import android.view.WindowManager;

/**
 * Created by canapio on 2015. 10. 12..
 * This class control screen brightness.
 */
public class BrightnessController {
    Activity mainActivity;
    float currentRatio;
    float beforeRatio;

    BrightnessController (Activity activity) {
        mainActivity = activity;
        WindowManager.LayoutParams lp = mainActivity.getWindow().getAttributes();
        currentRatio = ((float)android.provider.Settings.System.getInt(mainActivity.getContentResolver(), android.provider.Settings.System.SCREEN_BRIGHTNESS, -1))/255.f;//lp.screenBrightness;
    }

    public void setUpInit (float y, float lBound, float uBound) {
        float ratio = ((y) - lBound) / (uBound - lBound);
        beforeRatio = 1.f-ratio;
    }
    public void updateBrightness(float y, float lBound, float uBound) {
        float ratio = ((y) - lBound) / (uBound - lBound);
        ratio = 1.f-ratio;

        currentRatio += (ratio - beforeRatio)*1.5f;
        Log.e("moving", "currentRatio : "+currentRatio);
        beforeRatio = ratio;



        if (currentRatio>1.f) {
            currentRatio = 1.f;
        } else if (currentRatio<16.f/255.f) {
            currentRatio = 16.f/255.f;
        }

        WindowManager.LayoutParams lp = mainActivity.getWindow().getAttributes();
        lp.screenBrightness = currentRatio;

        mainActivity.getWindow().setAttributes(lp);
    }
}
