import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'screens/splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دواؤك البديل',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF06B6D4), 
          background: const Color(0xFFF8FAFC), 
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // الانطلاق من شاشة الفتح باللوغو الفخم
    );
  }
}
