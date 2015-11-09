package com.hangulclock.hansi;

import android.content.Context;
import android.graphics.Typeface;

/**
 * Created by Sean on 11/8/15.
 */
public class FontChanger {
    public static Typeface[] typefaces = new Typeface[4];

    public static void setFont(Context con, String font) {
        final Typeface regular;
        final Typeface bold;
        final Typeface extrabold;
        final Typeface light;

        switch (font) {
            case "nanumgothic":
                regular = Typeface.createFromAsset(con.getAssets(), "fonts/NanumGothic.ttf");
                bold = Typeface.createFromAsset(con.getAssets(), "fonts/NanumGothicBold.ttf");
                extrabold = Typeface.createFromAsset(con.getAssets(), "fonts/NanumGothicExtraBold.ttf");
                light = Typeface.createFromAsset(con.getAssets(), "fonts/NanumGothicLight.ttf");
                break;
            case "yanolja":
                regular = Typeface.createFromAsset(con.getAssets(), "fonts/yanoljaRegular.otf");
                bold = Typeface.createFromAsset(con.getAssets(), "fonts/yanoljaBold.otf");
                extrabold = Typeface.createFromAsset(con.getAssets(), "fonts/yanoljaBold.otf");
                light = Typeface.createFromAsset(con.getAssets(), "fonts/yanoljaRegular.otf");
                break;
            default:
                regular = Typeface.createFromAsset(con.getAssets(), "fonts/NanumGothic.ttf");
                bold = Typeface.createFromAsset(con.getAssets(), "fonts/NanumGothicBold.ttf");
                extrabold = Typeface.createFromAsset(con.getAssets(), "fonts/NanumGothicExtraBold.ttf");
                light = Typeface.createFromAsset(con.getAssets(), "fonts/NanumGothicLight.ttf");
                break;
        }

        typefaces[0] = regular;
        typefaces[1] = bold;
        typefaces[2] = extrabold;
        typefaces[3] = light;
    }

    public static Typeface[] getTypefaces() {
        return typefaces;
    }
}
