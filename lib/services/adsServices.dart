import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  RewardedAd? rewardedAd;
  BannerAd? bannerAd;
  bool isbannerAdLoaded = false;

  void loadRewardAds(BuildContext context) {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test ad unit ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          print("Ad Loaded");
        },
        onAdFailedToLoad: (LoadAdError error) {
          rewardedAd = null;
          print("ad failed to load $error");
        },
      ),
    );
  }

  void showAds(BuildContext context, Function onAdDismissed) {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          rewardedAd!.dispose();
          loadRewardAds(context);
          onAdDismissed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          rewardedAd!.dispose();
          loadRewardAds(context);
          print("ad failed to load $error");
        },
      );

      rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        // User earned reward
        print("User earned reward");
      });
    } else {
      onAdDismissed();
    }
  }

   void loadBannerAd(BuildContext context) {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          isbannerAdLoaded = true;
          // Using setState to update the UI when the banner ad is loaded
          (context as Element).markNeedsBuild();
          print("Banner Ad Loaded");
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print("Failed to load banner ad $error");
        },
      ),
      request: AdRequest(),
    );

    bannerAd!.load();
  }
}