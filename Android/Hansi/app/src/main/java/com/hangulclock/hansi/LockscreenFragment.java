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
import android.view.LayoutInflater;
import android.view.Surface;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AnimationUtils;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.Locale;

import sdk.adenda.lockscreen.fragments.AdendaFragmentInterface;

public class LockscreenFragment extends Fragment implements AdendaFragmentInterface {
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
    boolean isDayOfWeekChanged = false;
    boolean isAMPMChanged = false;

    FrameLayout activityH;
    FrameLayout activityV;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View view = null;
        if (currOrientation == 0)
            view = inflater.inflate(R.layout.lockscreen_layout, container, false);
        else
            view = inflater.inflate(R.layout.lockscreen_layout, container, false);

        if (getScreenOrientation(getActivity()) == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT ||
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
        }

        activityH = (FrameLayout) view.findViewById(R.id.mainlayout_v);
        activityV = activityH;

        final Typeface nanumGothic = Typeface.createFromAsset(getActivity().getAssets(), "fonts/NanumGothic.ttf");
        final Typeface nanumGothicBold = Typeface.createFromAsset(getActivity().getAssets(), "fonts/NanumGothicBold.ttf");
        final Typeface nanumGothicExtraBold = Typeface.createFromAsset(getActivity().getAssets(), "fonts/NanumGothicExtraBold.ttf");
        final Typeface nanumGothicLight = Typeface.createFromAsset(getActivity().getAssets(), "fonts/NanumGothicLight.ttf");

        // 최상단 년월일
        if (currOrientation == 0) {
            tvTop = (AutoResizeTextView) view.findViewById(R.id.frag_tv_top_v);
        } else {
            tvTop = (TextView) view.findViewById(R.id.frag_tv_top_v);
        }
        // 상단 큰 시간
        final TextView tvBigTime = (TextView) view.findViewById(R.id.frag_tv_big_time);
        final TextView tvBigHour = (TextView) view.findViewById(R.id.frag_tv_big_hour);

        // 상단 큰 오전/오후
        final TextView tvAMPMUnit = (TextView) view.findViewById(R.id.frag_tv_ampm_unit);
        final TextView tvAMPM = (TextView) view.findViewById(R.id.frag_tv_ampm);

        // 상단 큰 분
        final TextView tvBigMinUnit = (TextView) view.findViewById(R.id.frag_tv_big_min_unit);
        final TextView tvBigMin1 = (TextView) view.findViewById(R.id.frag_tv_big_min_1);
        final TextView tvBigMin2 = (TextView) view.findViewById(R.id.frag_tv_big_min_2);
        final TextView tvBigMin3 = (TextView) view.findViewById(R.id.frag_tv_big_min_3);

        // 상단 큰 초
        final TextView tvBigSecUnit = (TextView) view.findViewById(R.id.frag_tv_big_sec_unit);
        final TextView tvBigSec1 = (TextView) view.findViewById(R.id.frag_tv_big_sec_1);
        final TextView tvBigSec2 = (TextView) view.findViewById(R.id.frag_tv_big_sec_2);
        final TextView tvBigSec3 = (TextView) view.findViewById(R.id.frag_tv_big_sec_3);

        // 하단 작은 text view
        final TextView tvSmallYr = (TextView) view.findViewById(R.id.frag_tv_small_yr);
        final TextView tvSmallDate = (TextView) view.findViewById(R.id.frag_tv_small_date);
        final TextView tvSmallDayOfWeek = (TextView) view.findViewById(R.id.frag_tv_small_day_of_week);
        final TextView tvSmallAMPM = (TextView) view.findViewById(R.id.frag_tv_small_ampm);

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
}