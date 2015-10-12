package com.hangulclock.hansi;

import android.content.Context;
import android.util.TypedValue;

/**
 * Created by han on 2015-10-11.
 */
public class ViewUtils {

    public static float dpToPixel(Context context, int dp){
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, context.getResources().getDisplayMetrics());
    }
}
