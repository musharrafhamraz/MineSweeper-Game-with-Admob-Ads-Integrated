import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdClass {
  late final BannerAd bannerAd;
  final String adUnitId = "ca-app-pub-4838289781790500/3449261273";

  void loadBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: _bannerAdListener,
      request: const AdRequest(),
    );

    bannerAd.load();
  }

  final BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (Ad ad) => print('Ad Loaded'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print("ad failed to load");
    },
    onAdOpened: (Ad ad) => print('Ad opened'),
    onAdClosed: (Ad ad) => print('Ad closed'),
    onAdImpression: (Ad ad) => print('Ad impression'),
  );
}
