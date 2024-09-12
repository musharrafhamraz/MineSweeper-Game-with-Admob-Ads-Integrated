import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdClass {
  RewardedAd? _rewardedAd;
  bool isRewardedAdReady = false; // Track if ad is loaded

  final String rewardedAdUnitId = 'ca-app-pub-4838289781790500/8613263515';

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          isRewardedAdReady = true;
          _setFullScreenContentCallBack(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load rewarded ad: $error');
          isRewardedAdReady = false; // Mark the ad as not ready
        },
      ),
    );
  }

  void _setFullScreenContentCallBack(RewardedAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('Rewarded Ad shown.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('Rewarded Ad dismissed.');
        ad.dispose();
        isRewardedAdReady = false; // Mark ad as no longer available
        loadRewardedAd(); // Reload ad after it's dismissed
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('Error showing rewarded ad: $error');
        ad.dispose();
        isRewardedAdReady = false; // Reload after failure
        loadRewardedAd(); // Reload ad
      },
    );
  }

  void showRewardedAd(VoidCallback onAdWatched) {
    if (_rewardedAd != null && isRewardedAdReady) {
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        print('User earned reward: ${rewardItem.amount}');
        onAdWatched(); // Trigger the callback after watching the ad
      });
    } else {
      print("Rewarded ad not ready");
    }
  }
}
