import 'package:dinas/SizeConfig.dart';
import 'package:flutter/material.dart';

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  fillColor: Colors.white,
  filled: true,
  enabledBorder: outlineInputBorder()
);

OutlineInputBorder outlineInputBorder(){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(1)),
    borderSide: BorderSide(color: Colors.white)
  );
}