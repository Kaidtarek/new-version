import 'package:flutter/material.dart';
import 'package:kafil/widget/add_camp.dart';
import 'package:kafil/widget/edit_camp.dart';
import 'package:kafil/widget/stockwithSearch.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Services/Camps.dart';

class Camp extends StatefulWidget {
  final bool just_see;
  Camp({required this.just_see});
  @override
  State<Camp> createState() => _CampState();
}

class _CampState extends State<Camp> {
  List<Gotocamping> camping_info = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: 
      widget.just_see ?
      FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddCamping(
                onCampingAdded: (itemCamp) {
                  setState(() {
                    camping_info.add(itemCamp);
                  });
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ) : SizedBox(height: 0,),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 300,
              child: StockwithSearch(),
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.deepPurple,
              height: 2,
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('camping')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<Gotocamping> camping_info =
                      snapshot.data!.docs.map((doc) {
                    // Map the Firestore document data to your Gotocamping model class
                    return Gotocamping(
                      camping_name: doc['camping_name'],
                      place: doc['place'],
                      startDate: doc['startDate'].toDate(),
                      finishDate: doc['finishDate'].toDate(),
                      num_ppl: doc['num_ppl'],
                      num_employee: doc['num_employee'],
                    );
                  }).toList();

                  return ListView.builder(
                    itemCount: camping_info.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 255, 250, 250),
                        child: ListTile(
                          title: Text(camping_info[index].camping_name ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("الوجهة:  "),
                                  Text(
                                    '${camping_info[index].place ?? ''}',
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text("تاريخ البداية: "),
                                  Text(
                                    '${DateFormat.yMd().format(camping_info[index].startDate!)}',
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("تاريخ النهاية: "),
                                  Text(
                                    '${DateFormat.yMd().format(camping_info[index].finishDate!)}',
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("عدد الأشخاص المسافرين: "),
                                  Text(
                                    '${camping_info[index].num_ppl}',
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("عدد المنظمين: "),
                                  Text(
                                    '${camping_info[index].num_employee}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: 
                          widget.just_see ?
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditCamping(
                                    camping: camping_info[index],
                                    onCampingEdited: (editedCamp) {
                                      setState(() {
                                        camping_info[index] = editedCamp;
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          ) : SizedBox(height: 0,)
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
