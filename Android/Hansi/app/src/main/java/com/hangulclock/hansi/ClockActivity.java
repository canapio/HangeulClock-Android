package com.hangulclock.hansi;

import android.annotation.TargetApi;
import android.app.Activity;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

public class ClockActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_clock);

        final Typeface nanumGothic = Typeface.createFromAsset(getAssets(),"fonts/NanumGothic.ttf");
        final Typeface nanumGothicBold = Typeface.createFromAsset(getAssets(),"fonts/NanumGothicBold.ttf");
        final Typeface nanumGothicExtraBold = Typeface.createFromAsset(getAssets(),"fonts/NanumGothicExtraBold.ttf");
        final Typeface nanumGothicLight = Typeface.createFromAsset(getAssets(),"fonts/NanumGothicLight.ttf");

        // 최상단 년월일
        final TextView tvTop = (TextView) findViewById(R.id.tv_top);

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

        /*
        시간 : ExtraBold
        오후 : Bold
        분 : Light
        초 : Normal
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








    }
}
