import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../Services/Stock.dart';

class My_stock extends StatefulWidget {
  final bool just_see;
  My_stock({required this.just_see});
  @override
  State<My_stock> createState() => _My_stockState();
}

class _My_stockState extends State<My_stock> {
  final _product_straem =
      FirebaseFirestore.instance.collection('Products').snapshots();
  List<Stock> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "المستودع",
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.teal, fontSize: 30),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: _product_straem,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 48,
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      String Doc_id = document.reference.id;
                      print("this is doc id : $Doc_id");
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      DateTime add_date = data['Add_date'].toDate();
                      DateTime exp_date = data['exp_date'].toDate();
                      Stock produit = Stock(data['Product_name'], exp_date,
                          add_date, data['Quantity']);

                      return Card(
                        color: Colors.grey[400],
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: ListTile(
                                    title: Text(
                                        "المنتوج : ${data['Product_name']}"),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text("الكمية : ${data['Quantity']}"),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "تمت اضافته يوم : ${DateFormat.yMMMd().format(produit.added_date)}",
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    'تاريخ انتهاء الصلاحية : ${DateFormat.yMMMd().format(produit.expiry_date)}',
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      widget.just_see ?
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return EditProductDialog(
                                                stock: produit,
                                                doc_id: Doc_id,
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit_calendar_outlined,
                                          size: 35,
                                          color:
                                              Color.fromARGB(255, 2, 115, 61),
                                        ),
                                      ) : SizedBox(height: 0,),
                                      widget.just_see ?
                                      IconButton(
                                        onPressed: () {
                                          Stock.delete_product(Doc_id);
                                        },
                                        icon: Icon(
                                          Icons.delete_forever_sharp,
                                          size: 35,
                                          color:
                                              Color.fromARGB(255, 218, 82, 40),
                                        ),
                                      ) : SizedBox(height: 0,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })
                    .toList()
                    .cast(),
              );
            }),
      ),
      floatingActionButton: 
      widget.just_see ?
      FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return addProductDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ) : SizedBox(height: 
      0,)
    );
  }
}

class EditProductDialog extends StatefulWidget {
  final Stock stock;
  final String doc_id;
  EditProductDialog({required this.stock, required this.doc_id});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  late TextEditingController dateController;

  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.stock.product_name);
    quantityController = TextEditingController(text: widget.stock.quantity);
    selectedDate = widget.stock.expiry_date;
    dateController = TextEditingController(
        text: DateFormat.yMMMd().format(widget.stock.expiry_date));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat.yMMMd().format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تعديل المنتوج '),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'الاسم'),
          ),
          TextField(
            controller: quantityController,
            decoration: InputDecoration(labelText: 'الكمية'),
          ),
          TextField(
            controller: dateController,
            decoration: InputDecoration(labelText: 'تاريخ انتهاء الصلاحية'),
            onTap: () => _selectDate(context),
            readOnly: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Stock updateStock = Stock(nameController.text, selectedDate,
                widget.stock.added_date, quantityController.text);
            updateStock.edit(widget.doc_id);
            Navigator.pop(context);
          },
          child: Text(
            'تحديث',
          ),
        ),
      ],
    );
  }
}

// ignore: camel_case_types, must_be_immutable
class addProductDialog extends StatefulWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  late DateTime selectedDate;

  @override
  State<addProductDialog> createState() => _addProductDialogState();
}

class _addProductDialogState extends State<addProductDialog> {
  @override
  void initState() {
    super.initState();
    widget.selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != widget.selectedDate) {
      setState(() {
        widget.selectedDate = picked;
        widget.dateController.text =
            DateFormat.yMMMd().format(widget.selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('اضافة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.nameController,
            decoration: InputDecoration(labelText: 'الاسم'),
          ),
          TextField(
            controller: widget.quantityController,
            decoration: InputDecoration(labelText: 'الكمية'),
          ),
          TextField(
            controller: widget.dateController,
            decoration: InputDecoration(labelText: 'انتهاء الصلاحية'),
            onTap: () => _selectDate(context),
            readOnly: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Stock updateStock = Stock(
                widget.nameController.text,
                widget.selectedDate,
                DateTime.now(),
                widget.quantityController.text);
            updateStock.AddProduct();
            Navigator.pop(context);
          },
          child: Text(
            'اضافة',
          ),
        ),
      ],
    );
  }
}