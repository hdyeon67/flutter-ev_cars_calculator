import 'package:electric_cars_calculator/intro_screen.dart';
import 'package:electric_cars_calculator/main_calculator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EVCalculatorApp());
}

class EVCalculatorApp extends StatelessWidget {
  const EVCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 표시를 없앤다.
      title: 'EV Cars Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true, // 최신 머터리얼 디자인 스타일 적용
      ),
      home: FutureBuilder(
        future: Future.delayed(
            const Duration(seconds: 3), () => "Intro Completed."),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _splashLoadingWidget(snapshot));
        },
      ),
    );
  }
}

Widget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
  if (snapshot.hasError) {
    return const Text("Error!!");
  } else if (snapshot.hasData) {
    return const EVCalculatorHome();
  } else {
    return const IntroScreen();
  }
}
