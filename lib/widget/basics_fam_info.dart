import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kafil/Services/info_list.dart';
import '../Services/Family.dart';
import 'beauty_item_look.dart';

class GetFamilies extends StatefulWidget {
  final bool Check_box;
  GetFamilies({required this.Check_box});
  @override
  State<GetFamilies> createState() => _GetFamiliesState();
}

class _GetFamiliesState extends State<GetFamilies> {
  Map<String, String?> selectedFamilies = {};

  final Stream<QuerySnapshot> _familiesStream =
      FirebaseFirestore.instance.collection('family').snapshots();

  Future<List<Kids>> change(
      DocumentSnapshot familyDocument, String familyId) async {
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

  Future<List<DocumentSnapshot>> getKidsDocuments(
      DocumentSnapshot familyDocument) async {
    final kidsSnapshot =
        await familyDocument.reference.collection('Kids').get();
    return kidsSnapshot.docs;
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
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return const Center(child: Text('لايوجد'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    String familyId = document.id;

                    return FutureBuilder<List<Kids>>(
                      future: change(document, familyId),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Kids>> kidsSnapshot) {
                        if (kidsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (kidsSnapshot.hasError) {
                          return Text('Error: ${kidsSnapshot.error}');
                        }

                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        List<Widget> infoListItems = infoList(document, kidsSnapshot);

                        return Column(
                          children: [
                            Card(
                              child: ListTile(
                                title: Text(data['family_name']),
                                subtitle: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Column(
                                                children: infoListItems,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(' info'),
                                    ),
                                    if (widget.Check_box == true)
                                      Checkbox(
                                        value: selectedFamilies[familyId] ==
                                            familyId,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedFamilies[familyId] =
                                                  familyId;
                                            } else {
                                              selectedFamilies[familyId] = null;
                                            }
                                          });

                                          if (selectedFamilies[familyId] ==
                                              familyId) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Icon(
                                                    Icons
                                                        .volunteer_activism_rounded,
                                                    size: 50,
                                                    color: Colors.green,
                                                  ),
                                                  content: Text(
                                                    "تمت الاضافة بنجاح",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255, 51, 73, 70)),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      child: Text("حسنا"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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