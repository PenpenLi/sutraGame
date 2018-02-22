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

    public static String bannerAdIds = "ca-app-pub-3455499373106199/5139731645";
    public static String appIds = "ca-app-pub-3455499373106199~3754497781";

    public AdView mAdView;


    public boolean initSDK(AppActivity instance) {
        appActivity = instance;

        MobileAds.initialize(appActivity, appIds);
        //mAdView = (AdView) findViewById(R.id.adView);
        mAdView = new AdView(appActivity);
        mAdView.setAdSize(AdSize.LARGE_BANNER);
        mAdView.setAdUnitId(bannerAdIds);
        mAdView.setBackgroundColor(Color.BLACK);


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
                callbackLuaLoadedAd("success", true);

                //if (isRequireShow())
                if (true)//这里写死只要有广告回馈过来就显示
                {
                    showADView();
                    requireShow(false);
                    callbackLuaShowedAd("");
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
                callbackLuaLoadedAd("failed", false);

                requestLoadAd();
            }

            @Override
            public void onAdOpened() {
                super.onAdOpened();
                callbackLuaStateAd("opened");
                Log.d(TAG_ADMOB_LISTENER, "onAdOpened");
            }

            @Override
            public void onAdLeftApplication() {
                // Code to be executed when the user has left the app.
                super.onAdLeftApplication();
                callbackLuaStateAd("LeftApplication");
                Log.d(TAG_ADMOB_LISTENER, "onAdLeftApplication");
            }

            @Override
            public void onAdClosed() {
                // Code to be executed when when the user is about to return
                // to the app after tapping on an ad.
                callbackLuaStateAd("closed");
                super.onAdClosed();
            }

            @Override
            public  void onAdClicked(){
                callbackLuaStateAd("clicked");
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
                Display display = appActivity.getWindowManager().getDefaultDisplay();
                Log.d(TAG_ADMOB_LISTENER, String.format("setTranslationY. %d",display.getHeight()));
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
                // mAdView.setVisibility(View.INVISIBLE);
                Display display = appActivity.getWindowManager().getDefaultDisplay();
                Log.d(TAG_ADMOB_LISTENER, String.format("setTranslationY.%d, %d",display.getHeight() , mAdView.getHeight()));
                mAdView.setTranslationY(display.getHeight() - 1);
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
                        //.addTestDevice("7A04A9E4CE4F262D8C76B0E8772A1C82")
                        .build();
                mAdView.loadAd(request);
            }
        });

    }

    @Override
    public void luaHideAd(final String param,final int luaFunc){
        super.luaHideAd(param, luaFunc);

        requestLoadAd();
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
