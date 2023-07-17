import 'package:flutter/material.dart';
class see_info extends StatelessWidget {
  see_info({required this.itemName, required this.calledName});
  Text calledName;
  String itemName;

  @override
  Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double fontSize = screenWidth * 0.04; 

  return Row(
    children: [
      Text(
        '$itemName :',
        style: TextStyle(fontSize: fontSize),
      ),
      Expanded(
        child: Text(
          calledName.data.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: fontSize,
          ),
        ),
      ),
    ],
  );
}

}
