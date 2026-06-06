import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../components/custom_textfield.dart';

import '../components/medicine_card.dart';

import '../models/medicine_model.dart';

import 'medicine_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = "";

  void _confirmDelete(String docId, String name) {
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف', textAlign: TextAlign.right),

        content: Text(
          'هل أنت متأكد من حذف "$name"؟',

          textAlign: TextAlign.right,
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),

            child: const Text('إلغاء'),
          ),

          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('products')
                  .doc(docId)
                  .delete();

              Navigator.pop(context);
            },

            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Medicine med) {
    TextEditingController nameCtrl = TextEditingController(text: med.name);

    TextEditingController activeCtrl = TextEditingController(
      text: med.activeIngredient,
    );

    TextEditingController altCtrl = TextEditingController(
      text: med.alternative,
    );

    TextEditingController priceCtrl = TextEditingController(text: med.price);

    TextEditingController formCtrl = TextEditingController(text: med.form);

    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        title: const Text('تعديل البيانات', textAlign: TextAlign.right),

        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,

                decoration: const InputDecoration(labelText: 'اسم الدواء'),
              ),

              TextField(
                controller: activeCtrl,

                decoration: const InputDecoration(labelText: 'المادة الفعالة'),
              ),

              TextField(
                controller: altCtrl,

                decoration: const InputDecoration(labelText: 'البديل'),
              ),

              TextField(
                controller: priceCtrl,

                decoration: const InputDecoration(labelText: 'السعر'),
              ),

              TextField(
                controller: formCtrl,

                decoration: const InputDecoration(labelText: 'الشكل الصيدلاني'),
              ),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),

            child: const Text('إلغاء'),
          ),

          ElevatedButton(
            onPressed: () {
              Medicine updatedMed = Medicine(
                id: med.id,

                name: nameCtrl.text,

                activeIngredient: activeCtrl.text,

                alternative: altCtrl.text,

                price: priceCtrl.text,

                form: formCtrl.text,
              );

              FirebaseFirestore.instance
                  .collection('products')
                  .doc(med.id)
                  .update(updatedMed.toMap());

              Navigator.pop(context);
            },

            child: const Text('حفظ التعديل'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      appBar: AppBar(
        title: const Text(
          "البحث الذكي الشامل",

          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),

            child: CustomTextField(
              hintText: 'ابحث باسم الدواء، المادة، أو البديل...',

              icon: Icons.manage_search_rounded,

              controller: _searchController,

              onChanged: (val) =>
                  setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),

          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),

              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                // التحقق من الصلاحية: هل المستخدم هو أدمن؟

                bool isAdmin =
                    (userSnapshot.data!.exists &&
                    userSnapshot.data!.get('role') == 'admin');

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Center(child: CircularProgressIndicator());

                    var docs = snapshot.data!.docs.where((d) {
                      var data = d.data() as Map<String, dynamic>;

                      String name = (data['name'] ?? '')
                          .toString()
                          .toLowerCase();

                      String active = (data['active'] ?? '')
                          .toString()
                          .toLowerCase();

                      String alternative = (data['alternative'] ?? '')
                          .toString()
                          .toLowerCase();

                      return name.contains(_searchQuery) ||
                          active.contains(_searchQuery) ||
                          alternative.contains(_searchQuery);
                    }).toList();

                    if (docs.isEmpty)
                      return const Center(child: Text("لا توجد نتائج مطابقة"));

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),

                      itemCount: docs.length,

                      itemBuilder: (context, index) {
                        var data = docs[index].data() as Map<String, dynamic>;

                        Medicine med = Medicine.fromMap(data, docs[index].id);

                        return MedicineCard(
                          medicine: med,

                          isAdmin:
                              isAdmin, // ⬅️ تمرير الصلاحية للكارد ليخفي/يظهر الأزرار

                          isFavorite: data['isFavorite'] ?? false,

                          onFavorite: () {
                            FirebaseFirestore.instance
                                .collection('products')
                                .doc(med.id)
                                .update({
                                  'isFavorite': !(data['isFavorite'] ?? false),
                                });
                          },

                          onTap: () => Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  MedicineDetailsScreen(medicine: med),
                            ),
                          ),

                          onEdit: () => _showEditDialog(med),

                          onDelete: () => _confirmDelete(med.id, med.name),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
