import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdClass {
  late final RewardedAd _rewardedAd;
  final String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  void loadRewardedAd() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print("Ad Loaded successfully.");
            _rewardedAd = ad;

            _setFullScreenContentCallback();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('Error loading RewardedAd: $error');
          },
        ));
  }

  void _setFullScreenContentCallback() {
    if (_rewardedAd == null) return;
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) => print('Ad loaded.'),
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          print('$ad onAdDismissedFullScreenContent');
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          print('Ad loading failed.');

          ad.dispose();
        },
        onAdImpression: (RewardedAd ad) => print('Imapression Added.'));
  }

  void showRewardedAd() {
    _rewardedAd.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        num amount = rewardItem.amount;
        print('User earned reward: $amount.type, amount: ${rewardItem.amount}');
      },
    );
  }
}
