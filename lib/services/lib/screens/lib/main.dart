import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HemenKuryeApp());
}

class HemenKuryeApp extends StatelessWidget {
  const HemenKuryeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HemenKurye',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'system-ui',
      ),
      home: const HomeScreen(),
    );
  }
}
