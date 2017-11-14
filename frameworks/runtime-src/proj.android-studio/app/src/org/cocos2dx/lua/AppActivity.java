/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2016 cocos2d-x.org
Copyright (c) 2013-2016 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.Rect;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.leting.sutraGame.R;

import android.app.Activity;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;


public class AppActivity extends Cocos2dxActivity{
    public static String LOGTAG = "struaGameLog";
    public static AppActivity g_AppActivity;
    public static boolean showAdIndex = false;
    public static String bannerAdIds = "ca-app-pub-3455499373106199/5139731645";
    public static String appIds = "ca-app-pub-3455499373106199~3754497781";

    public AdView mAdView;
    public int loadAdLuaCallback = 0;
    public int showAdLuaCallback = 0;
    public int hideAdLuaCallback = 0;
    public int stateAdLuaCallback = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        g_AppActivity = this;

        onInitAdmob();

    }
    // Helper get display screen to avoid deprecated function use
    private Point getDisplaySize(Display d)
    {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB)
        {
            return getDisplaySizeGE11(d);
        }
        return getDisplaySizeLT11(d);
    }

    //@TargetApi(Build.VERSION_CODES.HONEYCOMB_MR2)
    private Point getDisplaySizeGE11(Display d)
    {
        Point p = new Point(0, 0);
        d.getSize(p);
        return p;
    }
    private Point getDisplaySizeLT11(Display d)
    {
        try
        {
            Method getWidth = Display.class.getMethod("getWidth", new Class[] {});
            Method getHeight = Display.class.getMethod("getHeight", new Class[] {});
            return new Point((Integer) getWidth.invoke(d, (Object[]) null), ((Integer) getHeight.invoke(d, (Object[]) null)).intValue());
        }
        catch (NoSuchMethodException e2) // None of these exceptions should ever occur.
        {
            return new Point(-1, -1);
        }
        catch (IllegalArgumentException e2)
        {
            return new Point(-2, -2);
        }
        catch (IllegalAccessException e2)
        {
            return new Point(-3, -3);
        }
        catch (InvocationTargetException e2)
        {
            return new Point(-4, -4);
        }
    }
    public void onInitAdmob() {
        MobileAds.initialize(this, appIds);
        //mAdView = (AdView) findViewById(R.id.adView);
        mAdView = new AdView(this);
        mAdView.setAdSize(AdSize.LARGE_BANNER);
        mAdView.setAdUnitId(bannerAdIds);
        mAdView.setBackgroundColor(Color.BLACK);


        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        Display display = getWindowManager().getDefaultDisplay();
        Point pt = getDisplaySize(display);
        LinearLayout.LayoutParams adParams = new LinearLayout.LayoutParams(
                pt.x,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        addContentView(mAdView,adParams);
        mAdView.setVisibility(View.INVISIBLE);



        mAdView.setAdListener(new AdListener() {
            @Override
            public void onAdLoaded() {
                // Code to be executed when an ad finishes loading.
                super.onAdOpened();
                Log.d(LOGTAG, "onAdLoaded");
                luaLoadAdCallback("success");

                if (showAdIndex) showAd();
            }

            @Override
            public void onAdFailedToLoad(int errorCode) {
                // Code to be executed when an ad request fails.
                super.onAdFailedToLoad(errorCode);
                Log.d(LOGTAG, "onAdFailedToLoad, errorCode=" + errorCode);
                luaLoadAdCallback("failed");
                //loadAd();
            }

            @Override
            public void onAdOpened() {

                // Code to be executed when an ad opens an overlay that
                // covers the screen.
                super.onAdOpened();
                luaStateAdCallback("opened");
                Log.d(LOGTAG, "onAdOpened");
            }

            @Override
            public void onAdLeftApplication() {
                // Code to be executed when the user has left the app.
                super.onAdLeftApplication();
                luaStateAdCallback("LeftApplication");
                Log.d(LOGTAG, "onAdLeftApplication");
            }

            @Override
            public void onAdClosed() {
                // Code to be executed when when the user is about to return
                // to the app after tapping on an ad.
                luaStateAdCallback("closed");
                super.onAdClosed();
            }

            @Override
            public  void onAdClicked(){
                luaStateAdCallback("clicked");
                super.onAdClicked();
            }
        });
        if (!mAdView.isEnabled()) mAdView.setEnabled(true);
        mAdView.setVisibility(View.INVISIBLE);

        loadAd();
    }

    public void loadAd()
    {
        //AdRequest request = new AdRequest.Builder().build();
        AdRequest request = new AdRequest.Builder()
                .addTestDevice("7A04A9E4CE4F262D8C76B0E8772A1C82")
                .build();
        mAdView.loadAd(request);
    }

    public void showAd()
    {
        runOnUiThread(new Runnable()
        {

            @Override
            public void run()
            {
                mAdView.setVisibility(View.VISIBLE);
                Display display = getWindowManager().getDefaultDisplay();
                Log.d(LOGTAG, String.format("setTranslationY.%d, %d",display.getHeight() , mAdView.getHeight()));
                mAdView.setTranslationY(display.getHeight() - mAdView.getHeight());
            }
        });
    }

    public void hideAd()
    {
        runOnUiThread(new Runnable()
        {
            @Override
            public void run()
            {
               // mAdView.setVisibility(View.INVISIBLE);
                Display display = getWindowManager().getDefaultDisplay();
                Log.d(LOGTAG, String.format("setTranslationY.%d, %d",display.getHeight() , mAdView.getHeight()));
                mAdView.setTranslationY(display.getHeight() - 1);
            }
        });
    }

    public Cocos2dxGLSurfaceView onCreateView() {
        Cocos2dxGLSurfaceView glSurfaceView = new Cocos2dxGLSurfaceView(this);
        // Tests should create stencil buffer
        glSurfaceView.setEGLConfigChooser(5, 6, 5, 0, 16, 8);

        return glSurfaceView;
    }

    public void luaLoadAdCallback(final String res)
    {
        if(loadAdLuaCallback != 0)
        {
            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(loadAdLuaCallback, res);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(loadAdLuaCallback);

            loadAdLuaCallback = 0;
        }
    }
    public void luaShowAdCallback(final String res)
    {
        if(showAdLuaCallback != 0)
        {
            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(showAdLuaCallback, res);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(showAdLuaCallback);

            showAdLuaCallback = 0;
        }
    }
    public void luaHideAdCallback(final String res)
    {
        if(hideAdLuaCallback != 0)
        {
            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(hideAdLuaCallback, res);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(hideAdLuaCallback);

            hideAdLuaCallback = 0;
        }
    }
    public void luaStateAdCallback(final String res)
    {
        if(stateAdLuaCallback != 0)
        {
            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(stateAdLuaCallback, res);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(stateAdLuaCallback);

            stateAdLuaCallback = 0;
        }
    }

    public static void luaLoadAd(final String param,final int luaFunc){
        g_AppActivity.loadAdLuaCallback = luaFunc;

        g_AppActivity.runOnUiThread(new Runnable()
        {
            @Override
            public void run()
            {
                g_AppActivity.loadAd();
            }
        });
    }
    public static void luaShowAd(final String param,final int luaFunc){
        g_AppActivity.showAdLuaCallback = luaFunc;
        showAdIndex = true;
        g_AppActivity.showAd();
    }
    public static void luaHideAd(final String param,final int luaFunc){
        g_AppActivity.hideAdLuaCallback = luaFunc;
        showAdIndex = false;
        g_AppActivity.hideAd();
    }
    public static void luaStateAd(final String param,final int luaFunc){
        g_AppActivity.stateAdLuaCallback = luaFunc;
    }


    @Override
    public void onResume() {
        super.onResume();

        // Resume the AdView.
        mAdView.resume();
    }

    @Override
    public void onPause() {
        // Pause the AdView.
        mAdView.pause();

        super.onPause();
    }

    @Override
    public void onDestroy() {
        // Destroy the AdView.
        mAdView.destroy();

        super.onDestroy();
    }


}
