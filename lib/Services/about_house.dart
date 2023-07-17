import 'package:flutter/material.dart';

final List<String> houseTypes = ['عمارة', 'سكن عادي'];
final List<String> elc_types = ["يملك الطاقة الكهربائية", "لايملك الطاقة الكهربائية"];
final List<String> gaz_power = ["قارورة غاز","يملك الطاقة الغازية"];
final List<String> life_formula =['عقد كراء' ,'ملكية خاصة','مستفيد مجانا' ,'لا يملك'];
String? selectLifeFormula;
String? selectedElcPower;
String? selectedHouseType;
String? selectedGazPower;

List<DropdownMenuItem<String>> buildHouseTypeDropdownItems() {
  return houseTypes.map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
}

List<DropdownMenuItem<String>> buildElcTypeDropDownItems(){
  return elc_types.map((String value) {
    return DropdownMenuItem<String>(
      child: Text(value),
      value: value,);
  }).toList();
}

List<DropdownMenuItem<String>> buildgazTypePowerItems(){
  return gaz_power.map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value)
      );
  }).toList();
}

List<DropdownMenuItem<String>> buildLifeInHouseItem(){
  return life_formula.map((String value) {
    return DropdownMenuItem(child: Text(value),value: value,);
  }).toList();
}