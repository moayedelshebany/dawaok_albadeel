import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false; // لإظهار مؤشر تحميل أثناء التسجيل

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true); // نبدأ التحميل
    
    // نستدعي دالة التسجيل (تأكد أن الدالة في AuthService ترجع المستخدم أو Boolean)
    // إذا كنت تستخدم الكود القديم الذي يرجع User? استبدل القيم هنا
    await _authService.signInWithGoogle(); 
    
    setState(() => _isLoading = false); // ننتهي من التحميل

    if (mounted) {
      // بعد محاولة تسجيل الدخول، ننتقل مباشرة للداش بورد
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A8A), Color(0xFF06B6D4)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medical_services_rounded, size: 120, color: Colors.white),
            const SizedBox(height: 30),
            const Text(
              "دواؤك البديل",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                "اكتشف البدائل المناسبة لأدويتك بأمان وسهولة.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 50),
            
            // زر التسجيل (نفس المنطق الذي كان يعمل في AboutScreen)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: const Icon(Icons.g_mobiledata, size: 30),
                    label: const Text("تسجيل الدخول باستخدام Google", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: _handleGoogleSignIn,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}