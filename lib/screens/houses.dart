import 'package:flutter/material.dart';
import 'package:kafil/widget/basics_fam_info.dart';
class houses extends StatelessWidget {
  bool get=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: GetFamilies(Check_box: false,),),
    );
  }
}