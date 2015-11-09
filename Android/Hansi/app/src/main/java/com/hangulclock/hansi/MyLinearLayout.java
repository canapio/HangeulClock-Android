package com.hangulclock.hansi;

/**
 * Created by Sean on 11/8/15.
 */
import android.content.Context;
import android.graphics.Canvas;
import android.util.AttributeSet;
import android.widget.LinearLayout;

public class MyLinearLayout extends LinearLayout {
    private float scale = FontSelectorActivity.BIG_SCALE;

    public MyLinearLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public MyLinearLayout(Context context) {
        super(context);
    }

    public void setScaleBoth(float scale) {
        this.scale = scale;
        this.invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        //int w = this.getWidth();
        //int h = this.getHeight();
        //canvas.scale(scale, scale, w/2, h/2);

        super.onDraw(canvas);
    }
}
