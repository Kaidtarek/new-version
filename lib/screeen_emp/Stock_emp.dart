import 'package:flutter/material.dart';

import '../ui/stock.dart';

class Stock_emp extends StatelessWidget {
  const Stock_emp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: My_stock(just_see : false)),
    );
  }
}