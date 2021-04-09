import 'package:dinas/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget{
  final Function changed;
  final String label;
  final TextInputType keyboard;

  DefaultTextField({
    Key key,
    this.changed,
    this.label,
    this.keyboard
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: SizeConfig.screenWidth * 0.9,
      height: getProportionateScreenHeight(56),
      child:  TextFormField(
        keyboardType: keyboard,
        onChanged: changed,
        decoration: InputDecoration(
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(5.0),
              ),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            labelText: label,
          labelStyle: TextStyle(fontSize: 20),
          isDense: true,
          contentPadding: EdgeInsets.all(20.0),
        ),
      ),
    );
  }

}