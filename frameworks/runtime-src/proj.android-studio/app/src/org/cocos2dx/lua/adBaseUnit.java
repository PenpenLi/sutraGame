package org.cocos2dx.lua;

import android.graphics.Point;
import android.os.Build;
import android.view.Display;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import static com.google.android.gms.internal.zzahg.runOnUiThread;

/**
 * Created by Administrator on 2017/11/26.
 */

public abstract  class adBaseUnit {
    protected static AppActivity appActivity;

    protected int loadAdLuaCallback = 0;
    protected int showAdLuaCallback = 0;
    protected int hideAdLuaCallback = 0;
    protected int stateAdLuaCallback = 0;
    protected boolean showing = false;
    protected boolean loaded = false;
    protected boolean requireShowIndex = false;

    public boolean isShowing(){return showing;}

    public boolean isRequireShow(){return requireShowIndex;}

    public boolean isLoaded(){return loaded;}

    public void requireShow(boolean b){requireShowIndex = b;}

    public void luaLoadAd(final String param,final int luaFunc){
        loadAdLuaCallback = luaFunc;

        runOnUiThread(new Runnable()
        {

            @Override
            public void run()
            {
                if(!isLoaded())
                {
                    requestLoadAd();
                }
                else
                {
                    callbackLuaLoadedAd("success", true);
                }
            }
        });
    }

    public void luaShowAd(final String param,final int luaFunc){
        showAdLuaCallback = luaFunc;
        requireShowIndex = true;
        runOnUiThread(new Runnable()
        {
            @Override
            public void run()
            {
                if (isLoaded())
                {
                    showADView();
                    callbackLuaShowedAd("");
                }
                else
                {
                    requestLoadAd();
                }
            }
        });
    }

    public void luaHideAd(final String param,final int luaFunc){
        hideAdLuaCallback = luaFunc;
        requireShowIndex = false;

        hideADView();
        callbackLuaHidedAd("");
    }

    public void luaStateAd(final String param,final int luaFunc){
        stateAdLuaCallback = luaFunc;
    }

    public void callbackLuaLoadedAd(final String res, boolean succ)
    {
        loaded = succ;

        if(loadAdLuaCallback != 0)
        {
            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(loadAdLuaCallback, res);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(loadAdLuaCallback);

            loadAdLuaCallback = 0;
        }
    }
    public void callbackLuaShowedAd(final String res)
    {
        showing = true;

        if(showAdLuaCallback != 0)
        {
            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(showAdLuaCallback, res);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(showAdLuaCallback);

            showAdLuaCallback = 0;
        }
    }
    public void callbackLuaHidedAd(final String res)
    {
        showing = false;
        loaded = false;

        if(hideAdLuaCallback != 0)
        {
            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(hideAdLuaCallback, res);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(hideAdLuaCallback);

            hideAdLuaCallback = 0;
        }
    }
    public void callbackLuaStateAd(final String res)
    {
        if(stateAdLuaCallback != 0)
        {
            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(stateAdLuaCallback, res);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(stateAdLuaCallback);

            stateAdLuaCallback = 0;
        }
    }

    public abstract void showADView();
    public abstract void hideADView();
    public abstract void requestLoadAd();






    // Helper get display screen to avoid deprecated function use
    public Point getDisplaySize(Display d)
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

    protected int toPixelUnits(int dipUnit) {
        float density = appActivity.getResources().getDisplayMetrics().density;
        return Math.round(dipUnit * density);
    }
}
