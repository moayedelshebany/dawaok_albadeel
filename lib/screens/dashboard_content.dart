import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/center_hero_section.dart';
import '../components/category_card.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'about_screen.dart';
import 'add_medicine_screen.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCustomHeader(context),
        const CenterHeroSection(),
        Expanded(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get(),
            builder: (context, snapshot) {
              List<Widget> gridItems = [
                CategoryCard(title: "البحث الذكي", subtitle: "ابحث عن بديل", icon: Icons.search_rounded, color: Colors.blue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()))),
                CategoryCard(title: "المفضلة", subtitle: "أدويتك المحفوظة", icon: Icons.favorite_rounded, color: Colors.redAccent, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()))),
                CategoryCard(title: "عن التطبيق", subtitle: "معلومات عنا", icon: Icons.info_rounded, color: Colors.orange, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()))),
              ];

              if (snapshot.hasData && snapshot.data!.exists && snapshot.data!.get('role') == 'admin') {
                gridItems.add(CategoryCard(title: "إضافة دواء", subtitle: "لوحة التحكم", icon: Icons.add_box_rounded, color: Colors.green, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedicineScreen()))));
              }

              return GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: gridItems,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("مرحباً بك مجدداً 👋", style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text("لوحة التحكم", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            ],
          ),
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}