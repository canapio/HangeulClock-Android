package com.hangulclock.hansi;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Typeface;
import android.os.Bundle;
import android.app.Fragment;
import android.os.PowerManager;
import android.text.format.Time;
import android.util.Log;
import android.util.Pair;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.Surface;
import android.view.View;
import android.view.ViewGroup;

import android.view.animation.AnimationUtils;
import android.widget.FrameLayout;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.Locale;

import sdk.adenda.lockscreen.fragments.AdendaFragmentInterface;

public class LockscreenFragment extends Fragment implements AdendaFragmentInterface {
    private static final String TAG = LockscreenFragment.class.getSimpleName();
    private final static String PREF_FONT = "FONTPREF";
    private static final int COLOR_WHITE = -1;

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

    Typeface[] typefaces;
    Typeface typeface_regular;
    Typeface typeface_bold;
    Typeface typeface_extraBold;
    Typeface typeface_light;

    boolean isHourChanged = false;
    boolean isMinChanged = false;
    boolean isSecChanged = false;
    boolean isYrChanged = false;
    boolean isDayOfWeekChanged = false;
    boolean isAMPMChanged = false;

    FrameLayout activityH;
    FrameLayout activityV;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        /*if (getScreenOrientation(getActivity()) == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT ||
                getScreenOrientation(getActivity()) == ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT ||
                getScreenOrientation(getActivity()) == ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED) {
            currOrientation = 0;
            Log.d(TAG, " PORTRAIT MODE");
        } else {
            Log.d(TAG, " LANDSCAPE");
            if (getScreenOrientation(getActivity()) == ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE)
                currOrientation = 2;
            else
                currOrientation = 1;
        }*/
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = null;
        //if (currOrientation == 0)
            view = inflater.inflate(R.layout.lockscreen_layout_v, container, false);
        //else
        //    view = inflater.inflate(R.layout.lockscreen_layout_h, container, false);

