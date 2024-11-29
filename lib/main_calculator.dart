import 'package:electric_cars_calculator/charging_cost_calculator.dart';
import 'package:electric_cars_calculator/charging_time_calculator.dart';
import 'package:electric_cars_calculator/unit/ad_mob_service.dart';
import 'package:flutter/foundation.dart'; // kIsWeb 상수를 위해 필요
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EVCalculatorHome extends StatefulWidget {
  const EVCalculatorHome({super.key});

  @override
  _EVCalculatorHomeState createState() => _EVCalculatorHomeState();
}

class _EVCalculatorHomeState extends State<EVCalculatorHome>
    with SingleTickerProviderStateMixin {
  BannerAd? _bannerAd;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _createBannerAd();
    }
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon(Icons.ev_station_outlined, color: Colors.white),
            const SizedBox(width: 10),
            Text(localizations.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: const Icon(Icons.credit_card_outlined),
              text: localizations.tab_1_title,
            ),
            Tab(
              icon: const Icon(Icons.timer_outlined),
              text: localizations.tab_2_title,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ChargingCostCalculator(),
          ChargingTimeCalculator(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 예: 도움말 다이얼로그 추가 가능
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(localizations.info_title),
              content: Text(
                localizations.info_msg,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    localizations.close,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.help_outline),
      ),
      //화면의 하단에 배너 노출
      bottomNavigationBar: _bannerAd == null
          ? Container(
              child: const SizedBox(
                height: 75,
              ),
            )
          : Container(
              margin: const EdgeInsets.only(bottom: 0),
              height: 75,
              child: AdWidget(
                ad: _bannerAd!,
              ),
            ),
    );
  }
}
