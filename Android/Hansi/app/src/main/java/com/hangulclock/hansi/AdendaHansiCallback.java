package com.hangulclock.hansi;

import android.content.Context;
import android.provider.Settings.Secure;

import sdk.adenda.lockscreen.AdendaAgent;
import sdk.adenda.widget.AdendaButtonCallback;

public class AdendaHansiCallback implements AdendaButtonCallback {

	private Context mContext;

	public AdendaHansiCallback(Context context)
	{
		mContext = context;
        AdendaAgent.setUnlockType(mContext, AdendaAgent.ADENDA_UNLOCK_TYPE_GLOWPAD);
        AdendaAgent.setGlowPadResources(mContext, R.drawable.glowpad_resources, R.array.adenda_custom_target_drawables);
	}
	
	@Override
	public String getUserId() {
		return getUserId(mContext);
	}
	
	public static String getUserId(Context context)
	{
		return Secure.getString(context.getContentResolver(), Secure.ANDROID_ID);
	}

	@Override
	public void onPostOptOut() {
		AdendaAgent.addCustomFragmentContent(mContext, null, "com.hangulclock.hansi.LockscreenFragment", null, null, true);
	}

	@Override
	public String getUserGender() {
		return "m";
	}

	@Override
	public String getUserDob() { return null; }
	@Override
	public float getUserLatitude() { return 0; }
	@Override
	public float getUserLongitude() { return 0;	}
	@Override
	public void onPreOptIn() {	}
	@Override
	public void onPreOptOut() {	}
	@Override
	public void onPostOptIn() {	}


}
