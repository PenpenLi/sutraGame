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

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.graphics.Point;
import android.os.Bundle;
import android.util.Log;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;

import android.app.Activity;
import android.view.Display;
import android.view.View;


import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import java.io.InputStream;

import static com.google.android.gms.internal.zzahg.runOnUiThread;


public class AppActivity extends Cocos2dxActivity{
    public static String LOGTAG = "struaGameLog";
    public static AppActivity g_AppActivity;

    public adManager adMgr;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        g_AppActivity = this;

        adMgr = new adManager();
        adMgr.initSDK(g_AppActivity);

        AppUtils.init(this);

    }



    public Cocos2dxGLSurfaceView onCreateView() {
        Cocos2dxGLSurfaceView glSurfaceView = new Cocos2dxGLSurfaceView(this);
        // Tests should create stencil buffer
        glSurfaceView.setEGLConfigChooser(5, 6, 5, 0, 16, 8);

        return glSurfaceView;
    }


    public static void luaLoadAd(final String param,final int luaFunc){
        g_AppActivity.adMgr.luaLoadAd(param, luaFunc);
    }
    public static void luaShowAd(final String param,final int luaFunc){
        g_AppActivity.adMgr.luaShowAd(param, luaFunc);
    }
    public static void luaHideAd(final String param,final int luaFunc){
        g_AppActivity.adMgr.luaHideAd(param, luaFunc);
    }
    public static void luaStateAd(final String param,final int luaFunc){
        g_AppActivity.adMgr.luaStateAd(param, luaFunc);
    }
    public static void setSysClipboardText(final String writeMe) {
        g_AppActivity.runOnUiThread(new Runnable()
        {

            @Override
            public void run()
            {
                ClipboardManager cm = (ClipboardManager) g_AppActivity.getSystemService(Context.CLIPBOARD_SERVICE);

                ClipData clipData = ClipData.newPlainText(null, writeMe);

                cm.setPrimaryClip(clipData);
            }
        });

    }

    @Override
    public void onResume() {
        super.onResume();
        adMgr.onResume();

    }

    @Override
    public void onPause() {
        super.onPause();
        adMgr.onPause();

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        adMgr.onDestroy();
    }
}
