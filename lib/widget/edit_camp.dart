import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Services/Camps.dart';
import '../ui/camping.dart';


class EditCamping extends StatefulWidget {
  final Gotocamping camping;
  final Function(Gotocamping) onCampingEdited;

  EditCamping({
    required this.camping,
    required this.onCampingEdited,
  });

  @override
  _EditCampingState createState() => _EditCampingState();
}

class _EditCampingState extends State<EditCamping> {
  final TextEditingController camping_nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  late DateTime selectedStartDate;
  late DateTime selectedFinishDate;
  final TextEditingController num_pplController = TextEditingController();
  final TextEditingController num_employeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStartDate = widget.camping.startDate;
    selectedFinishDate = widget.camping.finishDate;
    camping_nameController.text = widget.camping.camping_name;
    placeController.text = widget.camping.place;
    num_pplController.text = widget.camping.num_ppl.toString();
    num_employeeController.text = widget.camping.num_employee.toString();
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
        title: Text('Edit Camping'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: camping_nameController,
              decoration: InputDecoration(labelText: 'اسم الرحلة'),
            ),
            TextField(
              controller: placeController,
              decoration: InputDecoration(labelText: 'مكان الرحلة'),
            ),
            GestureDetector(
              onTap: () => _selectStartDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'تاريخ بدء الرحلة',
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
                    labelText: 'تاريخ انتهاء الرحلة',
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
              decoration: InputDecoration(labelText: 'عدد الأشخاص المسافرين'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: num_employeeController,
              decoration: InputDecoration(labelText: 'عدد الموظفين الذاهبين'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel',style: TextStyle(color: Colors.blueGrey),)),
          TextButton(
            onPressed: () {
              widget.camping.setName = camping_nameController.text;
              widget.camping.setPlace = placeController.text;
              widget.camping.setStartDate = selectedStartDate;
              widget.camping.setFinishDate = selectedFinishDate;
              widget.camping.setNumPeople =
                  int.tryParse(num_pplController.text) ?? 0;
              widget.camping.setNumEmployee =
                  int.tryParse(num_employeeController.text) ?? 0;

              widget.onCampingEdited(widget.camping);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
