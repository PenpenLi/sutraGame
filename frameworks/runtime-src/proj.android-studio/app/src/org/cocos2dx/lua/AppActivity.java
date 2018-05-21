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

import android.Manifest;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.graphics.Point;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;


import android.app.Activity;
import android.view.Display;
import android.view.View;


import com.umeng.analytics.UMGameAnalytics;
import com.umeng.analytics.game.UMGameAgent;
import com.umeng.common.UMCocosConfigure;
import com.umeng.commonsdk.UMConfigure;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import java.io.InputStream;


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

        UMGameAnalytics.init(this);
        UMCocosConfigure.init(this, "5ac8dc14a40fa365260003d1", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, "669c30a9584623e70e8cd01b0381dcb4");
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

    static final String TAG_PERMISSION = "TAG_PERMISSION";
    static int permissionLuaCallback = 0;
    public static void requestPermission(final String param,final int luaFunc) {
        permissionLuaCallback = luaFunc;
        Log.d(TAG_PERMISSION, "0");
        if (ContextCompat.checkSelfPermission(g_AppActivity,
                Manifest.permission.READ_PHONE_STATE)
                != PackageManager.PERMISSION_GRANTED) {
            Log.d(TAG_PERMISSION, "A");
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(g_AppActivity,
                    Manifest.permission.READ_PHONE_STATE)) {
                Log.d(TAG_PERMISSION, "B");
                // Show an expanation to the user *asynchronously* -- don't block
                // this thread waiting for the user's response! After the user
                // sees the explanation, try again to request the permission.

            } else {
                Log.d(TAG_PERMISSION, "C");
                // No explanation needed, we can request the permission.

                ActivityCompat.requestPermissions(g_AppActivity,
                        new String[]{Manifest.permission.READ_PHONE_STATE},
                        333);

                // MY_PERMISSIONS_REQUEST_READ_CONTACTS is an
                // app-defined int constant. The callback method gets the
                // result of the request.
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        Log.d(TAG_PERMISSION, "D");
        switch (requestCode) {
            case 333: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Log.d(TAG_PERMISSION, "E");
                    // permission was granted, yay! Do the
                    // contacts-related task you need to do.

                } else {

                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                }
                return;
            }

            // other 'case' lines to check for other
            // permissions this app might request
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        adMgr.onResume();

        UMGameAgent.onResume(this);
    }

    @Override
    public void onPause() {
        super.onPause();
        adMgr.onPause();

        UMGameAgent.onPause(this);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        adMgr.onDestroy();
    }
}
