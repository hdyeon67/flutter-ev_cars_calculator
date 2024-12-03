import 'package:electric_cars_calculator/intro_screen.dart';
import 'package:electric_cars_calculator/main_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Add this line
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add this line
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  await Firebase.initializeApp();

  // Crashlytics 설정
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const EVCalculatorApp());
}

class EVCalculatorApp extends StatelessWidget {
  const EVCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 표시를 없앤다.
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate, // Add this line
        GlobalWidgetsLocalizations.delegate, // Add this line
        GlobalCupertinoLocalizations.delegate, // Add this line
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      title: 'EV Cars Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true, // 최신 머터리얼 디자인 스타일 적용
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AppLocalizations 접근
    final localizations = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: Future.delayed(
          const Duration(seconds: 3), () => localizations.intro_completed_msg),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _splashLoadingWidget(snapshot));
      },
    );
  }
}

Widget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
  // 에러가 발생한 경우
  if (snapshot.hasError) {
    return const Text("Error!!");
  } else if (snapshot.hasData) {
    // 데이터가 있는 경우
    return const EVCalculatorHome();
  } else {
    // 데이터가 없는 경우
    return const IntroScreen();
  }
}
