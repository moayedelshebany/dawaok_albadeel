import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/custom_textfield.dart';
import '../components/custom_button.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _activeController = TextEditingController();
  final TextEditingController _altController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _selectedForm;
  final List<String> _medicineForms = [
    'أقراص (Tablets)',
    'شراب (Syrup)',
    'مرهم (Ointment)',
    'كريم (Cream)',
    'حقن (Injection)',
    'قطرة (Drops)',
    'أخرى',
  ];

  Future<void> _saveMedicine() async {
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text.trim(),
        'active': _activeController.text.trim(),
        'alternative': _altController.text.trim(),
        'price': _priceController.text.trim(),
        'form': _selectedForm,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _showSuccessDialog();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
    }
  }

  // 🔹 تم تعريف الدالة هنا رسمياً
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_done_rounded,
                    size: 60,
                    color: Color(0xFF06B6D4),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تم الحفظ بنجاح!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _nameController.clear();
                      _activeController.clear();
                      _altController.clear();
                      _priceController.clear();
                      setState(() => _selectedForm = null); // تنظيف القائمة
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'موافق',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'إضافة دواء جديد',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(
              Icons.add_business_rounded,
              size: 70,
              color: Color(0xFF1E3A8A),
            ),
            const SizedBox(height: 25),
            CustomTextField(
              hintText: 'اسم الدواء الأصلي',
              icon: Icons.label,
              controller: _nameController,
            ),
            const SizedBox(height: 15),

            // 🔹 القائمة المنسدلة
            DropdownButtonFormField<String>(
              value: _selectedForm,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'اختر الشكل الدوائي',
                prefixIcon: const Icon(
                  Icons.category_rounded,
                  color: Color(0xFF1E3A8A),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _medicineForms
                  .map(
                    (form) => DropdownMenuItem(value: form, child: Text(form)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedForm = value),
            ),

            const SizedBox(height: 15),
            CustomTextField(
              hintText: 'المادة الفعالة',
              icon: Icons.science_rounded,
              controller: _activeController,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: 'البدائل التجارية',
              icon: Icons.cached_rounded,
              controller: _altController,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: 'السعر الحالي',
              icon: Icons.payments_rounded,
              controller: _priceController,
            ),
            const SizedBox(height: 35),
            CustomButton(
              label: 'حفظ الدواء ',

              icon: Icons.cloud_upload_rounded,
              onPressed: () {
                if (_nameController.text.isNotEmpty && _selectedForm != null) {
                  _saveMedicine();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى ملء الاسم واختيار الشكل الدوائي'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
