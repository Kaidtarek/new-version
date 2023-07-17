import 'package:cloud_firestore/cloud_firestore.dart';

class Family {
  String family_name;
  String father_name;
  String mother_name;
  bool fatherInLife;
  bool motherInLife;
  String father_sick;
  String mother_sick;
  List<Kids> kids;
  String location;
  String house_type;
  String life_formula_inHouse;
  String elc_power;
  String gaz_power;
  String family_need;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Family({
    required this.life_formula_inHouse,
    required this.family_need,
    required this.gaz_power,
    required this.elc_power,
    required this.house_type,
    required this.family_name,
    required this.location,
    required this.father_name,
    required this.mother_name,
    required this.father_sick,
    required this.mother_sick,
    required this.fatherInLife,
    required this.motherInLife,
    required this.kids,
  });
  Map<String, dynamic> toMap() {
    return {
      'life_formula_inHouse' : life_formula_inHouse,
      'family_need' : family_need,
      'family_name': family_name,
      'location': location,
      'father_name': father_name,
      'father_alive': fatherInLife,
      'father_sick': father_sick,
      'mother_name': mother_name,
      'mother_alive': motherInLife,
      'mother_sick': mother_sick,
      'house_type' : house_type,
      'elc_power' : elc_power,
      'gaz_power' : gaz_power,
    };
  }

  Future<bool> add_family() async {
    try {
      DocumentReference familyDocRef =
          await db.collection("family").add(this.toMap());
      CollectionReference KidsCollectionref = familyDocRef.collection("Kids");
      for (var kid in kids) {
        await KidsCollectionref.add(kid.toMap());
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> edit_family(String id) async {
    print("THIS IS ID $id");
    db
        .collection('family')
        .doc(id)
        .set(this.toMap())
        .onError((error, stackTrace) => print("this is the error $error"));
    try {
      CollectionReference KidsCollectionref =
          db.collection("family").doc(id).collection("Kids");
      QuerySnapshot snapshot = await KidsCollectionref.get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      for (var kid in kids) {
        await KidsCollectionref.add(kid.toMap());
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<void> delete_family(String doc) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a batched write to perform multiple operations atomically
    final WriteBatch batch = firestore.batch();

    final DocumentReference familyRef = firestore.collection('family').doc(doc);

    final CollectionReference kidsRef = familyRef.collection('kids');

    // Query and delete all documents within the kids subcollection
    final QuerySnapshot kidsSnapshot = await kidsRef.get();
    for (final DocumentSnapshot kidDoc in kidsSnapshot.docs) {
      batch.delete(kidDoc.reference);
    }
    // Delete the family document
    batch.delete(familyRef);

    // Get the kids subcollection reference

    // Commit the batched write
    await batch.commit();

    print('Family and kids deleted successfully!');
  }
}

class Kids {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String name;
  int age;
  String work;
  String sick;

  Kids({
    required this.name,
    required this.age,
    required this.work,
    required this.sick,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'job': work,
      'sick': sick,
    };
  }
}
