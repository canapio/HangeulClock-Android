package com.hangulclock.hansi;

/**
 * Created by Sean on 11/8/15.
 */
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;

public class MyPagerAdapter extends FragmentPagerAdapter implements
        ViewPager.OnPageChangeListener {

    private MyLinearLayout cur = null;
    private MyLinearLayout next = null;
    private FontSelectorActivity context;
    private FragmentManager fm;
    private float scale;

    public MyPagerAdapter(FontSelectorActivity context, FragmentManager fm) {
        super(fm);
        this.fm = fm;
        this.context = context;
    }

    @Override
    public Fragment getItem(int position) {
        // make the first pager bigger than others
        if (position == FontSelectorActivity.FIRST_PAGE)
            scale = FontSelectorActivity.BIG_SCALE;
        else
            scale = FontSelectorActivity.SMALL_SCALE;

        position = position % FontSelectorActivity.PAGES;
        return FontSelectorPager.newInstance(context, position, scale);
    }

    @Override
    public int getCount() {
        return FontSelectorActivity.PAGES * FontSelectorActivity.LOOPS;
    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        if (positionOffset >= 0f && positionOffset <= 1f) {
            cur = getRootView(position);
            cur.setScaleBoth(FontSelectorActivity.BIG_SCALE - FontSelectorActivity.DIFF_SCALE * positionOffset);

            if (position < FontSelectorActivity.PAGES-1) {
                next = getRootView(position +1);
                next.setScaleBoth(FontSelectorActivity.SMALL_SCALE + FontSelectorActivity.DIFF_SCALE * positionOffset);
            }
        }
    }

    @Override
    public void onPageSelected(int position) {}

    @Override
    public void onPageScrollStateChanged(int state) {}

    private MyLinearLayout getRootView(int position) {
        return (MyLinearLayout)
                fm.findFragmentByTag(this.getFragmentTag(position))
                        .getView().findViewById(R.id.root);
    }

    private String getFragmentTag(int position) {
        return "android:switcher:" + context.pager.getId() + ":" + position;
    }
}
