import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kafil/Services/about_house.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/Family.dart';

class FamilyEditor extends StatefulWidget {
  final Family? initialFamily;
  final DocumentReference? doc;

  const FamilyEditor({Key? key, this.initialFamily, this.doc})
      : super(key: key);

  @override
  _FamilyEditorState createState() => _FamilyEditorState();
}

class _FamilyEditorState extends State<FamilyEditor> {
  final _kidKey = GlobalKey<FormState>();

  String? btn1SelectedValue;
  TextEditingController family_needController = TextEditingController();
  TextEditingController familyNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController fatherSickController = TextEditingController();
  TextEditingController motherSickController = TextEditingController();
  TextEditingController kidsNameController = TextEditingController();
  TextEditingController kidsAgeController = TextEditingController();
  TextEditingController kidsWorkController = TextEditingController();
  TextEditingController kidsSickController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  bool fatherInLife = true;
  bool motherInLife = true;
  List<Kids> kids = [];
  String _selectedloc = "";
  void check() {
    Family? init = widget.initialFamily;
    if (init != null) {
      print("it's not null");
      selectedHouseType = init.house_type;
      familyNameController = TextEditingController(text: init.family_name);
      fatherNameController = TextEditingController(text: init.father_name);
      motherNameController = TextEditingController(text: init.mother_name);
      fatherSickController = TextEditingController(text: init.father_sick);
      motherSickController = TextEditingController(text: init.mother_sick);
      family_needController = TextEditingController(text: init.family_need);
      _selectedloc = init.location;
      fatherInLife = init.fatherInLife;
      motherInLife = init.motherInLife;
      kids = init.kids;
      print("this is kids $kids");
    } else {
      print("it's null");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }

  void addKid() {
    if (_kidKey.currentState!.validate()) {
      _kidKey.currentState!.save();
      final Kids newKid = Kids(
        name: kidsNameController.text,
        age: int.parse(kidsAgeController.text),
        work: kidsWorkController.text,
        sick: kidsSickController.text,
      );
      setState(() {
        kids.add(newKid);
      });
      kidsNameController.clear();
      kidsAgeController.clear();
      kidsWorkController.clear();
      kidsSickController.clear();
    }
  }

  void editKid(int index) {
    final Kids editedKid = Kids(
      name: kidsNameController.text,
      age: int.parse(kidsAgeController.text),
      work: kidsWorkController.text,
      sick: kidsSickController.text,
    );
    setState(() {
      kids[index] = editedKid;
    });
    kidsNameController.clear();
    kidsAgeController.clear();
    kidsWorkController.clear();
    kidsSickController.clear();
  }

  void saveFamily(bool edit) {
    print("this is kids $kids");

    final Family newFamily = Family(
      life_formula_inHouse: selectLifeFormula ?? '',
      family_need: family_needController.text,
      gaz_power: selectedGazPower ?? '',
      elc_power: selectedElcPower ?? '',
      house_type: selectedHouseType ?? '',
      family_name: familyNameController.text,
      father_name: fatherNameController.text,
      mother_name: motherNameController.text,
      father_sick: fatherSickController.text,
      mother_sick: motherSickController.text,
      fatherInLife: fatherInLife,
      motherInLife: motherInLife,
      location: _selectedloc,
      kids: kids,
    );
    if (edit) {
      print("m editiing");
      newFamily.edit_family(widget.doc!.id.toString());
    } else {
      print("m adding");
      newFamily.add_family();
    }
    family_needController.clear();
    fatherNameController.clear();
    motherNameController.clear();
    fatherSickController.clear();
    motherSickController.clear();
    kidsNameController.clear();
    kidsAgeController.clear();
    kidsWorkController.clear();
    kidsSickController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة عائلة'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: familyNameController,
                decoration: InputDecoration(labelText: 'اسم العائلة '),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color.fromARGB(142, 104, 58, 183),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "الاحداثيات",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("اختر الاحداثيات"),
                              content: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      "قم بنسخ الاحداثيات و ضعها هنا",
                                      textAlign: TextAlign.center,
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          if (!await launchUrl(Uri.parse(
                                              'https://www.google.com/maps'))) {
                                            print("error");
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text("خطأ"),
                                                      content: Text(
                                                          "أعد المحاولة أو اتصل بنا"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("حسنا"))
                                                      ],
                                                    ));
                                          }
                                        },
                                        child: Text("افتح الخريطة")),
                                    TextField(
                                      decoration: InputDecoration(
                                          hintText: 'الصق الاحداثيات هنا'),
                                      controller: locationController,
                                    )
                                  ],
                                ),
                                width: 300,
                                height: 300,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedloc = locationController.text;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("حفظ"))
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.map))
                  ],
                ),
              ),
              (_selectedloc != "")
                  ? Text("الاحداثيات هي : $_selectedloc")
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: 18,
              ),
              Text(
                'الأب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: fatherNameController,
                decoration: InputDecoration(labelText: 'اسم الأب'),
              ),
              Row(
                children: [
                  Text('هل الأب على قيد الحياة'),
                  Checkbox(
                    value: fatherInLife,
                    onChanged: (value) {
                      setState(() {
                        fatherInLife = value!;
                      });
                    },
                  ),
                ],
              ),
              fatherInLife
                  ? TextField(
                      controller: fatherSickController,
                      decoration: InputDecoration(labelText: 'المرض'),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(height: 16.0),
              Text(
                'الأم',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: motherNameController,
                decoration: InputDecoration(labelText: 'اسم الأم'),
              ),
              Row(
                children: [
                  Text('هل الأم على قيد الحياة'),
                  Checkbox(
                    value: motherInLife,
                    onChanged: (value) {
                      setState(() {
                        motherInLife = value!;
                      });
                    },
                  ),
                ],
              ),
              motherInLife
                  ? TextField(
                      controller: motherSickController,
                      decoration: InputDecoration(labelText: 'المرض'),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(height: 16.0),
              TextField(
                controller: family_needController,
                decoration: InputDecoration(labelText: 'احتياجات العائلة'),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: SingleChildScrollView(
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('نوعية المنزل:'),
                          trailing: DropdownButton<String>(
                            hint: Text("اختر من هنا"),
                            value: selectedHouseType,
                            items: buildHouseTypeDropdownItems(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedHouseType = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          color: Colors.deepPurple,
                          height: 2,
                        ),
                        ListTile(
                          title: Text("الكهرباء"),
                          trailing: DropdownButton(
                              value: selectedElcPower,
                              hint: Text("اختر من هنا "),
                              items: buildElcTypeDropDownItems(),
                              onChanged: (String? newvalue) {
                                setState(() {
                                  selectedElcPower = newvalue;
                                });
                              }),
                        ),
                        Container(
                          color: Colors.deepPurple,
                          height: 2,
                        ),
                        SizedBox(height: 16.0),
                        ListTile(
                          title: Text('الغاز'),
                          trailing: DropdownButton(
                              value: selectedGazPower,
                              items: buildgazTypePowerItems(),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedGazPower = value;
                                });
                              }),
                        ),
                        Container(
                          color: Colors.deepPurple,
                          height: 2,
                        ),
                        ListTile(
                          title: Text('نوعية ملكية المنزل'),
                          trailing: DropdownButton(
                              value: selectLifeFormula,
                              items: buildLifeInHouseItem(),
                              onChanged: (String? newitem) {
                                setState(() {
                                  selectLifeFormula = newitem;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                'الأطفال',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: kids.length,
                itemBuilder: (context, index) {
                  final kid = kids[index];
                  return ListTile(
                    title: Text(kid.name),
                    subtitle: Row(
                      children: [
                        Text(
                            'العمر: ${kid.age} العمل: ${kid.work} المرض: ${kid.sick}'),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                kids.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.delete)),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            kidsNameController.text = kid.name;
                            kidsAgeController.text = kid.age.toString();
                            kidsWorkController.text = kid.work;
                            kidsSickController.text = kid.sick;

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('تعديل المعلومات'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: kidsNameController,
                                          decoration: InputDecoration(
                                              labelText: 'الاسم'),
                                        ),
                                        TextField(
                                          controller: kidsAgeController,
                                          decoration:
                                              InputDecoration(labelText: 'العمر'),
                                          keyboardType: TextInputType.number,
                                        ),
                                        TextField(
                                          controller: kidsWorkController,
                                          decoration: InputDecoration(
                                              labelText: 'دراسة/عمل'),
                                        ),
                                        TextField(
                                          controller: kidsSickController,
                                          decoration: InputDecoration(
                                              labelText: 'المرض'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('الغاء'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('حفظ'),
                                      onPressed: () {
                                        editKid(index);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'اضافة طفل ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Form(
                  key: _kidKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "field can't be null ! ";
                          }
                          return null;
                        },
                        controller: kidsNameController,
                        decoration: InputDecoration(labelText: 'الاسم'),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "field can't be null ! ";
                          }
                          return null;
                        },
                        controller: kidsAgeController,
                        decoration: InputDecoration(labelText: 'العمر'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "field can't be null ! ";
                          }
                          return null;
                        },
                        controller: kidsWorkController,
                        decoration: InputDecoration(labelText: 'العمل / الدراسة'),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "field can't be null ! ";
                          }
                          return null;
                        },
                        controller: kidsSickController,
                        decoration: InputDecoration(labelText: 'المرض'),
                      ),
                      ElevatedButton(
                        child: Text('اضافة الطفل'),
                        onPressed: addKid,
                      ),
                    ],
                  )),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text(widget.initialFamily == null
                    ? 'اضافة العائلة'
                    : 'حفظ العائلة'),
                onPressed: () {
                  if (widget.initialFamily == null) {
                    saveFamily(false);
                  } else {
                    saveFamily(true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
