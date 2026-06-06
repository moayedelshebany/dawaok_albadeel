import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine_model.dart';
import '../components/medicine_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("أدويتي المفضلة"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // ملاحظة: هنا نفترض وجود حقل في فايربيز اسمه isFavorite
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('isFavorite', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          var docs = snapshot.data!.docs;
          if (docs.isEmpty)
            return const Center(child: Text("لا توجد أدوية في المفضلة حالياً"));

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              Medicine med = Medicine.fromMap(
                docs[index].data() as Map<String, dynamic>,
                docs[index].id,
              );
              return MedicineCard(
                medicine: med,
                isFavorite: true,
                onTap: () {},
                onEdit: () {},
                onDelete: () {},
                onFavorite: () {
                  FirebaseFirestore.instance
                      .collection('products')
                      .doc(med.id)
                      .update({'isFavorite': false});
                },
              );
            },
          );
        },
      ),
    );
  }
}
