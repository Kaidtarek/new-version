import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Services/Camps.dart';

class AddCamping extends StatefulWidget {
  final Function(Gotocamping) onCampingAdded;

  AddCamping({required this.onCampingAdded});

  @override
  _AddCampingState createState() => _AddCampingState();
}

class _AddCampingState extends State<AddCamping> {
  
  final TextEditingController camping_nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  late DateTime selectedStartDate;
  late DateTime selectedFinishDate;
  final TextEditingController num_pplController = TextEditingController();
  final TextEditingController num_employeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStartDate = DateTime.now();
    selectedFinishDate = DateTime.now();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectFinishDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFinishDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedFinishDate) {
      setState(() {
        selectedFinishDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('تخييم جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: camping_nameController,
              decoration: InputDecoration(labelText: 'الاسم'),
            ),
            TextField(
              controller: placeController,
              decoration: InputDecoration(labelText: 'الوجهة'),
            ),
            GestureDetector(
              onTap: () => _selectStartDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'تاريخ البداية',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: DateFormat.yMd().format(selectedStartDate),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectFinishDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'تاريخ النهاية',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: DateFormat.yMd().format(selectedFinishDate),
                  ),
                ),
              ),
            ),
            TextField(
              controller: num_pplController,
              decoration: InputDecoration(labelText: 'عدد المسافرين'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: num_employeeController,
              decoration: InputDecoration(labelText: 'عدد المنظمين'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('الغاء', style: TextStyle(color: Colors.blueGrey)),
          ),
          TextButton(
            onPressed: () {
              Gotocamping newcamp = Gotocamping(
                camping_name: camping_nameController.text,
                num_employee: int.tryParse(num_employeeController.text) ?? 0,
                num_ppl: int.tryParse(num_pplController.text) ?? 0,
                place: placeController.text,
                startDate: selectedStartDate,
                finishDate: selectedFinishDate,
              );

              FirebaseFirestore.instance.collection('camping').doc().set({
                'camping_name': newcamp.camping_name,
                'place': newcamp.place,
                'startDate': newcamp.startDate,
                'finishDate': newcamp.finishDate,
                'num_ppl': newcamp.num_ppl,
                'num_employee': newcamp.num_employee,
              });

              widget.onCampingAdded(newcamp);
              Navigator.pop(context);
            },
            child: Text('اضافة'),
          ),
        ],
      ),
    );
  }
}
