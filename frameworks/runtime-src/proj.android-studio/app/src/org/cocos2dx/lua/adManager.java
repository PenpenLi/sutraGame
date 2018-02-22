package org.cocos2dx.lua;

/**
 * Created by Administrator on 2017/11/26.
 */
import org.cocos2dx.lua.AD_adMob.adMobUnit;
import org.cocos2dx.lua.AD_inMobi.inMobiUnit;

public class adManager {
    protected static AppActivity appActivity;

    public adMobUnit admobAD;
    public inMobiUnit inMobiAD;


    public boolean initSDK(AppActivity instance)
    {
        appActivity = instance;

        //admobAD = new adMobUnit();
        //admobAD.initSDK(appActivity);

        inMobiAD = new inMobiUnit();
        inMobiAD.initSDK(appActivity);


        return  true;
    }

    public void luaLoadAd(final String param,final int luaFunc){
        if (admobAD != null && !admobAD.isLoaded())  admobAD.luaLoadAd(param, luaFunc);

        if(inMobiAD != null && !inMobiAD.isLoaded())inMobiAD.luaLoadAd(param, luaFunc);
    }
    public void luaShowAd(final String param,final int luaFunc){
        if(admobAD != null && admobAD.isLoaded()) admobAD.luaShowAd(param, luaFunc);

        if(inMobiAD != null && inMobiAD.isLoaded())inMobiAD.luaShowAd(param, luaFunc);
    }
    public void luaHideAd(final String param,final int luaFunc){
        if (admobAD != null && admobAD != null) admobAD.luaHideAd(param, luaFunc);

        if(inMobiAD != null && inMobiAD.isLoaded())inMobiAD.luaHideAd(param, luaFunc);
    }
    public void luaStateAd(final String param,final int luaFunc){
        if (admobAD != null)admobAD.luaStateAd(param, luaFunc);

        if(inMobiAD != null && inMobiAD.isLoaded())inMobiAD.luaStateAd(param, luaFunc);
    }

    public void onResume() {
        if (admobAD != null)admobAD.onResume();

    }


    public void onPause() {
        if (admobAD != null)admobAD.onPause();
    }


    public void onDestroy() {
        if (admobAD != null)admobAD.onDestroy();
    }
}
