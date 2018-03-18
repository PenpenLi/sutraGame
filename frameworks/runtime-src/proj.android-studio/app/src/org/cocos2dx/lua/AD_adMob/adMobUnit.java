package org.cocos2dx.lua.AD_adMob;

import android.graphics.Color;
import android.graphics.Point;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.cocos2dx.lua.adBaseUnit;

import static com.google.android.gms.internal.zzahg.runOnUiThread;

/**
 * Created by Administrator on 2017/11/26.
 */

public class adMobUnit extends adBaseUnit {
    static final String TAG_ADMOB_LISTENER = "TAG_ADMOB_LISTENER";



    public static String bannerAdIds = "ca-app-pub-3455499373106199/5139731645";//正式ID
    //public static String bannerAdIds = "ca-app-pub-3940256099942544/6300978111";//测试ID

    public static String appIds = "ca-app-pub-3455499373106199~3754497781";//正式
    //public static String appIds = "ca-app-pub-3940256099942544~3347511713";//测试


    public AdView mAdView;


    public boolean initSDK(AppActivity instance) {
        appActivity = instance;

        MobileAds.initialize(appActivity, appIds);
        //mAdView = (AdView) findViewById(R.id.adView);
        mAdView = new AdView(appActivity);
        mAdView.setAdSize(AdSize.LARGE_BANNER);
        mAdView.setAdUnitId(bannerAdIds);
        mAdView.setBackgroundColor(Color.WHITE);


        appActivity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        Display display = appActivity.getWindowManager().getDefaultDisplay();
        Point pt = getDisplaySize(display);
        LinearLayout.LayoutParams adParams = new LinearLayout.LayoutParams(
                pt.x,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        appActivity.addContentView(mAdView,adParams);




        mAdView.setAdListener(new AdListener() {
            @Override
            public void onAdLoaded() {
                // Code to be executed when an ad finishes loading.
                super.onAdOpened();
                Log.d(TAG_ADMOB_LISTENER, "onAdLoaded");
                setLoaded(true);

                if (appActivity.adMgr.getNeedShow())
                {
                    showADView();
                    appActivity.adMgr.setNeedShow(false);
                }
                else
                {
                    hideADView();
                }
            }

            @Override
            public void onAdFailedToLoad(int errorCode) {
                super.onAdFailedToLoad(errorCode);
                Log.d(TAG_ADMOB_LISTENER, "onAdFailedToLoad, errorCode=" + errorCode);

                requestLoadAd();
            }

            @Override
            public void onAdOpened() {
                super.onAdOpened();
                Log.d(TAG_ADMOB_LISTENER, "onAdOpened");
            }

            @Override
            public void onAdLeftApplication() {
                // Code to be executed when the user has left the app.
                super.onAdLeftApplication();
                Log.d(TAG_ADMOB_LISTENER, "onAdLeftApplication");
            }

            @Override
            public void onAdClosed() {
                // Code to be executed when when the user is about to return
                // to the app after tapping on an ad.
                super.onAdClosed();

                setLoaded(false);
            }

            @Override
            public  void onAdClicked(){
                super.onAdClicked();
            }
        });
        if (!mAdView.isEnabled()) mAdView.setEnabled(true);

        hideADView();

        requestLoadAd();

        return true;
    }



    @Override
    public void showADView()
    {
        runOnUiThread(new Runnable()
        {

            @Override
            public void run()
            {
                mAdView.setVisibility(View.VISIBLE);
                Display display = appActivity.getWindowManager().getDefaultDisplay();
                Log.d(TAG_ADMOB_LISTENER, String.format("setTranslationY.%d, %d",display.getHeight() , mAdView.getHeight()));
                mAdView.setTranslationY(display.getHeight() - mAdView.getHeight());
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
                 mAdView.setVisibility(View.INVISIBLE);
                //Display display = appActivity.getWindowManager().getDefaultDisplay();
                //Log.d(TAG_ADMOB_LISTENER, String.format("setTranslationY.%d, %d",display.getHeight() , mAdView.getHeight()));
                //mAdView.setTranslationY(display.getHeight() - 1);
            }
        });
    }

    @Override
    public void requestLoadAd()
    {
        runOnUiThread(new Runnable()
        {
            @Override
            public void run()
            {
                //AdRequest request = new AdRequest.Builder().build();
                AdRequest request = new AdRequest.Builder()
                        //.addTestDevice("A5F9E6335552952334CBB97A10D1F4CB")
                        .build();
                mAdView.loadAd(request);
            }
        });

    }

    @Override
    public void luaHideAd(final String param,final int luaFunc){
        super.luaHideAd(param, luaFunc);
    }

    public void onResume() {
        mAdView.resume();
    }

    public void onPause() {
        mAdView.pause();
    }

    public void onDestroy() {
        mAdView.destroy();
    }
}
