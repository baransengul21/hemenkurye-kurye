import 'package:flutter/material.dart';

void main() {
  runApp(const HemenKuryeApp());
}

class HemenKuryeApp extends StatelessWidget {
  const HemenKuryeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HemenKurye Kurye',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'HemenKurye Kurye Uygulaması Yolda!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