        final Activity currActivity = getActivity();
        currActivity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_NOSENSOR);

        activityH = (FrameLayout) view.findViewById(R.id.fragmentlayout_h);
        activityV = (FrameLayout) view.findViewById(R.id.fragmentlayout_v);

        // 최상단 년월일
        tvTop = (TextView) view.findViewById(R.id.frag_tv_top_v);

        /*if (currOrientation == 0) {
            tvTop = (TextView) view.findViewById(R.id.frag_tv_top_v);
        } else {
            tvTop = (TextView) view.findViewById(R.id.frag_tv_top_v);
        }*/

        // 상단 큰 시간
        tvBigTime = (TextView) view.findViewById(R.id.frag_tv_big_time);
        tvBigHour = (TextView) view.findViewById(R.id.frag_tv_big_hour);

        // 상단 큰 오전/오후
        tvAMPMUnit = (TextView) view.findViewById(R.id.frag_tv_ampm_unit);
        tvAMPM = (TextView) view.findViewById(R.id.frag_tv_ampm);

        // 상단 큰 분
        tvBigMinUnit = (TextView) view.findViewById(R.id.frag_tv_big_min_unit);
        tvBigMin1 = (TextView) view.findViewById(R.id.frag_tv_big_min_1);
        tvBigMin2 = (TextView) view.findViewById(R.id.frag_tv_big_min_2);
        tvBigMin3 = (TextView) view.findViewById(R.id.frag_tv_big_min_3);

        // 상단 큰 초
        tvBigSecUnit = (TextView) view.findViewById(R.id.frag_tv_big_sec_unit);
        tvBigSec1 = (TextView) view.findViewById(R.id.frag_tv_big_sec_1);
        tvBigSec2 = (TextView) view.findViewById(R.id.frag_tv_big_sec_2);
        tvBigSec3 = (TextView) view.findViewById(R.id.frag_tv_big_sec_3);

        // 하단 작은 text view
        tvSmallYr = (TextView) view.findViewById(R.id.frag_tv_small_yr);
        tvSmallDate = (TextView) view.findViewById(R.id.frag_tv_small_date);
        tvSmallDayOfWeek = (TextView) view.findViewById(R.id.frag_tv_small_day_of_week);
        tvSmallAMPM = (TextView) view.findViewById(R.id.frag_tv_small_ampm);

        setFontStyles(view.getContext());
        updateColor(view.getContext());

        kt = new KoreanTranslator();

        Clock clock = new Clock(getActivity());
        clock.setClockTickListener(new Clock.OnClockTickListener() {

            @Override
            public void OnSecondTick(Time currentTime) {
                final Activity activity = getActivity();
                if (activity == null)
                    return;

                SimpleDateFormat mSimpleDataFormat = new SimpleDateFormat("yy:M:d:EEE:h:m:s:aa", Locale.ENGLISH);
                currTimeStr = mSimpleDataFormat.format(currentTime.toMillis(true)).split(":");
                String tmp;

                for (int i = 0; i < currTimeStr.length; i++) {
                    switch (i) {
                        case 0:
                            if (currYr.equals(tmp = "이천" + kt.convert(currTimeStr[i], ConvertType.tcType_minute))) {
                                isYrChanged = false;
                                break;
                            }
                            currYr = tmp;
                            isYrChanged = true;
                            break;
                        case 1:
                            currMon = kt.convert(currTimeStr[i], ConvertType.tcType_month);
                            break;
                        case 2:
                            currDay = kt.convert(currTimeStr[i], ConvertType.tcType_minute);
                            break;
                        case 3:
                            if (currDayOfWeek.equals(tmp = kt.dayOfWeekHanhulWithIndex(currTimeStr[i]))) {
                                isDayOfWeekChanged = false;
                                break;
                            }
                            currDayOfWeek = tmp;
                            isDayOfWeekChanged = true;
                            break;
                        case 4:
                            if (currHour.equals(tmp = kt.convert(currTimeStr[i], ConvertType.tcType_hour))) {
                                isHourChanged = false;
                                break;
                            }
                            currHour = tmp;
                            isHourChanged = true;
                            break;
                        case 5:
                            if (currMin.equals(tmp = kt.convert(currTimeStr[i], ConvertType.tcType_minute))) {
                                isMinChanged = false;
                                break;
                            }
                            currMin = tmp;
                            isMinChanged = true;
                            break;
                        case 6:
                            if (currSec.equals(tmp = kt.convert(currTimeStr[i], ConvertType.tcType_second))) {
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
                tvSmallYr.setText(kt.linearHangul(currYr + "년"));
                if (isYrChanged) {
                    tvSmallYr.startAnimation(AnimationUtils.loadAnimation(activity, R.anim.fade_in_and_slide_down));
                }
                tvSmallDate.setText(kt.linearHangul(currMon + "월" + currDay + "일"));
                tvSmallDayOfWeek.setText(kt.linearHangul(currDayOfWeek + "요일"));
                if (isDayOfWeekChanged) {
                    tvTop.startAnimation(AnimationUtils.loadAnimation(activity, R.anim.fade_in_and_slide_down));
                    tvSmallDate.startAnimation(AnimationUtils.loadAnimation(activity, R.anim.fade_in_and_slide_down));
                    tvSmallDayOfWeek.startAnimation(AnimationUtils.loadAnimation(activity, R.anim.fade_in_and_slide_down));
                }
                tvAMPM.setText(currAMPM);
                tvSmallAMPM.setText(kt.linearHangul("오" + currAMPM));
                if (isAMPMChanged) {
                    tvAMPM.startAnimation(AnimationUtils.loadAnimation(activity, R.anim.fade_in_and_slide_down));
                    tvSmallAMPM.startAnimation(AnimationUtils.loadAnimation(activity, R.anim.fade_in_and_slide_down));
                }
                tvBigTime.setText(currHour);
                if (isHourChanged)
                    tvBigTime.startAnimation(AnimationUtils.loadAnimation(activity, R.anim.fade_in_and_slide_down));
                tvBigMin1.setText(currMin);
                if (isMinChanged)
                    tvBigMin1.startAnimation(AnimationUtils.loadAnimation(activity, R.anim.fade_in_and_slide_down));
                tvBigSec1.setText(currSec);
                tvBigSec1.startAnimation(AnimationUtils.loadAnimation(activity, R.anim.fade_in_and_slide_down));
            }

            @Override
            public void OnMinuteTick(Time currentTime) {
                // do nothing in this class
            }
        });

        setRetainInstance(true);

        return view;
    }

//    @Override
//    public void onResume() {
//        super.onResume();
//        setFontStyles();
//    }

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
    public Pair<Integer, Integer> getGlowpadResources() { return null; }

    @Override
    public boolean getStartHelperForResult() { return false; }

    @Override
    public boolean coverEntireScreen() {
        return true;
    }

    @Override
    public boolean expandOnRotation() {
        return true;
    }

    @Override
    public Intent getActionIntent() { return null; }

    @Override
    public void onActionFollowedAndLockScreenDismissed() { }


    boolean mScreenOn;
    ScreenStateReceiver mReceiver;

    private class ScreenStateReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(Intent.ACTION_SCREEN_OFF)) {
                mScreenOn = false;
                setFontStyles(context);
                updateColor(context);
            }
            else if (intent.getAction().equals(Intent.ACTION_SCREEN_ON)) {
                mScreenOn = true;
            }
        }
    }

    @Override
    public void onActivityCreated (Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        // Get initial screen state
        PowerManager pm = (PowerManager) getActivity().getSystemService(Context.POWER_SERVICE);
        mScreenOn = pm.isScreenOn();

        // Initialize Receiver
        intializeReceiver();
    }

    private void intializeReceiver() {
        // Instantiate receiver
        mReceiver = new ScreenStateReceiver();
        // Create Screen On and Screen Off filters for BroadcastReceiver
        IntentFilter screenFilter = new IntentFilter(Intent.ACTION_SCREEN_ON);
        screenFilter.addAction(Intent.ACTION_SCREEN_OFF);
        // Register screen filters
        getActivity().registerReceiver(mReceiver, screenFilter);
    }

    @Override
    public void onDetach() {
        super.onDetach();

        // Unregister receiver to avoid memory leaks!
        getActivity().unregisterReceiver(mReceiver);
    }

    private void setFontStyles(Context con) {
        Log.d(TAG, " setFontStyles from lockscreen called!!!!!!!");
        String font = MultiprocessPreferences.getDefaultSharedPreferences(con).getString("font","nanumgothic");
        FontChanger.setFont(con, font);
        Log.d(TAG, " CURRENT FONT: " + font);

        typefaces = FontChanger.getTypefaces();
        typeface_regular = typefaces[0];
        typeface_bold = typefaces[1];
        typeface_extraBold = typefaces[2];
        typeface_light = typefaces[3];

        /*
        *   시간 : ExtraBold
        *   오후 : Bold
        *   분 : Light
        *   초 : Normal
        */
        tvTop.setTypeface(typeface_regular);
        if (font.equals("nanumgothic")) {
            tvBigTime.setTypeface(typeface_extraBold);
            tvBigHour.setTypeface(typeface_extraBold);
        } else {
            tvBigTime.setTypeface(typeface_extraBold, Typeface.BOLD);
            tvBigHour.setTypeface(typeface_extraBold, Typeface.BOLD);
        }
        tvAMPMUnit.setTypeface(typeface_bold);
        tvAMPM.setTypeface(typeface_bold);
        tvBigMinUnit.setTypeface(typeface_light);
        tvBigMin1.setTypeface(typeface_light);
        tvBigMin2.setTypeface(typeface_light);
        tvBigMin3.setTypeface(typeface_light);
        tvBigSecUnit.setTypeface(typeface_regular);
        tvBigSec1.setTypeface(typeface_regular);
        tvBigSec2.setTypeface(typeface_regular);
        tvBigSec3.setTypeface(typeface_regular);
        tvSmallYr.setTypeface(typeface_regular);
        tvSmallDate.setTypeface(typeface_regular);
        tvSmallDayOfWeek.setTypeface(typeface_regular);
        tvSmallAMPM.setTypeface(typeface_regular);

        // Set sizes
        if (font.equals("nanumgothic")) {
            tvTop.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 11);
            tvBigTime.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 100);
            tvBigHour.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 100);
            tvAMPMUnit.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 35);
            tvAMPM.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 35);
            tvBigMinUnit.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 70);
            tvBigMin1.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 70);
            tvBigMin2.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 70);
            tvBigMin3.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 70);
            tvBigSecUnit.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 30);
            tvBigSec1.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 30);
            tvBigSec2.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 30);
            tvBigSec3.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 30);
            tvSmallYr.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 13);
            tvSmallDate.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 13);
            tvSmallDayOfWeek.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 13);
            tvSmallAMPM.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 13);
        } else {
            tvTop.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 14);
            tvBigTime.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 120);
            tvBigHour.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 120);
            tvAMPMUnit.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 45);
            tvAMPM.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 45);
            tvBigMinUnit.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 90);
            tvBigMin1.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 90);
            tvBigMin2.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 90);
            tvBigMin3.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 90);
            tvBigSecUnit.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 50);
            tvBigSec1.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 50);
            tvBigSec2.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 50);
            tvBigSec3.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 50);
            tvSmallYr.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 13);
            tvSmallDate.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 13);
            tvSmallDayOfWeek.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 13);
            tvSmallAMPM.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 13);
        }
    }

    private void updateColor(Context con) {
        MultiprocessPreferences.MultiprocessSharedPreferences mSharedPreferences
                = MultiprocessPreferences.getDefaultSharedPreferences(con);

        tvTop.setTextColor(mSharedPreferences.getInt("c_tvTop", COLOR_WHITE));
        tvBigTime.setTextColor(mSharedPreferences.getInt("c_tvBigTime", COLOR_WHITE));
        tvBigHour.setTextColor(mSharedPreferences.getInt("c_tvBigHour", COLOR_WHITE));
        tvAMPMUnit.setTextColor(mSharedPreferences.getInt("c_tvAMPMUnit", COLOR_WHITE));
        tvAMPM.setTextColor(mSharedPreferences.getInt("c_tvAMPM", COLOR_WHITE));
        tvBigMinUnit.setTextColor(mSharedPreferences.getInt("c_tvBigMinUnit", COLOR_WHITE));
        tvBigMin1.setTextColor(mSharedPreferences.getInt("c_tvBigMin1", COLOR_WHITE));
        tvBigMin2.setTextColor(mSharedPreferences.getInt("c_tvBigMin2", COLOR_WHITE));
        tvBigMin3.setTextColor(mSharedPreferences.getInt("c_tvBigMin3", COLOR_WHITE));
        tvBigSecUnit.setTextColor(mSharedPreferences.getInt("c_tvBigSecUnit", COLOR_WHITE));
        tvBigSec1.setTextColor(mSharedPreferences.getInt("c_tvBigSec1", COLOR_WHITE));
        tvBigSec2.setTextColor(mSharedPreferences.getInt("c_tvBigSec2", COLOR_WHITE));
        tvBigSec3.setTextColor(mSharedPreferences.getInt("c_tvBigSec3", COLOR_WHITE));
        tvSmallYr.setTextColor(mSharedPreferences.getInt("c_tvSmallYr", COLOR_WHITE));
        tvSmallDate.setTextColor(mSharedPreferences.getInt("c_tvSmallDate", COLOR_WHITE));
        tvSmallDayOfWeek.setTextColor(mSharedPreferences.getInt("c_tvSmallDayOfWeek", COLOR_WHITE));
        tvSmallAMPM.setTextColor(mSharedPreferences.getInt("c_tvSmallAMPM", COLOR_WHITE));

        boolean isBGChanged = mSharedPreferences.getBoolean("c_bg_changed", false);
        if (isBGChanged) {
            activityV.setBackground(null);
            activityV.setBackgroundColor(mSharedPreferences.getInt("c_bg", COLOR_WHITE));
        }
    }
}