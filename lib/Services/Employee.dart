import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final db = FirebaseFirestore.instance;
  String name;
  String age;
  String phone;

  Employee({
    required this.name,
    required this.age,
    required this.phone,
  });
  Map<String, dynamic> toMap() {
    return {'full_name': name, 'age': age.toString(), 'phone_number': phone};
  }

  Future<void> add_employee() async {
    await db.collection('Employees').add(this.toMap());
  }

  Future<void> edit_employee(String doc) async {
    await db.collection('Employees').doc(doc).set(this.toMap());
  }

  static Future<void> delete_employee(String doc) async {
    final db = FirebaseFirestore.instance;
    await db
        .collection('Employees')
        .doc(doc)
        .delete()
        .onError((error, stackTrace) => print("error")); 
  }
}