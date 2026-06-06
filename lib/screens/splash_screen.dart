import 'package:flutter/material.dart';
import 'welcom_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // تأخير زمني لمدة 3 ثوانٍ ثم الانتقال إلى شاشة اللوحة الرئيسية
// في ملف splash_screen.dart
Future.delayed(const Duration(seconds: 4), () {
  if (mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF06B6D4)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // عرض لوغو التطبيق مع تأثير ظل ناعم حوله
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
                child: Image.asset(
                'assets/logo.png',
                width: 100, // 🔹 قمنا بتكبير القيمة هنا ليظهر الشعار فخماً وواضحاً عند الفتح
                height: 200,
                
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.healing_rounded,
                  size: 30,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'دواؤك البديل',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'رعاية صحية ذكية بمتناول يدك',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 50),
            // مؤشر تحميل أنيق باللون الأبيض
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}