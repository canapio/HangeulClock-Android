package com.hangulclock.hansi;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.annotation.MainThread;
import android.support.v4.view.GestureDetectorCompat;
import android.text.format.DateFormat;
import android.text.format.Time;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.Surface;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.RelativeLayout;
import android.widget.TextSwitcher;
import android.widget.TextView;
import android.widget.ViewSwitcher;

import org.w3c.dom.Text;

import java.text.SimpleDateFormat;
import java.util.Locale;

public class ClockActivity extends Activity implements
        GestureDetector.OnGestureListener {
    private static final String TAG = ClockActivity.class.getSimpleName();
    KoreanTranslator kt;

    String[] currTimeStr;
    String currHour = "";        // 한, 두, ...
    String currMin = "";         // 일, 이, ...
    String currSec = "";         // 일, 이, ...
    String currYr = "";          // 이천십오, 이천십육, ...
    String currMon = "";         // 일, 이, ...
    String currDay = "";         // 일, 이, ...
    String currDayOfWeek = "";  // 월, 화, ...
    String currAMPM = "";        // 후, 전

    int currOrientation;

    TextView tvTop;

    boolean isHourChanged = false;
    boolean isMinChanged = false;
    boolean isSecChanged = false;
    boolean isYrChanged = false;
    boolean isdayOfWeekChanged = false;
    boolean isAMPMChanged = false;

    DisplayMetrics metrics;

    private GestureDetectorCompat mDetector;

    private int lBound;
    private int uBound;
    private double brightness;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        if (getScreenOrientation(this) == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT ||
                getScreenOrientation(this) == ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT ||
                getScreenOrientation(this) == ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED) {
            setContentView(R.layout.activity_clock_v); // Portrait / Vertical mode
            currOrientation = 0;
            Log.d(TAG, " PORTRAIT MODE");
        } else {
            setContentView(R.layout.activity_clock_h); // Landscape / Horizontal mode
            Log.d(TAG, " LANDSCAPE");
            if (getScreenOrientation(this) == ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE)
                currOrientation = 2;
            else
                currOrientation = 1;
        }

        mDetector = new GestureDetectorCompat(this,this);
        metrics = new DisplayMetrics();

        calcBounds(currOrientation);

        final Typeface nanumGothic = Typeface.createFromAsset(getAssets(),"fonts/NanumGothic.ttf");
        final Typeface nanumGothicBold = Typeface.createFromAsset(getAssets(),"fonts/NanumGothicBold.ttf");
        final Typeface nanumGothicExtraBold = Typeface.createFromAsset(getAssets(),"fonts/NanumGothicExtraBold.ttf");
        final Typeface nanumGothicLight = Typeface.createFromAsset(getAssets(),"fonts/NanumGothicLight.ttf");

        // 최상단 년월일
        if (currOrientation == 0) {
            tvTop = (AutoResizeTextView) findViewById(R.id.tv_top_v);
        } else {
            tvTop = (TextView) findViewById(R.id.tv_top_h);
        }
        // 상단 큰 시간
        final TextView tvBigTime = (TextView) findViewById(R.id.tv_big_time);
        final TextView tvBigHour = (TextView) findViewById(R.id.tv_big_hour);

        // 상단 큰 오전/오후
        final TextView tvAMPMUnit = (TextView) findViewById(R.id.tv_ampm_unit);
        final TextView tvAMPM = (TextView) findViewById(R.id.tv_ampm);

        // 상단 큰 분
        final TextView tvBigMinUnit = (TextView) findViewById(R.id.tv_big_min_unit);
        final TextView tvBigMin1 = (TextView) findViewById(R.id.tv_big_min_1);
        final TextView tvBigMin2 = (TextView) findViewById(R.id.tv_big_min_2);
        final TextView tvBigMin3 = (TextView) findViewById(R.id.tv_big_min_3);

        // 상단 큰 초
        final TextView tvBigSecUnit = (TextView) findViewById(R.id.tv_big_sec_unit);
        final TextView tvBigSec1 = (TextView) findViewById(R.id.tv_big_sec_1);
        final TextView tvBigSec2 = (TextView) findViewById(R.id.tv_big_sec_2);
        final TextView tvBigSec3 = (TextView) findViewById(R.id.tv_big_sec_3);

        // 하단 작은 text view
        final TextView tvSmallYr = (TextView) findViewById(R.id.tv_small_yr);
        final TextView tvSmallDate = (TextView) findViewById(R.id.tv_small_date);
        final TextView tvSmallDayOfWeek = (TextView) findViewById(R.id.tv_small_day_of_week);
        final TextView tvSmallAMPM = (TextView) findViewById(R.id.tv_small_ampm);

       /*
        *   시간 : ExtraBold
        *   오후 : Bold
        *   분 : Light
        *   초 : Normal
        */
        tvTop.setTypeface(nanumGothic);
        tvBigTime.setTypeface(nanumGothicExtraBold);
        tvBigHour.setTypeface(nanumGothicExtraBold);
        tvAMPMUnit.setTypeface(nanumGothicBold);
        tvAMPM.setTypeface(nanumGothicBold);
        tvBigMinUnit.setTypeface(nanumGothicLight);
        tvBigMin1.setTypeface(nanumGothicLight);
        tvBigMin2.setTypeface(nanumGothicLight);
        tvBigMin3.setTypeface(nanumGothicLight);
        tvBigSecUnit.setTypeface(nanumGothic);
        tvBigSec1.setTypeface(nanumGothic);
        tvBigSec2.setTypeface(nanumGothic);
        tvBigSec3.setTypeface(nanumGothic);
        tvSmallYr.setTypeface(nanumGothic);
        tvSmallDate.setTypeface(nanumGothic);
        tvSmallDayOfWeek.setTypeface(nanumGothic);
        tvSmallAMPM.setTypeface(nanumGothic);

        kt = new KoreanTranslator();

        Clock clock = new Clock(this);
        clock.setClockTickListener(new Clock.OnClockTickListener() {

            @Override
            public void OnSecondTick(Time currentTime) {
                SimpleDateFormat mSimpleDataFormat = new SimpleDateFormat("yy:M:d:EEE:h:m:s:aa", Locale.ENGLISH);
                currTimeStr = mSimpleDataFormat.format(currentTime.toMillis(true)).toString().split(":");
                String tmp = "";

                for (int i = 0 ; i < currTimeStr.length; i++) {
                    switch(i) {
                        case 0:
                            if (currYr.equals(tmp =  "이천"+ kt.convert(currTimeStr[i],ConvertType.tcType_minute))) {
                                isYrChanged = false;
                                break;
                            }
                            currYr = tmp;
                            isYrChanged = true;
                            break;
                        case 1: currMon = kt.convert(currTimeStr[i],ConvertType.tcType_month); break;
                        case 2: currDay =  kt.convert(currTimeStr[i],ConvertType.tcType_minute); break;
                        case 3:
                            if (currDayOfWeek.equals(tmp =  kt.dayOfWeekHanhulWithIndex(currTimeStr[i]))) {
                                isdayOfWeekChanged = false;
                                break;
                            }
                            currDayOfWeek = tmp;
                            isdayOfWeekChanged = true;
                            break;
                        case 4:
                            if (currHour.equals(tmp =  kt.convert(currTimeStr[i], ConvertType.tcType_hour))) {
                                isHourChanged = false;
                                break;
                            }
                            currHour = tmp;
                            isHourChanged = true;
                            break;
                        case 5:
                            if (currMin.equals(tmp =  kt.convert(currTimeStr[i], ConvertType.tcType_minute))) {
                                isMinChanged = false;
                                break;
                            }
                            currMin = tmp;
                            isMinChanged = true;
                            break;
                        case 6:
                            if (currSec.equals(tmp =  kt.convert(currTimeStr[i], ConvertType.tcType_second))) {
                                isSecChanged = false;
                                break;
                            }
                            currSec = tmp;
                            isSecChanged = true;
                            break;
                        case 7:
                            if (currAMPM.equals(tmp = kt.timeAMPM(currTimeStr[i]))) {
                                isAMPMChanged = false;
                                break;
                            }
                            currAMPM = tmp;
                            isAMPMChanged = true;
                            break;
                    }
                }

                //Log.d("Current Time in Eng: ", mSimpleDataFormat.format(currentTime.toMillis(true)).toString());
                //Log.d("Current time: ",currYr+"년 "+currMon+"월 "+currDay+"일 "+currDayOfWeek+"요일 오"+currAMPM+" "+currHour+"시 "+currMin+"분 "+currSec+"초");

                tvTop.setText(addSpace("  " + currYr + "년 " + currMon + "월 " + currDay + "일 " + currDayOfWeek + "요일  "));
                tvSmallYr.setText(kt.linearHangul(currYr+"년"));
                if (isYrChanged) {
                    tvSmallYr.startAnimation(AnimationUtils.loadAnimation(ClockActivity.this, R.anim.fade_in_and_slide_down));
                }
                tvSmallDate.setText(kt.linearHangul(currMon + "월"+currDay + "일"));
                tvSmallDayOfWeek.setText(kt.linearHangul(currDayOfWeek + "요일"));
                if (isdayOfWeekChanged) {
                    tvTop.startAnimation(AnimationUtils.loadAnimation(ClockActivity.this, R.anim.fade_in_and_slide_down));
                    tvSmallDate.startAnimation(AnimationUtils.loadAnimation(ClockActivity.this, R.anim.fade_in_and_slide_down));
                    tvSmallDayOfWeek.startAnimation(AnimationUtils.loadAnimation(ClockActivity.this, R.anim.fade_in_and_slide_down));
                }
                tvAMPM.setText(currAMPM);
                tvSmallAMPM.setText(kt.linearHangul("오"+currAMPM));
                if (isAMPMChanged) {
                    tvAMPM.startAnimation(AnimationUtils.loadAnimation(ClockActivity.this, R.anim.fade_in_and_slide_down));
                    tvSmallAMPM.startAnimation(AnimationUtils.loadAnimation(ClockActivity.this, R.anim.fade_in_and_slide_down));
                }
                tvBigTime.setText(currHour);
                if (isHourChanged) tvBigTime.startAnimation(AnimationUtils.loadAnimation(ClockActivity.this, R.anim.fade_in_and_slide_down));
                tvBigMin1.setText(currMin);
                if (isMinChanged) tvBigMin1.startAnimation(AnimationUtils.loadAnimation(ClockActivity.this, R.anim.fade_in_and_slide_down));
                tvBigSec1.setText(currSec);
                tvBigSec1.startAnimation(AnimationUtils.loadAnimation(ClockActivity.this, R.anim.fade_in_and_slide_down));
            }
        });
    }

    public static int getScreenOrientation(Activity activity) {
        int rotation = activity.getWindowManager().getDefaultDisplay().getRotation();
        int orientation = activity.getResources().getConfiguration().orientation;
        if (orientation == Configuration.ORIENTATION_PORTRAIT) {
            if (rotation == Surface.ROTATION_0 || rotation == Surface.ROTATION_270) {
                return ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
            } else {
                return ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT;
            }
        }
        if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
            if (rotation == Surface.ROTATION_0 || rotation == Surface.ROTATION_90) {
                return ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE;
            } else {
                return ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE;
            }
        }
        return ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED;
    }


    private String addSpace(String str) {
        return str.replace("", "   ").trim();
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        this.mDetector.onTouchEvent(event);

        updateBrightness(event.getY());

        // Be sure to call the superclass implementation
        return super.onTouchEvent(event);
    }

    @Override
    public boolean onDown(MotionEvent e) {
        return false;
    }

    @Override
    public void onShowPress(MotionEvent e) {

    }

    @Override
    public boolean onSingleTapUp(MotionEvent e) {
        return false;
    }

    @Override
    public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX,
                            float distanceY) {
        //Log.d(TAG, "onScroll: " + e1.toString()+e2.toString());
        if (distanceY > 0) {
            Log.d(TAG, "going up!!");
        } else if (e1.getY() - e2.getY() < 0) {

        }
        return true;
    }

    @Override
    public void onLongPress(MotionEvent e) {

    }

    @Override
    public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
        return false;
    }

    public int getHeight() {
        return metrics.heightPixels;
    }

    public int getMargin(){
        final double heightPortraitPerc =  80f / 100f;
        final double heightLandscapePerc = 80f / 100f;

        double percent = (getScreenOrientation(this) == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT ||
                getScreenOrientation(this) == ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT ||
                getScreenOrientation(this) == ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED) ? heightPortraitPerc : heightLandscapePerc;
        return (int) ((getHeight() - percent * getHeight()) / 2);
    }

    public void calcBounds(int o) {
        metrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(metrics);
        lBound = getMargin();
        uBound = getHeight() - getMargin();
    }

    public void updateBrightness(float y) {
        float ratio = (y - lBound) / (uBound - lBound);
        float value = 255.0f - ratio * 255.0f;

        if (value < 20){
            value = 20;
        }
        else if (value > 255){
            value = 255;
        }

        WindowManager.LayoutParams lp = getWindow().getAttributes();
        lp.screenBrightness = value / 255.0f;

        getWindow().setAttributes(lp);
        brightness = value;
    }
}
