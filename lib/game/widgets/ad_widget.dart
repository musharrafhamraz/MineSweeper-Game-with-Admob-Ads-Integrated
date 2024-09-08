import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:survivegame/game/admob_ads/banner_ad.dart';

class WidgetAd extends StatefulWidget {
  const WidgetAd({super.key});

  @override
  State<WidgetAd> createState() => _WidgetAdState();
}

class _WidgetAdState extends State<WidgetAd> {
  final bannerAd1 = BannerAdClass();

  @override
  void initState() {
    super.initState();
    bannerAd1.loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: bannerAd1.bannerAd.size.width.toDouble(),
      height: bannerAd1.bannerAd.size.height.toDouble(),
      child: AdWidget(ad: bannerAd1.bannerAd),
    );
  }
}
