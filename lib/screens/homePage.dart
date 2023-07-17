import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kafil/ui/stock.dart';
import 'package:kafil/ui/camping.dart';
import 'package:kafil/ui/Family_page.dart';
import 'package:kafil/ui/employee.dart';
import 'package:kafil/ui/items.dart';
import 'package:kafil/widget/stockwithSearch.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedpage = 0;
  final _pageNo = [
    FamilyPage(brief_info_family: true,),
    MyItems(),
    ProfilePage(just_see: true,),
    Camp(just_see: true,),
    My_stock(just_see: true)
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('صفحة المرقبة و التعديل'),
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
