import 'package:flutter/material.dart';
import 'package:kafil/ui/Family_page.dart';

class families_emp extends StatelessWidget {
  const families_emp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: FamilyPage(brief_info_family: false)),
    );
  }
}