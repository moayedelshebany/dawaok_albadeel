import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/center_hero_section.dart';
import '../components/side_navigation.dart';
import '../components/category_card.dart';
import 'search_screen.dart';
import 'add_medicine_screen.dart';
import 'favorites_screen.dart';
import 'about_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    // توجيه بسيط دون تعقيد
    final List<Widget> screens = [
      const SizedBox(), // الرئيسية (تم عرضها بالفعل)
      const SearchScreen(),
      const FavoritesScreen(),
      const AboutScreen(),
    ];

    if (index > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screens[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: Row(
        children: [
          // القائمة الجانبية الاحترافية
          SafeArea(
            child: SideNavigation(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
            ),
          ),

          // المحتوى الرئيسي
          Expanded(
            child: Column(
              children: [
                // 1. رأس الصفحة المخصص (بديل الـ AppBar)
                _buildCustomHeader(),

                // 2. الهيرو سيكشن
                const CenterHeroSection(),

                // 3. شبكة الخدمات
                Expanded(
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .get(),
                    builder: (context, snapshot) {
                      List<Widget> gridItems = [
                        CategoryCard(
                          title: "البحث الذكي",
                          subtitle: "ابحث عن بديل",
                          icon: Icons.search_rounded,
                          color: Colors.blue,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          ),
                        ),
                        CategoryCard(
                          title: "المفضلة",
                          subtitle: "أدويتك المحفوظة",
                          icon: Icons.favorite_rounded,
                          color: Colors.redAccent,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavoritesScreen(),
                            ),
                          ),
                        ),
                        CategoryCard(
                          title: "عن التطبيق",
                          subtitle: "معلومات عنا",
                          icon: Icons.info_rounded,
                          color: Colors.orange,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutScreen(),
                            ),
                          ),
                        ),
                      ];

                      if (snapshot.hasData &&
                          snapshot.data!.exists &&
                          snapshot.data!.get('role') == 'admin') {
                        gridItems.add(
                          CategoryCard(
                            title: "إضافة دواء",
                            subtitle: "لوحة التحكم",
                            icon: Icons.add_box_rounded,
                            color: Colors.green,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddMedicineScreen(),
                              ),
                            ),
                          ),
                        );
                      }

                      return GridView.count(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        children: gridItems,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // تصميم رأس الصفحة المخصص
  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "لوحة التحكم",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: "تسجيل الخروج",
            onPressed: () async {
              // 1. تسجيل الخروج من Firebase
              await FirebaseAuth.instance.signOut();

              // 2. التحقق من أن السياق (context) لا يزال متاحاً
              if (context.mounted) {
                // 3. التوجيه إلى شاشة تسجيل الدخول (استبدل '/' بمسار شاشة الدخول لديك)
                // هذا الأمر يحذف كل الصفحات السابقة من الذاكرة لضمان عدم عودة المستخدم للخلف
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
