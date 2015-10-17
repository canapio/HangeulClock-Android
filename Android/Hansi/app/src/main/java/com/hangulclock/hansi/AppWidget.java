package com.hangulclock.hansi;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.util.Log;
import android.widget.RemoteViews;

public class AppWidget extends AppWidgetProvider {

    public static final String TAG = "AppWidget";

    Typeface nanumGothic;
    Typeface nanumGothicBold;
    Typeface nanumGothicExtraBold;
    Typeface nanumGothicLight;

    Context mContext;

    String currHour = "";        // 한, 두, ...
    String currMin = "";         // 일, 이, ...
    String currYr = "";          // 이천십오, 이천십육, ...
    String currMon = "";         // 일, 이, ...
    String currDay = "";         // 일, 이, ...
    String currDayOfWeek = "";  // 월, 화, ...
    String currAMPM = "";        // 후, 전

    @Override
    public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);
        String action = intent.getAction();
        Log.d(TAG, "onReceive() action() " + action);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {

        final int N = appWidgetIds.length;
        Log.d(TAG, "onUpdate()" + N);
        for (int i = 0; i < N; i++) {
            updateAppWidget(context, appWidgetManager, appWidgetIds[i]);
            Log.d(TAG, "onUpdate()");
        }
    }

    @Override
    public void onDeleted(Context context, int[] appWidgetIds) {
        super.onDeleted(context, appWidgetIds);
        Intent intent = new Intent(context, ClockService.class);
        context.stopService(intent);
    }

    @Override
    public void onEnabled(Context context) {
        super.onEnabled(context);
    }

    @Override
    public void onDisabled(Context context) {
        super.onDisabled(context);
    }

    void updateAppWidget(final Context context, AppWidgetManager appWidgetManager,
                         int appWidgetId) {

        mContext = context;

        setClockReceiver(context);

        nanumGothic = Typeface.createFromAsset(context.getApplicationContext().getAssets(), "fonts/NanumGothic.ttf");
        nanumGothicBold = Typeface.createFromAsset(context.getApplicationContext().getAssets(), "fonts/NanumGothicBold.ttf");
        nanumGothicExtraBold = Typeface.createFromAsset(context.getApplicationContext().getAssets(), "fonts/NanumGothicExtraBold.ttf");
        nanumGothicLight = Typeface.createFromAsset(context.getApplicationContext().getAssets(), "fonts/NanumGothicLight.ttf");

        Intent intent = new Intent();
        intent.setClass(context, ClockService.class);
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
        context.startService(intent);

        RemoteViews views = updateRemoteViews();

        //Todo: 애니메이션 넣기
//                if (isdayOfWeekChanged) {
//                    tvTop.startAnimation(AnimationUtils.loadAnimation(context, R.anim.fade_in_and_slide_down));
//                }
//                tvAMPM.setText(currAMPM);
//                if (isAMPMChanged) {
//                    tvAMPM.startAnimation(AnimationUtils.loadAnimation(context, R.anim.fade_in_and_slide_down));
//                }
//                tvBigTime.setText(currHour);
//                if (isHourChanged)
//                    tvBigTime.startAnimation(AnimationUtils.loadAnimation(context, R.anim.fade_in_and_slide_down));
//                tvBigMin1.setText(currMin);
//                if (isMinChanged)
//                    tvBigMin1.startAnimation(AnimationUtils.loadAnimation(context, R.anim.fade_in_and_slide_down));
//                tvBigSec1.setText(currSec);
//                tvBigSec1.startAnimation(AnimationUtils.loadAnimation(context, R.anim.fade_in_and_slide_down));
//            }
//        });

        Intent eventIntent = new Intent(context, ClockActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, eventIntent, 0);
        views.setOnClickPendingIntent(R.id.appwidget_layout, pendingIntent);

        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    private Bitmap buildUpdate(int bmpWidth, int bmpHeight, String text, Typeface tf, float textSize) {
        Bitmap btmText = Bitmap.createBitmap(bmpWidth, bmpHeight, Bitmap.Config.ARGB_4444);
        Canvas cnvText = new Canvas(btmText);

        Paint paint = new Paint();
        paint.setAntiAlias(true);
        paint.setSubpixelText(true);
        paint.setTypeface(tf);
        paint.setColor(Color.WHITE);
        paint.setStyle(Paint.Style.FILL);
        paint.setTextAlign(Paint.Align.CENTER);
        paint.setTextSize(textSize);

        Log.d(TAG, " bitmap");

        cnvText.drawText(text, bmpWidth / 2, bmpHeight / 2 + (bmpHeight / 4), paint);
        return btmText;
    }

    private String addSpace(String str) {
        return str.replace("", "   ").trim();
    }

    public void setClockReceiver(Context context) {

        BroadcastReceiver mClockReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                currYr = intent.getStringExtra("currYr");
                currMon = intent.getStringExtra("currMon");
                currDay = intent.getStringExtra("currDay");
                currDayOfWeek = intent.getStringExtra("currDayOfWeek");
                currHour = intent.getStringExtra("currHour");
                currAMPM = intent.getStringExtra("currAMPM");
                currMin = intent.getStringExtra("currMin");

                Log.d(TAG, "BroadCast");

                RemoteViews views = updateRemoteViews();
                AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(mContext);
                ComponentName appWidgetId = new ComponentName(mContext, AppWidget.class);

                appWidgetManager.updateAppWidget(appWidgetId, views);
            }
        };

        IntentFilter filter = new IntentFilter();
        filter.addAction(ClockService.BROADCAST_STRING);
        context.getApplicationContext().registerReceiver(mClockReceiver, filter);
        Log.d(TAG, "registerReceiver");
    }

    public RemoteViews updateRemoteViews() {

        int length;
        int textWidth = 10;
        /**
         * widget information setting
         */
        RemoteViews views = new RemoteViews(mContext.getPackageName(), R.layout.app_widget);

        // 최상단 년월일
        views.setImageViewBitmap(R.id.iv_top_v, buildUpdate((int)ViewUtils.dpToPixel(mContext, 450), (int)ViewUtils.dpToPixel(mContext, 20), addSpace("  " + currYr + "년 " + currMon + "월 " + currDay + "일 " + currDayOfWeek + "요일  "), nanumGothic, ViewUtils.dpToPixel(mContext, 15)));

        length = currHour.length();
        Log.d(TAG, " "+length );
        if(length == 1){
            textWidth = 70;
        }else if(length == 2){
            textWidth = 130;
        }else if(length == 3){
            textWidth = 190;
        }else if(length == 4){
            textWidth = 240;
        }
        // 상단 큰 시간
        views.setImageViewBitmap(R.id.iv_big_time, buildUpdate((int)ViewUtils.dpToPixel(mContext, textWidth), (int)ViewUtils.dpToPixel(mContext, 80), currHour, nanumGothicExtraBold, ViewUtils.dpToPixel(mContext, 70)));
        views.setImageViewBitmap(R.id.iv_big_hour, buildUpdate((int)ViewUtils.dpToPixel(mContext, 70), (int)ViewUtils.dpToPixel(mContext, 80), "시", nanumGothicExtraBold, ViewUtils.dpToPixel(mContext, 70)));

        // 상단 큰 오전/오후
        views.setImageViewBitmap(R.id.iv_ampm_unit, buildUpdate((int)ViewUtils.dpToPixel(mContext, 20), (int)ViewUtils.dpToPixel(mContext, 30), "오", nanumGothicBold, ViewUtils.dpToPixel(mContext, 20)));
        views.setImageViewBitmap(R.id.iv_ampm, buildUpdate((int)ViewUtils.dpToPixel(mContext, 20), (int)ViewUtils.dpToPixel(mContext, 30), currAMPM, nanumGothicBold, ViewUtils.dpToPixel(mContext, 20)));

        length = currMin.length();
        Log.d(TAG, " "+length );
        if(length == 1){
            textWidth = 50;
        }else if(length == 2){
            textWidth = 68;
        }else if(length == 3){
            textWidth = 105;
        }else if(length == 4){
            textWidth = 140;
        }
        // 상단 큰 분
        views.setImageViewBitmap(R.id.iv_big_min_unit, buildUpdate((int)ViewUtils.dpToPixel(mContext, 50), (int)ViewUtils.dpToPixel(mContext, 60), "분", nanumGothicLight, ViewUtils.dpToPixel(mContext, 40)));
        views.setImageViewBitmap(R.id.iv_big_min_1, buildUpdate((int)ViewUtils.dpToPixel(mContext, textWidth), (int)ViewUtils.dpToPixel(mContext, 60), currMin, nanumGothicLight, ViewUtils.dpToPixel(mContext, 40)));
        views.setImageViewBitmap(R.id.iv_big_min_2, buildUpdate((int)ViewUtils.dpToPixel(mContext, 50), (int)ViewUtils.dpToPixel(mContext, 60), "영", nanumGothicLight, ViewUtils.dpToPixel(mContext, 40)));
        views.setImageViewBitmap(R.id.iv_big_min_3, buildUpdate((int)ViewUtils.dpToPixel(mContext, 50), (int)ViewUtils.dpToPixel(mContext, 60) , "영", nanumGothicLight, ViewUtils.dpToPixel(mContext, 40)));

        return views;
    }
}