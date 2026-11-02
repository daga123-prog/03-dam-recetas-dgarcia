import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recetasapp/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }); // Timer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, color: Colors.white, size: 90),
            const SizedBox(height: 16),
            const Text(
              "Recetas App",
              style: TextStyle(
                color: Colors.white, 
                fontSize: 30, 
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Sabores del Mayab",
              style: TextStyle(
                color: Colors.white70, 
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ), // Column
      ), // Center
    ); // Scaffold
  }
}