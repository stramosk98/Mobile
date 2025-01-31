import 'dart:async';

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_activity_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTracker',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreenWithTimer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreenWithTimer extends StatefulWidget {
  const SplashScreenWithTimer({super.key});

  @override
  _SplashScreenWithTimerState createState() => _SplashScreenWithTimerState();
}

class _SplashScreenWithTimerState extends State<SplashScreenWithTimer> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
