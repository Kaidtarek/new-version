import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/Employee.dart';

class ProfilePage extends StatefulWidget {
  final bool just_see;
  ProfilePage({required this.just_see});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController searchController = TextEditingController();

  Stream<QuerySnapshot> getFilteredStream(String searchQuery) {
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('Employees').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('Employees')
          .where('full_name', isGreaterThanOrEqualTo: searchQuery)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(labelText: 'البحث عن الموظفين'),
              onChanged: (value) {
                setState(() {});
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getFilteredStream(searchController.text),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return ListView(
                    children: (snapshot.data!.docs as List<DocumentSnapshot>)
                        .where((document) =>
                            (document.data()
                                    as Map<String, dynamic>?)?['full_name']
                                ?.toString()
                                .toLowerCase()
                                .contains(
                                    searchController.text.toLowerCase()) ??
                            false)
                        .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          (document.data() as Map<String, dynamic>?) ?? {};
                      Employee e = Employee(
                          name: data['full_name'],
                          age: data['age'],
                          phone: data['phone_number']);
                      return Card(
                        color: Colors.grey[400],
                        elevation: 0,
                        child: ListTile(
                          title: Text(e.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('العمر: ${e.age}'),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('رقم الهاتف:'),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      e.phone,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _makePhoneCall(e.phone.toString());
                                    },
                                    icon: Icon(
                                      Icons.call,
                                      color: Colors.green,
                                    ),
                                  ),
                                  widget.just_see ?
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Show the edit employee dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return EditEmployeeDialog(
                                            employee: e,
                                            doc: document.id,
                                          );
                                        },
                                      );
                                    },
                                  ) : SizedBox(height: 0,),
                                  widget.just_see ?
                                  IconButton(
                                    onPressed: () {
                                      Employee.delete_employee(document.id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ) : SizedBox(height: 0,)
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: 
      widget.just_see ?
      FloatingActionButton(
        onPressed: () {
          // Show the add employee dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddEmployeeDialog();
            },
          );
        },
        child: Image.asset('assets/add_employee.png'),
      ) : SizedBox(height: 0,),
    );
  }
}

class AddEmployeeDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('اضافة موظف'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'الاسم'),
          ),
          TextField(
            controller: ageController,
            decoration: InputDecoration(labelText: 'العمر'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: 'رقم الهاتف'),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Create a new Employee object
            Employee employee = Employee(
              name: nameController.text,
              age: ageController.text ?? "",
              phone: phoneController.text,
            );

            employee.add_employee();
            Navigator.pop(context);
          },
          child: Text('اضافة'),
        ),
      ],
    );
  }
}

class EditEmployeeDialog extends StatefulWidget {
  final Employee employee;
  final String doc;
  EditEmployeeDialog({required this.employee, required this.doc});

  @override
  _EditEmployeeDialogState createState() => _EditEmployeeDialogState();
}

class _EditEmployeeDialogState extends State<EditEmployeeDialog> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee.name);
    ageController = TextEditingController(text: widget.employee.age.toString());
    phoneController = TextEditingController(text: widget.employee.phone);
    print("this is the doc for editing the employee ${widget.doc}");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تعديل الموظف'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'الاسم'),
          ),
          TextField(
            controller: ageController,
            decoration: InputDecoration(labelText: 'العمر'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: 'رقم الهاتف'),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Create a new Employee object with updated details
            Employee updatedEmployee = Employee(
              name: nameController.text,
              age: ageController.text ?? "",
              phone: phoneController.text,
            );
            print("this is the new age ${updatedEmployee.age}");
            // Call the onEmployeeUpdated callback with the updated employee
            updatedEmployee.edit_employee(widget.doc);
            Navigator.pop(context);
          },
          child: Text('تحديث'),
        ),
      ],
    );
  }
}

void _makePhoneCall(String phoneNumber) async {
  String url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
