package org.cocos2dx.lua.AD_inMobi;

/**
 * Created by Administrator on 2017/11/19.
 */
import org.cocos2dx.lua.AppActivity;

import android.graphics.Color;
import android.graphics.Point;
import android.os.Handler;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.inmobi.ads.InMobiAdRequest;
import com.inmobi.ads.InMobiAdRequestStatus;
import com.inmobi.ads.InMobiBanner;
import com.inmobi.sdk.InMobiSdk;

import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.atomic.AtomicInteger;

import org.cocos2dx.lua.SturaGameApplication;
import org.cocos2dx.lua.adBaseUnit;


import static com.google.android.gms.internal.zzahg.runOnUiThread;
public class inMobiUnit extends adBaseUnit {
    static final String TAG = "inMobi";
    static final String TAG_INMOBI_LISTENER = "TAG_INMOBI_LISTENER";

    private final Handler mHandler = new Handler();
    private InMobiBanner mBannerAd;
    private InMobiBanner mCurrBannerAd;

    public static final int BANNER_WIDTH = 320;
    public static final int BANNER_HEIGHT = 50;

    protected  int rtTimes = 1000*0;
    protected  boolean requestIndex = true;

    //最后一个是测试
    protected long placementID = 1511238989700L;//1511238989700L 1512290525192L 1520368613118L 1473189489298L
    protected String accountID = "d6033153bb3d4982a35b8c349c354f68";//d6033153bb3d4982a35b8c349c354f68 123456789abcdfghjiukljnm09874
    InMobiBanner.BannerAdRequestListener bannerAdRequestListener;
    InMobiAdRequest mInMobiAdRequest;
    LinearLayout contain;

    public boolean initSDK(AppActivity instance)
    {
        appActivity = instance;


        runOnUiThread(new Runnable()
        {

            @Override
            public void run()
            {

               //Fresco.initialize(appActivity);
                InMobiSdk.init(appActivity, accountID);
                InMobiSdk.setLogLevel(InMobiSdk.LogLevel.DEBUG);

                InMobiBanner bannerAd = new InMobiBanner(appActivity, placementID);

                mInMobiAdRequest = new InMobiAdRequest.Builder(placementID)
                        .setMonetizationContext(InMobiAdRequest.MonetizationContext.MONETIZATION_CONTEXT_ACTIVITY)
                        .setSlotSize(BANNER_WIDTH, BANNER_HEIGHT).build();
                bannerAdRequestListener = new InMobiBanner.BannerAdRequestListener() {
                    @Override
                    public void onAdRequestCompleted(InMobiAdRequestStatus inMobiAdRequestStatus, InMobiBanner inMobiBanner) {
                        InMobiAdRequestStatus.StatusCode st = inMobiAdRequestStatus.getStatusCode();
                        String errMsg = inMobiAdRequestStatus.getMessage();
                        if (null == errMsg)errMsg = new String("");
                        Log.d(TAG_INMOBI_LISTENER, String.format("onAdRequestCompleted：%s, %s", st, errMsg));
                        if (st == InMobiAdRequestStatus.StatusCode.NO_ERROR &&
                                null != inMobiBanner) {
                            setupBanner(inMobiBanner);
                        } else {

                        }

                    }
                };

                int width = toPixelUnits(BANNER_WIDTH);
                int height = toPixelUnits(BANNER_HEIGHT);
                Display display = appActivity.getWindowManager().getDefaultDisplay();
                Point pt = getDisplaySize(display);
                float ratio = (float)pt.x/(float)width;
                width = pt.x;
                height = (int)(height*ratio);
                LinearLayout.LayoutParams bannerLayoutParams = new LinearLayout.LayoutParams(width, height);
                //bannerLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
                //bannerLayoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
                contain = new LinearLayout(appActivity);
                contain.setTranslationY(display.getHeight() - height);
                contain.setLayoutParams(bannerLayoutParams);
                if (!contain.isEnabled()) contain.setEnabled(true);
                //contain.setBackgroundColor(Color.BLACK);
                //contain.addView(bannerAd);
                appActivity.addContentView(contain, bannerLayoutParams);
                requestLoadAd();
            }
        });

        return true;

    }

    private void setBannerLayoutParams() {
        int width = toPixelUnits(BANNER_WIDTH);
        int height = toPixelUnits(BANNER_HEIGHT);
        Display display = appActivity.getWindowManager().getDefaultDisplay();
        Point pt = getDisplaySize(display);

        RelativeLayout.LayoutParams bannerLayoutParams = new RelativeLayout.LayoutParams(width, height);
        bannerLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        bannerLayoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
        mBannerAd.setLayoutParams(bannerLayoutParams);
    }



