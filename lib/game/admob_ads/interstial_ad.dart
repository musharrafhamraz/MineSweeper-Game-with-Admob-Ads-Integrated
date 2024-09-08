import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstialAd {
  late final InterstitialAd _interstitialAd;
  final String interstialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;

          _setFullScreenContentCallBack(ad);
        },
        onAdFailedToLoad: (LoadAdError loadAdError) {
          print('Interstitial Ad failed to load $loadAdError');
        },
      ),
    );
  }

  void _setFullScreenContentCallBack(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('Ad loaded.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('Ad dismissed.');

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Error Loading Ad');
      },
      onAdImpression: (InterstitialAd ad) => print('Impression detected.'),
    );
  }

  void showInterstitial() {
    _interstitialAd.show();
  }
}
