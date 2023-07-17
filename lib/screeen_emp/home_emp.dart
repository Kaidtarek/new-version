import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kafil/screeen_emp/Actions_items.dart';
import 'package:kafil/screeen_emp/Stock_emp.dart';
import 'package:kafil/screeen_emp/camping_emp.dart';
import 'package:kafil/screeen_emp/families.dart';
import 'package:kafil/screeen_emp/members.dart';

class welcom_emp extends StatefulWidget {
  @override
  _welcom_empState createState() => _welcom_empState();
}

class _welcom_empState extends State<welcom_emp> {
  int selectedpage = 0;
  final _pageNo = [
    families_emp(),
    action_items(),
    members_emp(),
    camping_emp(),
    Stock_emp(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(""),
        ),
        body: _pageNo[selectedpage],
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.family_restroom, title: 'العائلات'),
            TabItem(icon: Icons.volunteer_activism_rounded, title: 'نشاطات'),
            TabItem(icon: Icons.group, title: 'الأعضاء'),
            TabItem(icon: Icons.forest, title: 'التخييمات'),
            TabItem(icon: Icons.store, title: 'المخزن'),
          ],
          initialActiveIndex: selectedpage,
          onTap: (int index) {
            setState(() {
              selectedpage = index;
            });
          },
        ),
      ),
    );
  }
}
