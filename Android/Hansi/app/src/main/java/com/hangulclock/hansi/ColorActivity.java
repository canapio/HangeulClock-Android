package com.hangulclock.hansi;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Bundle;
import android.app.Activity;
import android.support.v4.view.GestureDetectorCompat;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.Toast;

public class ColorActivity extends Activity implements
        GestureDetector.OnGestureListener {

    private static final String TAG = ClockActivity.class.getSimpleName();

    boolean mBlurred = false;
    FrameLayout activityV;

    boolean isBorderOn = false;

    private GestureDetectorCompat mDetector;


    TextView tvTop;

    // 상단 큰 시간
    TextView tvBigTime;
    TextView tvBigHour;

    // 상단 큰 오전/오후
    TextView tvAMPMUnit;
    TextView tvAMPM;

    // 상단 큰 분
    TextView tvBigMinUnit;
    TextView tvBigMin1;
    TextView tvBigMin2;
    TextView tvBigMin3;

    // 상단 큰 초
    TextView tvBigSecUnit;
    TextView tvBigSec1;
    TextView tvBigSec2;
    TextView tvBigSec3;

    // 하단 작은 text view
    TextView tvSmallYr;
    TextView tvSmallDate;
    TextView tvSmallDayOfWeek;
    TextView tvSmallAMPM;

    // Option menu listener
    private interface DialogListener {
        void onDialogOpen();
        void onDialogClose();
    }

    private DialogListener mDialogListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_color);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_NOSENSOR);

        mDetector = new GestureDetectorCompat(this, this);

        activityV = (FrameLayout) findViewById(R.id.colorlayout_v);
        activityV.getForeground().setAlpha(0);

        // Listener for dialog option menu
        mDialogListener = new DialogListener() {
            @Override
            public void onDialogOpen() {
                activityV.getForeground().setAlpha(220);
            }

            @Override
            public void onDialogClose() {
                activityV.getForeground().setAlpha(0);
            }
        };

        // 최상단 년월일
        tvTop = (TextView) findViewById(R.id.color_tv_top_v);

        // 상단 큰 시간
        tvBigTime = (TextView) findViewById(R.id.color_tv_big_time);
        tvBigHour = (TextView) findViewById(R.id.color_tv_big_hour);

        // 상단 큰 오전/오후
        tvAMPMUnit = (TextView) findViewById(R.id.color_tv_ampm_unit);
        tvAMPM = (TextView) findViewById(R.id.color_tv_ampm);

        // 상단 큰 분
        tvBigMinUnit = (TextView) findViewById(R.id.color_tv_big_min_unit);
        tvBigMin1 = (TextView) findViewById(R.id.color_tv_big_min_1);
        tvBigMin2 = (TextView) findViewById(R.id.color_tv_big_min_2);
        tvBigMin3 = (TextView) findViewById(R.id.color_tv_big_min_3);

        // 상단 큰 초
        tvBigSecUnit = (TextView) findViewById(R.id.color_tv_big_sec_unit);
        tvBigSec1 = (TextView) findViewById(R.id.color_tv_big_sec_1);
        tvBigSec2 = (TextView) findViewById(R.id.color_tv_big_sec_2);
        tvBigSec3 = (TextView) findViewById(R.id.color_tv_big_sec_3);

        // 하단 작은 text view
        tvSmallYr = (TextView) findViewById(R.id.color_tv_small_yr);
        tvSmallDate = (TextView) findViewById(R.id.color_tv_small_date);
        tvSmallDayOfWeek = (TextView) findViewById(R.id.color_tv_small_day_of_week);
        tvSmallAMPM = (TextView) findViewById(R.id.color_tv_small_ampm);


    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        this.mDetector.onTouchEvent(event);

        // Be sure to call the superclass implementation
        return super.onTouchEvent(event);
    }

    @Override
    public void onShowPress(MotionEvent e) {

    }

    @Override
    public void onLongPress(MotionEvent e) {
        Log.d(TAG, "LONG PRESSED");

        if(!mBlurred) {
            mDialogListener.onDialogOpen();
            mBlurred = true;
        }

        Dialog d = new AlertDialog.Builder(ColorActivity.this, AlertDialog.THEME_DEVICE_DEFAULT_DARK)
                .setItems(new String[]{"테두리 보이기/숨기기", "사용방법", "취소"}, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dlg, int position) {
                        if (position == 0) {

                        }

                        else if (position == 1) {

                        }

                        else {
                            mDialogListener.onDialogClose();
                            mBlurred = false;
                        }
                    }
                })
                .create();

        d.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                mDialogListener.onDialogClose();
            }
        });
        d.show();
    }

    @Override
    public boolean onSingleTapUp(MotionEvent e) {
        return false;
    }

    @Override
    public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX,
                            float distanceY) {
        return false;
    }

    @Override
    public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
        return false;
    }

    @Override
    public boolean onDown(MotionEvent e) {
        return false;
    }

    private void toggleBorder() {
        int sdk = android.os.Build.VERSION.SDK_INT;
        if (isBorderOn) {

            if (sdk < android.os.Build.VERSION_CODES.JELLY_BEAN) {
                tvAMPM.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
            } else {
                tvAMPM.setBackground(getResources().getDrawable(R.drawable.text_border));
            }
        }

        else {
            tvAMPM.setBackground(null);
        }
    }

    private void changeTVColor(TextView tv, Color color) {

    }


}
