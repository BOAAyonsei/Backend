import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SafeVoiceApp());
}

class SafeVoiceApp extends StatelessWidget {
  const SafeVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Voice',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}