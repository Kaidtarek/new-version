import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kafil/Services/Family.dart';
import 'package:kafil/Services/info_list.dart';
import 'package:kafil/ui/add_family.dart';
import 'package:url_launcher/url_launcher.dart';

class FamilyPage extends StatefulWidget {
  FamilyPage({required this.brief_info_family});
  bool brief_info_family;
  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final Stream<QuerySnapshot> _familiesStream =
      FirebaseFirestore.instance.collection('family').snapshots();

  Future<List<DocumentSnapshot>> getKidsDocuments(
      DocumentSnapshot familyDocument) async {
    final kidsSnapshot =
        await familyDocument.reference.collection('Kids').get();
    return kidsSnapshot.docs;
  }

  Future<List<Kids>> change(DocumentSnapshot familyDocument) async {
    List<Kids> kids = [];
    final kidsDocuments = await getKidsDocuments(familyDocument);
    final kidsData = kidsDocuments.map((doc) => doc.data()).toList();
    for (var (kidData as Map) in kidsData) {
      Kids k = Kids(
        age: kidData['age'],
        name: kidData['name'],
        work: kidData['job'],
        sick: kidData['sick'],
      );
      kids.add(k);
    }
    return kids;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "العائلات",
              style: TextStyle(fontSize: 35),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _familiesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('حدث خطأ أعد المحاولة');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return const Center(child: Text('لايوجد عائلات'));
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    return FutureBuilder<List<Kids>>(
                      future: change(document),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Kids>> kidsSnapshot) {
                        if (kidsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (kidsSnapshot.hasError) {
                          return Text('Error: ${kidsSnapshot.error}');
                        }

                        final List<Kids> kids = kidsSnapshot.data ?? [];

                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return Column(
                          children: [
                            Card(
                              child: ListTile(
                                  title: Text(data['family_name']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Column(
                                                      children: infoList(
                                                          document,
                                                          kidsSnapshot),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.info_outline),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.location_on),
                                            onPressed: () async {
                                              final url =
                                                  "https://www.google.com/maps/search/?api=1&query=${data['location']}";
                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text("Error"),
                                                    content: Text(
                                                        "خطأ في فتح الخريطة الرجاء المجاولة أو اتصل بنا "),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("حسنا"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          SizedBox(width: 4),
                                          widget.brief_info_family
                                              ? IconButton(
                                                  icon: Icon(Icons.edit,
                                                      color: Colors.deepPurple),
                                                  onPressed: () {
                                                    print(
                                                        "i am on the view and this is kids $kids");
                                                    Family f = Family(
                                                      life_formula_inHouse: data[
                                                          'life_formula_inHouse'],
                                                      family_need:
                                                          data['family_need'],
                                                      family_name:
                                                          data['family_name'],
                                                      father_name:
                                                          data['father_name'],
                                                      mother_name:
                                                          data['mother_name'],
                                                      father_sick:
                                                          data['father_sick'],
                                                      mother_sick:
                                                          data['mother_sick'],
                                                      fatherInLife:
                                                          data['father_alive'],
                                                      motherInLife:
                                                          data['mother_alive'],
                                                      location:
                                                          data['location'],
                                                      house_type:
                                                          data['house_type'],
                                                      elc_power:
                                                          data['elc_power'],
                                                      gaz_power:
                                                          data['gaz_power'],
                                                      kids: kids,
                                                    );
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FamilyEditor(
                                                                  initialFamily:
                                                                      f,
                                                                  doc: document
                                                                      .reference,
                                                                )));
                                                  },
                                                )
                                              : SizedBox(
                                                  height: 0,
                                                )
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: widget.brief_info_family
                                      ? IconButton(
                                          onPressed: () {
                                            Family.delete_family(document.id);
                                          },
                                          icon: Icon(Icons.delete),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        )),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.brief_info_family
    ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FamilyEditor()),
          );
        },
        child: Icon(Icons.add),
      )
    : SizedBox(height: 5),

    );
  }
}
