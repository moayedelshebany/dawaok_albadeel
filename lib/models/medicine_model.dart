class Medicine {
  final String id;
  final String name;
  final String activeIngredient;
  final String alternative;
  final String price;
  final String form;

  Medicine({
    required this.id,
    required this.name,
    required this.activeIngredient,
    required this.alternative,
    required this.price,
    required this.form,
  });

  // تحويل البيانات من فايربيز إلى كائن (Object)
  factory Medicine.fromMap(Map<String, dynamic> map, String documentId) {
    return Medicine(
      id: documentId,
      name: map['name'] ?? '',
      activeIngredient: map['active'] ?? '',
      alternative: map['alternative'] ?? '',
      price: map['price']?.toString() ?? '0',
      form: map['form'] ?? 'حبوب',
    );
  }

  // تحويل من كائن إلى Map لإرساله لفايربيز عند التعديل
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'active': activeIngredient,
      'alternative': alternative,
      'price': price,
      'form': form,
    };
  }
}
