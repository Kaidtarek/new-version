import 'package:flutter/material.dart';
import 'package:kafil/ui/camping.dart';

class camping_emp extends StatelessWidget {
  const camping_emp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Camp(just_see: false,)),
    );
  }
}