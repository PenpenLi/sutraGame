package org.cocos2dx.lua;

import android.app.Application;

import com.tencent.bugly.crashreport.CrashReport;

/**
 * Created by afwang on 13-9-17.
 */
public class SturaGameApplication extends Application {

  public void onCreate() {
    super.onCreate();

    CrashReport.initCrashReport(getApplicationContext(), "c82863fe21", false);


  }


}
