import 'package:flutter/material.dart';

errorSnackBar(String message){
  return SnackBar(content: Text(message, style: TextStyle(color: Colors.redAccent),), backgroundColor: Colors.white,);
}

successSnackBar(String message){
  return SnackBar(content: Text(message, style: TextStyle(color: Colors.black87)), backgroundColor: Colors.white,);
}