package com.hangulclock.hansi;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.text.format.Time;
import android.util.Log;

import java.text.SimpleDateFormat;
import java.util.Locale;

/**
 * Created by han on 2015-10-11.
 */
public class ClockService extends Service {

    public static final String TAG = "ClockService";
    public static final String BROADCAST_STRING = "com.hangulclock.hansi.clock";

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

    boolean isHourChanged = false;
    boolean isMinChanged = false;
    boolean isSecChanged = false;
    boolean isYrChanged = false;
    boolean isdayOfWeekChanged = false;
    boolean isAMPMChanged = false;

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);

        kt = new KoreanTranslator();

        Clock clock = new Clock(getApplicationContext());
        clock.setClockTickListener(new Clock.OnClockTickListener() {

            @Override
            public void OnSecondTick(Time currentTime) {
                SimpleDateFormat mSimpleDataFormat = new SimpleDateFormat("yy:M:d:EEE:h:m:s:aa", Locale.ENGLISH);
                currTimeStr = mSimpleDataFormat.format(currentTime.toMillis(true)).toString().split(":");
                String tmp = "";

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
                                isdayOfWeekChanged = false;
                                break;
                            }
                            currDayOfWeek = tmp;
                            isdayOfWeekChanged = true;
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

                if (isMinChanged) {
                    Intent intent = new Intent();
                    intent.setAction(BROADCAST_STRING);
                    intent.putExtra("currYr", currYr);
                    intent.putExtra("currMon", currMon);
                    intent.putExtra("currDay", currDay);
                    intent.putExtra("currDayOfWeek", currDayOfWeek);
                    intent.putExtra("currHour", currHour);
                    intent.putExtra("currAMPM", currAMPM);
                    intent.putExtra("currMin", currMin);

                    Log.d(TAG, "sendBroadcast");

                    getBaseContext().sendBroadcast(intent);
                }
            }
        });
        return START_STICKY;
    }
}

