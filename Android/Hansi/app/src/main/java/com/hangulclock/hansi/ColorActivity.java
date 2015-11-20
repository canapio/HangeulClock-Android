package com.hangulclock.hansi;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.pm.ActivityInfo;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Bundle;
import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.GestureDetectorCompat;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.Toast;

public class ColorActivity extends Activity implements
        GestureDetector.OnGestureListener {

    private static final String TAG = ClockActivity.class.getSimpleName();

    Context mContext;

    boolean mBlurred = false;
    FrameLayout activityV;

    boolean isBorderOn = false;

    private GestureDetectorCompat mDetector;

    private MultiprocessPreferences.MultiprocessSharedPreferences mSharedPreferences;
    private MultiprocessPreferences.Editor mEditor;

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

        mContext = this;

        mDetector = new GestureDetectorCompat(this, this);

        activityV = (FrameLayout) findViewById(R.id.colorlayout_v);
        activityV.getForeground().setAlpha(0);

        mSharedPreferences = MultiprocessPreferences.getDefaultSharedPreferences(this);
        mEditor = mSharedPreferences.edit();

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
        tvTop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvTop",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvTop", tvTop, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });

        // 상단 큰 시간
        tvBigTime = (TextView) findViewById(R.id.color_tv_big_time);
        tvBigTime.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvBigTime",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvBigTime", tvBigTime, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });

        tvBigHour = (TextView) findViewById(R.id.color_tv_big_hour);
        tvBigHour.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvBigHour",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvBigHour", tvBigHour, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });

        // 상단 큰 오전/오후
        tvAMPMUnit = (TextView) findViewById(R.id.color_tv_ampm_unit);
        tvAMPMUnit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvAMPMUnit",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvAMPMUnit", tvAMPMUnit, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        tvAMPM = (TextView) findViewById(R.id.color_tv_ampm);
        tvAMPM.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvAMPM",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvAMPM", tvAMPM, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });

        // 상단 큰 분
        tvBigMinUnit = (TextView) findViewById(R.id.color_tv_big_min_unit);
        tvBigMinUnit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvBigMinUnit",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvBigMinUnit", tvBigMinUnit, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        tvBigMin1 = (TextView) findViewById(R.id.color_tv_big_min_1);
        tvBigMin1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvBigMin1",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvBigMin1", tvBigMin1, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        tvBigMin2 = (TextView) findViewById(R.id.color_tv_big_min_2);
        tvBigMin2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvBigMin2",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvBigMin2", tvBigMin2, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        tvBigMin3 = (TextView) findViewById(R.id.color_tv_big_min_3);
        tvBigMin3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvBigMin3",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvBigMin3", tvBigMin3, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });

        // 상단 큰 초
        tvBigSecUnit = (TextView) findViewById(R.id.color_tv_big_sec_unit);
        tvBigSecUnit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvBigSecUnit",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvBigSecUnit", tvBigSecUnit, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        tvBigSec1 = (TextView) findViewById(R.id.color_tv_big_sec_1);
        tvBigSec1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvBigSec1",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvBigSec1", tvBigSec1, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        tvBigSec2 = (TextView) findViewById(R.id.color_tv_big_sec_2);
        tvBigSec2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvBigSec2",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvBigSec2", tvBigSec2, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        tvBigSec3 = (TextView) findViewById(R.id.color_tv_big_sec_3);
        tvBigSec3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvBigSec3",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvBigSec3", tvBigSec3, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });

        // 하단 작은 text view
        tvSmallYr = (TextView) findViewById(R.id.color_tv_small_yr);
        tvSmallYr.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvSmallYr",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvSmallYr", tvSmallYr, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        tvSmallDate = (TextView) findViewById(R.id.color_tv_small_date);
        tvSmallDate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvSmallDate",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvSmallDate", tvSmallDate, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        tvSmallDayOfWeek = (TextView) findViewById(R.id.color_tv_small_day_of_week);
        tvSmallDayOfWeek.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvSmallDayOfWeek",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvSmallDayOfWeek", tvSmallDayOfWeek, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        tvSmallAMPM = (TextView) findViewById(R.id.color_tv_small_ampm);
        tvSmallAMPM.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ColorPickerDialog(mContext, mSharedPreferences.getInt("tvSmallAMPM",0), new ColorPickerDialog.OnColorSelectedListener() {
                    @Override
                    public void onColorSelected(int color) {
                        setTVColor("tvSmallAMPM", tvSmallAMPM, color);
                        Log.d(TAG, "selected color: " + color);
                    }
                }).show();
            }
        });
        setFontStyles();
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
                .setItems(new String[]{"사용방법", "테두리 보이기/숨기기", "배경색 바꾸기", "취소"}, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dlg, int position) {
                        if (position == 0) {

                        }

                        else if (position == 1) {
                            toggleBorder();
                        }

                        else if (position == 2) {
                            new ColorPickerDialog(mContext, 0, new ColorPickerDialog.OnColorSelectedListener() {
                                @Override
                                public void onColorSelected(int color) {
                                    activityV.setBackground(null);
                                    activityV.setBackgroundColor(color);
                                    Log.d(TAG, "selected color: " + color);
                                }
                            }).show();

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

    @SuppressWarnings("deprecation")
    private void toggleBorder() {
        int sdk = android.os.Build.VERSION.SDK_INT;
        if (isBorderOn) {
            if (sdk < android.os.Build.VERSION_CODES.JELLY_BEAN) {
                tvTop.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvBigTime.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvBigHour.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvBigMinUnit.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvBigMin1.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvBigMin2.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvBigMin3.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvBigSecUnit.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvBigSec1.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvBigSec2.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvBigSec3.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvSmallYr.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvSmallDate.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvSmallDayOfWeek.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvSmallAMPM.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvAMPM.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
                tvAMPMUnit.setBackgroundDrawable(getResources().getDrawable(R.drawable.text_border));
            } else {
                if (sdk <= Build.VERSION_CODES.LOLLIPOP) {
                    tvTop.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvBigTime.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvBigHour.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvBigMinUnit.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvBigMin1.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvBigMin2.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvBigMin3.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvBigSecUnit.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvBigSec1.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvBigSec2.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvBigSec3.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvSmallYr.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvSmallDate.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvSmallDayOfWeek.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvSmallAMPM.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvAMPM.setBackground(getResources().getDrawable(R.drawable.text_border));
                    tvAMPMUnit.setBackground(getResources().getDrawable(R.drawable.text_border));
                } else {
                    tvTop.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvBigTime.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvBigHour.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvBigMinUnit.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvBigMin1.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvBigMin2.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvBigMin3.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvBigSecUnit.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvBigSec1.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvBigSec2.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvBigSec3.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvSmallYr.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvSmallDate.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvSmallDayOfWeek.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvSmallAMPM.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvAMPM.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                    tvAMPMUnit.setBackground(ContextCompat.getDrawable(this, R.drawable.text_border));
                }
            }
            isBorderOn = false;
        }

        else {
            tvTop.setBackground(null);
            tvBigTime.setBackground(null);
            tvBigHour.setBackground(null);
            tvBigMinUnit.setBackground(null);
            tvBigMin1.setBackground(null);
            tvBigMin2.setBackground(null);
            tvBigMin3.setBackground(null);
            tvBigSecUnit.setBackground(null);
            tvBigSec1.setBackground(null);
            tvBigSec2.setBackground(null);
            tvBigSec3.setBackground(null);
            tvSmallYr.setBackground(null);
            tvSmallDate.setBackground(null);
            tvSmallDayOfWeek.setBackground(null);
            tvSmallAMPM.setBackground(null);
            tvAMPM.setBackground(null);
            tvAMPMUnit.setBackground(null);

            isBorderOn = true;
        }
    }

    private void setTVColor(String name, TextView tv, int color) {
        tv.setTextColor(color);
        mEditor.putInt("c_" +name,color);
        mEditor.apply();
    }

    private void setFontStyles() {
        final Typeface typeface_regular = Typeface.createFromAsset(mContext.getAssets(), "fonts/NanumGothic.ttf");
        final Typeface typeface_bold = Typeface.createFromAsset(mContext.getAssets(), "fonts/NanumGothicBold.ttf");
        final Typeface typeface_extraBold = Typeface.createFromAsset(mContext.getAssets(), "fonts/NanumGothicExtraBold.ttf");
        final Typeface typeface_light = Typeface.createFromAsset(mContext.getAssets(), "fonts/NanumGothicLight.ttf");

        /*
        *   시간 : ExtraBold
        *   오후 : Bold
        *   분 : Light
        *   초 : Normal
        */
        tvTop.setTypeface(typeface_regular);
        tvBigTime.setTypeface(typeface_extraBold);
        tvBigHour.setTypeface(typeface_extraBold);
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
    }

}
