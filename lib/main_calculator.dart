import 'package:electric_cars_calculator/charging_cost_calculator.dart';
import 'package:electric_cars_calculator/charging_time_calculator.dart';
import 'package:electric_cars_calculator/unit/ad_mob_service.dart';
import 'package:flutter/foundation.dart'; // kIsWeb 상수를 위해 필요
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ev_station_outlined, color: Colors.white),
            SizedBox(width: 10),
            Text('EV Cars Calculator',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              icon: Icon(Icons.credit_card_outlined),
              text: 'Charging Cost',
            ),
            Tab(
              icon: Icon(Icons.timer_outlined),
              text: 'Charging Time',
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
              title: const Text('Info'),
              content: const Text(
                  'Use this app to calculate charging cost and time for your EV.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
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
