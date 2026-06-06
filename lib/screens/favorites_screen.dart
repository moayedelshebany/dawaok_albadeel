import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/medicine_model.dart';
import '../components/medicine_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("أدويتي المفضلة"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? const Center(child: Text("يرجى تسجيل الدخول لعرض المفضلة"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('favorites')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("لا توجد أدوية في المفضلة حالياً"),
                  );
                }

                var docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    String medicineId = docs[index]['medicineId'];

                    // استخدام FutureBuilder لجلب بيانات الدواء بناءً على ID
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('products')
                          .doc(medicineId)
                          .get(),
                      builder: (context, medSnapshot) {
                        // حالة التحميل لكل عنصر في القائمة
                        if (medSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: LinearProgressIndicator(),
                          );
                        }

                        // في حال لم نجد الدواء أو تم حذفه
                        if (!medSnapshot.hasData || !medSnapshot.data!.exists) {
                          return const SizedBox.shrink();
                        }

                        Medicine med = Medicine.fromMap(
                          medSnapshot.data!.data() as Map<String, dynamic>,
                          medSnapshot.data!.id,
                        );

                        return MedicineCard(
                          medicine: med,
                          isFavorite: true,
                          onTap: () {},
                          onEdit: () {},
                          onDelete: () {},
                          onFavorite: () async {
                            // حذف العلاقة من جدول المفضلة
                            await FirebaseFirestore.instance
                                .collection('favorites')
                                .doc(docs[index].id)
                                .delete();
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
