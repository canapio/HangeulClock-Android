package com.hangulclock.hansi;

/**
 * Created by Sean on 11/8/15.
 */
import android.content.Context;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class FontSelectorPager extends Fragment {
    public static int currPos;

    public static Fragment newInstance(FontSelectorActivity context, int pos, float scale) {
        Bundle b = new Bundle();
        b.putInt("pos", pos);
        currPos = pos;
        b.putFloat("scale", scale);
        return Fragment.instantiate(context, FontSelectorPager.class.getName(), b);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (container == null) {
            return null;
        }

        LinearLayout l = (LinearLayout) inflater.inflate(R.layout.font_carousel, container, false);

        final int pos = this.getArguments().getInt("pos");
        final TextView tv = (TextView) l.findViewById(R.id.tv_font_name);
        final ImageView iv = (ImageView) l.findViewById(R.id.iv_font_preview);
        final Typeface nanumGothic = Typeface.createFromAsset(getActivity().getAssets(), "fonts/NanumGothic.ttf");
        final Typeface yanolja = Typeface.createFromAsset(getActivity().getAssets(), "fonts/yanoljaRegular.otf");

        // TODO: check preference to take the user to the set position

        switch (pos) {
            case 0:
                tv.setText("나눔고딕");
                tv.setTypeface(nanumGothic);
                iv.setBackground(getDrawable(getContext(), R.drawable.nanumgothic_preview));
                setPos(pos);
                break;
            case 1:
                tv.setText("야놀자");
                tv.setTypeface(yanolja);
                iv.setBackground(getDrawable(getContext(), R.drawable.yanolja_preview));
                setPos(pos);
                break;
        }

        MyLinearLayout root = (MyLinearLayout) l.findViewById(R.id.root);
        float scale = this.getArguments().getFloat("scale");
        root.setScaleBoth(scale);

        return l;
    }

    private static Drawable getDrawable(Context context, int id) {
        final int version = Build.VERSION.SDK_INT;
        if (version >= 21) {
            return android.support.v4.content.ContextCompat.getDrawable(context, id);
        } else {
            return context.getResources().getDrawable(id);
        }
    }

    private void setPos(int pos) {
        currPos = pos;
    }

    public static int getPos() {
        Log.i("FontSelectorPager", " Current Pos: " + currPos);
        return currPos;
    }
}