package com.hangulclock.hansi;

import java.util.*;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.os.SystemClock;
import android.text.format.Time;

/**
 * Created by Sean on 10/9/2015.
 */
public class Clock
{
    public interface OnClockTickListener {
        public void OnSecondTick(Time currentTime);
    }

    private Time Time;
    private TimeZone TimeZone;
    private Handler Handler;
    private List<OnClockTickListener> OnClockTickListenerList = new ArrayList<OnClockTickListener>();

    private Runnable Ticker;

    private  BroadcastReceiver IntentReceiver;
    private IntentFilter IntentFilter;

    Context Context;

    public Clock(Context context) {
        this.Context=context;
        this.Time=new Time();
        this.Time.setToNow();

        this.startTickPerSecond();
    }
    private void tick(long tickInMillis) {
        Clock.this.Time.set(Clock.this.Time.toMillis(true)+tickInMillis);
        this.notifyOnTickListeners();
    }

    private void notifyOnTickListeners() {
        for(OnClockTickListener listener:OnClockTickListenerList) {
            listener.OnSecondTick(Time);
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

    public void stopTick() {
        if(this.IntentReceiver!=null) {
            this.Context.unregisterReceiver(this.IntentReceiver);
        }

        if(this.Handler!=null) {
            this.Handler.removeCallbacks(this.Ticker);
        }
    }

    public Time getCurrentTime() {
        return this.Time;
    }

    public void setClockTickListener(OnClockTickListener listener) {
        this.OnClockTickListenerList.add(listener);
    }
}
