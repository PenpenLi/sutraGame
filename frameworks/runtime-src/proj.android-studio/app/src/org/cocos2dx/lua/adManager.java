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

        admobAD = new adMobUnit();
        admobAD.initSDK(appActivity);

        inMobiAD = new inMobiUnit();
        inMobiAD.initSDK(appActivity);


        return  true;
    }

    public void luaLoadAd(final String param,final int luaFunc){
        if (!admobAD.isLoaded())
            admobAD.luaLoadAd(param, luaFunc);

        if(!inMobiAD.isLoaded())
            inMobiAD.luaLoadAd(param, luaFunc);
    }
    public void luaShowAd(final String param,final int luaFunc){
        if(admobAD.isLoaded())
            admobAD.luaShowAd(param, luaFunc);

        if(inMobiAD.isLoaded())
            inMobiAD.luaShowAd(param, luaFunc);
    }
    public void luaHideAd(final String param,final int luaFunc){
        admobAD.luaHideAd(param, luaFunc);

        inMobiAD.luaHideAd(param, luaFunc);
    }
    public void luaStateAd(final String param,final int luaFunc){
        admobAD.luaStateAd(param, luaFunc);

        inMobiAD.luaStateAd(param, luaFunc);
    }

    public void onResume() {
        admobAD.onResume();
    }


    public void onPause() {
        admobAD.onPause();
    }


    public void onDestroy() {
        admobAD.onDestroy();
    }
}
