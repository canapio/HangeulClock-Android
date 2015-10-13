package com.hangulclock.hansi;

import java.util.*;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.os.SystemClock;
import android.text.format.Time;
import android.util.Log;

/**
 * Created by Sean on 10/9/2015.
 */
public class Clock
{
    public interface OnClockTickListener {
        void OnSecondTick(Time currentTime);
        void OnMinuteTick(Time currentTime);
    }

    private Time time;
    private TimeZone TimeZone;
    private Handler Handler;
    private List<OnClockTickListener> OnClockTickListenerList = new ArrayList<OnClockTickListener>();

    private Runnable Ticker;

    private  BroadcastReceiver IntentReceiver;
    private IntentFilter IntentFilter;

    public static final int TICKPERSECOND=0;  // default tick method
    public static final int TICKPERMINUTE=1;

    private int tickMethod = 0;

    Context context;

    public Clock(Context context) {
        this(context, Clock.TICKPERSECOND);
    }

    public Clock(Context context, int tickMethod) {
        this.context=context;
        this.tickMethod = tickMethod;
        this.time = new Time();
        this.time.setToNow();

        switch (tickMethod) {
            case 0: this.startTickPerSecond(); break;
            case 1: this.startTickPerMinute(); break;
        }
        this.startTickPerSecond();
    }
    private void tick(long tickInMillis) {
        this.time.setToNow();
        //Log.d("called from " + context.toString(), time.toString());
        Clock.this.time.set(Clock.this.time.toMillis(true)+tickInMillis);
        this.notifyOnTickListeners();
    }

    private void notifyOnTickListeners() {
        switch (tickMethod) {
            case 0:
                for(OnClockTickListener listener:OnClockTickListenerList) {
                    listener.OnSecondTick(time);
                } break;

            case 1:
                for(OnClockTickListener listener:OnClockTickListenerList) {
                    listener.OnMinuteTick(time);
                } break;
        }
    }

    private void startTickPerSecond() {
        this.Handler=new Handler();
        this.Ticker = new Runnable()
        {
            public void run()
            {
                tick(1000);
                long now = SystemClock.uptimeMillis();
                long next = now + (1000 - now % 1000);
                Handler.postAtTime(Ticker, next);
            }
        };
        this.Ticker.run();
    }

    private void startTickPerMinute() {
        this.IntentReceiver= new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                tick(60000);
            }
        };
        this.IntentFilter = new IntentFilter();
        this.IntentFilter.addAction(Intent.ACTION_TIME_TICK);
        this.context.registerReceiver(this.IntentReceiver, this.IntentFilter, null, this.Handler);
    }

    public void stopTick() {
        if(this.IntentReceiver!=null) {
            this.context.unregisterReceiver(this.IntentReceiver);
        }

        if(this.Handler!=null) {
            this.Handler.removeCallbacks(this.Ticker);
        }
    }

    public Time getCurrentTime() {
        return this.time;
    }

    public void setClockTickListener(OnClockTickListener listener) {
        this.OnClockTickListenerList.add(listener);
    }
}
