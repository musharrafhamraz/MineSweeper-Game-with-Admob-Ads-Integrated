// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class InterstialAd {
//   late final InterstitialAd _interstitialAd;
//   final String interstialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

//   void loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: interstialAdUnitId,
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           _interstitialAd = ad;

//           _setFullScreenContentCallBack(ad);
//         },
//         onAdFailedToLoad: (LoadAdError loadAdError) {
//           print('Interstitial Ad failed to load $loadAdError');
//         },
//       ),
//     );
//   }

//   void _setFullScreenContentCallBack(InterstitialAd ad) {
//     ad.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) => print('Ad loaded.'),
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         print('Ad dismissed.');
//         ad.dispose();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         print('Error Loading Ad');
//       },
//       onAdImpression: (InterstitialAd ad) => print('Impression detected.'),
//     );
//   }

//   void showInterstitial() {
//     _interstitialAd.show();
//   }
// }

import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstialAd {
  InterstitialAd? _interstitialAd;
  final String interstialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  bool isAdLoaded = false; // Track if ad is loaded

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          isAdLoaded = true; // Set ad as loaded
          _setFullScreenContentCallBack(ad);
        },
        onAdFailedToLoad: (LoadAdError loadAdError) {
          print('Interstitial Ad failed to load: $loadAdError');
          isAdLoaded = false; // Ensure isAdLoaded is false if failed
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
        isAdLoaded = false; // Mark ad as no longer available
        loadInterstitialAd(); // Reload ad after it is dismissed
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Error showing ad: $error');
        ad.dispose();
        isAdLoaded = false;
        loadInterstitialAd(); // Reload ad if failed to show
      },
    );
  }

  void showInterstitial() {
    if (_interstitialAd != null && isAdLoaded) {
      _interstitialAd!.show();
    } else {
      print("Ad not ready");
    }
  }
}
