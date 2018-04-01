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
    protected boolean needShow = false;

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
        if (admobAD != null)  admobAD.luaLoadAd(param, luaFunc);

        if(inMobiAD != null)inMobiAD.luaLoadAd(param, luaFunc);
    }
    public void luaShowAd(final String param,final int luaFunc){
        if(admobAD != null && admobAD.getLoaded())
            admobAD.luaShowAd(param, luaFunc);
        else if(inMobiAD != null && inMobiAD.getLoaded())
            inMobiAD.luaShowAd(param, luaFunc);

        setNeedShow(true);
    }
    public void luaHideAd(final String param,final int luaFunc){
        if (admobAD != null) admobAD.luaHideAd(param, luaFunc);

        if(inMobiAD != null)inMobiAD.luaHideAd(param, luaFunc);

        setNeedShow(false);
    }
    public void luaStateAd(final String param,final int luaFunc){
        if (admobAD != null)admobAD.luaStateAd(param, luaFunc);

        if(inMobiAD != null)inMobiAD.luaStateAd(param, luaFunc);
    }

    public boolean getNeedShow() {
        return needShow;
    }
    public void setNeedShow(boolean b) {
        needShow = b;
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
