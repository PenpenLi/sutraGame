package org.cocos2dx.lua;

import android.app.Application;


import com.inmobi.ads.InMobiAdRequest;
import com.inmobi.ads.InMobiAdRequestStatus;
import com.inmobi.ads.InMobiBanner;
import com.inmobi.sdk.InMobiSdk;

import android.support.multidex.MultiDexApplication;
import android.util.Log;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;


/**
 * Created by afwang on 13-9-17.
 */
public class SturaGameApplication extends Application {
  private InMobiAdRequest mInMobiAdRequest;
  private com.inmobi.ads.InMobiBanner.BannerAdRequestListener mListener;

  BlockingQueue<InMobiBanner> mBannerQueue = new LinkedBlockingQueue<>();
  BlockingQueue<BannerFetcher> mBannerFetcherQueue = new LinkedBlockingQueue<>();
  InMobiBanner.BannerAdRequestListener bannerAdRequestListener;

  public void onCreate() {

    mInMobiAdRequest = new InMobiAdRequest.Builder(1511238989700L)
            .setMonetizationContext(InMobiAdRequest.MonetizationContext.MONETIZATION_CONTEXT_ACTIVITY)
            .setSlotSize(320, 50).build();
    bannerAdRequestListener = new InMobiBanner.BannerAdRequestListener() {
      @Override
      public void onAdRequestCompleted(InMobiAdRequestStatus inMobiAdRequestStatus, InMobiBanner inMobiBanner) {
        if (inMobiAdRequestStatus.getStatusCode() == InMobiAdRequestStatus.StatusCode.NO_ERROR &&
                null != inMobiBanner) {
          mBannerQueue.offer(inMobiBanner);
          signalBannerResult(true);
        } else {
          signalBannerResult(false);
        }

      }
    };
    fetchBanner(null);
  }

  public void fetchBanner(BannerFetcher bannerFetcher) {
    if (null != bannerFetcher) {
      mBannerFetcherQueue.offer(bannerFetcher);
    }
    InMobiBanner.requestAd(this, mInMobiAdRequest, bannerAdRequestListener);
  }

  private void signalBannerResult(boolean result) {
    final BannerFetcher bannerFetcher = mBannerFetcherQueue.poll();
    if (null != bannerFetcher) {
      if (result) {
        bannerFetcher.onFetchSuccess();
      } else {
        bannerFetcher.onFetchFailure();
      }
    }
  }

  public InMobiBanner getBanner() {
    return mBannerQueue.poll();
  }
}
