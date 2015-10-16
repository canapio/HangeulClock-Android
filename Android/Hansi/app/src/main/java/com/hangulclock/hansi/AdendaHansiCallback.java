package com.hangulclock.hansi;

import android.content.Context;
import android.provider.Settings.Secure;

import sdk.adenda.widget.AdendaButtonCallback;

public class AdendaHansiCallback implements AdendaButtonCallback {

	private Context mContext;

	public AdendaHansiCallback(Context context)
	{
		mContext = context;
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
	public String getUserGender() {
		return "m";
	}

	@Override
	public String getUserDob() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public float getUserLatitude() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public float getUserLongitude() {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public void onPreOptIn() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onPreOptOut() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onPostOptIn() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onPostOptOut() {
		// TODO Auto-generated method stub

	}

}
