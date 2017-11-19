package org.cocos2dx.lua;

/**
 * Created by Administrator on 2017/11/19.
 */
import org.cocos2dx.lua.AppActivity;
import android.graphics.Point;
import android.os.Handler;
import android.util.Log;
import android.view.Display;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.inmobi.ads.InMobiAdRequestStatus;
import com.inmobi.ads.InMobiBanner;
import com.inmobi.sdk.InMobiSdk;
import com.leting.sutraGame.R;

import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import org.cocos2dx.lua.BannerFetcher;
import static com.google.android.gms.internal.zzahg.runOnUiThread;



public class AD_inMobi {
    static final String TAG = "AD_inMobi";
    static AppActivity appActivity;
    private final Handler mHandler = new Handler();
    private SturaGameApplication bannerApplication;
    private BannerFetcher bannerFetcher;
    private AtomicInteger forcedRetry = new AtomicInteger(0);
    private InMobiBanner mBannerAd;


    boolean initSDK(AppActivity instance)
    {
        appActivity = instance;

        runOnUiThread(new Runnable()
        {

            @Override
            public void run()
            {
                InMobiSdk.init(appActivity, "d6033153bb3d4982a35b8c349c354f68");
                //Fresco.initialize(this);
                bannerApplication = ((SturaGameApplication) appActivity.getApplication());

                bannerFetcher = new BannerFetcher() {
                    @Override
                    public void onFetchSuccess() {
                        setupBannerAd();
                    }

                    @Override
                    public void onFetchFailure() {
                        if (forcedRetry.getAndIncrement() < 2) {
                            mHandler.postDelayed(new Runnable() {
                                @Override
                                public void run() {
                                    bannerApplication.fetchBanner(bannerFetcher);
                                }
                            }, 2000);
                        }
                    }
                };


/*
                Display display = getWindowManager().getDefaultDisplay();
                Point pt = getDisplaySize(display);
                RelativeLayout.LayoutParams bannerParams = new RelativeLayout.LayoutParams(
                        pt.x,
                        LinearLayout.LayoutParams.WRAP_CONTENT);
                bannerParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
                bannerParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
                mInMobiBanner.setLayoutParams(bannerParams);

                LinearLayout.LayoutParams adParams = new LinearLayout.LayoutParams(
                        pt.x,
                        LinearLayout.LayoutParams.WRAP_CONTENT);
                addContentView(mInMobiBanner, adParams);

                mInMobiBanner.load();
                */
            }
        });
        return true;
    }

    private void setupBannerAd() {
        mBannerAd = bannerApplication.getBanner();
        if (null == mBannerAd) {
            Log.d("SOS", "mBannerAd is null.. Fetching again..");
            bannerApplication.fetchBanner(bannerFetcher);
            return;
        }
        RelativeLayout adContainer = (RelativeLayout) findViewById(R.id.ad_container);
        mBannerAd.setAnimationType(InMobiBanner.AnimationType.ROTATE_HORIZONTAL_AXIS);
        mBannerAd.setRefreshInterval(60);
        mBannerAd.setListener(new InMobiBanner.BannerAdListener() {
            @Override
            public void onAdLoadSucceeded(InMobiBanner inMobiBanner) {
                Log.d(TAG, "onAdLoadSucceeded");
            }

            @Override
            public void onAdLoadFailed(InMobiBanner inMobiBanner,
                                       InMobiAdRequestStatus inMobiAdRequestStatus) {
                Log.d(TAG, "Banner ad failed to load with error: " +
                        inMobiAdRequestStatus.getMessage());
            }

            @Override
            public void onAdDisplayed(InMobiBanner inMobiBanner) {
                Log.d(TAG, "onAdDisplayed");
            }

            @Override
            public void onAdDismissed(InMobiBanner inMobiBanner) {
                Log.d(TAG, "onAdDismissed");
            }

            @Override
            public void onAdInteraction(InMobiBanner inMobiBanner, Map<Object, Object> map) {
                Log.d(TAG, "onAdInteraction");
            }

            @Override
            public void onUserLeftApplication(InMobiBanner inMobiBanner) {
                Log.d(TAG, "onUserLeftApplication");
            }

            @Override
            public void onAdRewardActionCompleted(InMobiBanner inMobiBanner, Map<Object, Object> map) {
                Log.d(TAG, "onAdRewardActionCompleted");
            }
        });
        setBannerLayoutParams();
        adContainer.addView(mBannerAd);
        //Providing activity context to show ad
        mBannerAd.load(appActivity);
    }


    private void setBannerLayoutParams() {
        int width = toPixelUnits(BANNER_WIDTH);
        int height = toPixelUnits(BANNER_HEIGHT);
        RelativeLayout.LayoutParams bannerLayoutParams = new RelativeLayout.LayoutParams(width, height);
        bannerLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        bannerLayoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
        mBannerAd.setLayoutParams(bannerLayoutParams);
    }

    private int toPixelUnits(int dipUnit) {
        float density = appActivity.getResources().getDisplayMetrics().density;
        return Math.round(dipUnit * density);
    }
}