    @Override
    public void showADView()
    {
        runOnUiThread(new Runnable()
        {

            @Override
            public void run()
            {
                int width = toPixelUnits(BANNER_WIDTH);
                int height = toPixelUnits(BANNER_HEIGHT);
                Display display = appActivity.getWindowManager().getDefaultDisplay();
                Point pt = getDisplaySize(display);
                float ratio = (float)pt.x/(float)width;
                width = pt.x;
                height = (int)(height*ratio);

               mBannerAd.setVisibility(View.VISIBLE);
                mBannerAd.refreshDrawableState();
                float t = contain.getY();
                contain.setY(display.getHeight() - height);
            }
        });
    }

    @Override
    public void hideADView()
    {
        runOnUiThread(new Runnable()
        {
            @Override
            public void run()
            {
                if(mBannerAd != null)
                {
                    int width = toPixelUnits(BANNER_WIDTH);
                    int height = toPixelUnits(BANNER_HEIGHT);
                    Display display = appActivity.getWindowManager().getDefaultDisplay();
                    Point pt = getDisplaySize(display);
                    float ratio = (float)pt.x/(float)width;
                    width = pt.x;
                    height = (int)(height*ratio);

                    contain.setY(-height);
                    contain.setVisibility(View.INVISIBLE);
                }
            }
        });


    }
    public void delBanner()
    {
        if(mBannerAd != null)
        {
            mBannerAd.setVisibility(View.GONE);
            mBannerAd = null;
        }
        mCurrBannerAd = null;
    }

    public void setupBanner(InMobiBanner b)
    {
        mBannerAd = b;
        mCurrBannerAd = b;

        mBannerAd.setAnimationType(InMobiBanner.AnimationType.ANIMATION_OFF);
        mBannerAd.setRefreshInterval(30);
        mBannerAd.setEnableAutoRefresh(true);

        mBannerAd.setListener(new InMobiBanner.BannerAdListener() {
            @Override
            public void onAdLoadSucceeded(InMobiBanner inMobiBanner) {
                Log.d(TAG_INMOBI_LISTENER, "onAdLoadSucceeded");

                setLoaded(true);
                //if (appActivity.adMgr.getNeedShow())
                if(true)//这里写死，只要有广告来就展示
                {
                    showADView();
                }
                else
                {
                    hideADView();
                }
            }

            @Override
            public void onAdLoadFailed(InMobiBanner inMobiBanner,
                                       InMobiAdRequestStatus inMobiAdRequestStatus) {
                Log.d(TAG_INMOBI_LISTENER, "Banner ad failed to load with error: " +
                        inMobiAdRequestStatus.getMessage());

                requestLoadAd();
            }

            @Override
            public void onAdDisplayed(InMobiBanner inMobiBanner) {
                Log.d(TAG_INMOBI_LISTENER, "onAdDisplayed");
            }

            @Override
            public void onAdDismissed(InMobiBanner inMobiBanner) {
                Log.d(TAG_INMOBI_LISTENER, "onAdDismissed");
            }

            @Override
            public void onAdInteraction(InMobiBanner inMobiBanner, Map<Object, Object> map) {
                Log.d(TAG_INMOBI_LISTENER, "onAdInteraction");
            }

            @Override
            public void onUserLeftApplication(InMobiBanner inMobiBanner) {
                Log.d(TAG_INMOBI_LISTENER, "onUserLeftApplication");
            }

            @Override
            public void onAdRewardActionCompleted(InMobiBanner inMobiBanner, Map<Object, Object> map) {
                Log.d(TAG_INMOBI_LISTENER, "onAdRewardActionCompleted");
            }
        });
        //setBannerLayoutParams();
        int width = toPixelUnits(BANNER_WIDTH);
        int height = toPixelUnits(BANNER_HEIGHT);
        Display display = appActivity.getWindowManager().getDefaultDisplay();
        Point pt = getDisplaySize(display);
        float ratio = (float)pt.x/(float)width;
        width = pt.x;
        height = (int)(height*ratio);
        RelativeLayout.LayoutParams bannerLayoutParams = new RelativeLayout.LayoutParams(width, height);
        bannerLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        bannerLayoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
        mBannerAd.setLayoutParams(bannerLayoutParams);
        mBannerAd.setTranslationY(display.getHeight() - height);

        contain.addView(mBannerAd);

        hideADView();

        mBannerAd.load(appActivity);
    }

    public void newBanner()
    {
        delBanner();

        InMobiBanner.requestAd(appActivity, mInMobiAdRequest, bannerAdRequestListener);
    }

    @Override
    public void requestLoadAd()
    {
        runOnUiThread(new Runnable()
        {
            @Override
            public void run()
            {
                if(mCurrBannerAd == null)
                {
                    newBanner();
                }
            }
        });
    }

    @Override
    public void luaHideAd(final String param,final int luaFunc){
        super.luaHideAd(param, luaFunc);

        runOnUiThread(new Runnable()
        {
            @Override
            public void run()
            {
                delBanner();
                requestLoadAd();
            }
        });
    }
}
