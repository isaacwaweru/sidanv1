import 'package:dinas/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SecondaryButton extends StatelessWidget{

  const SecondaryButton({
    Key key,
    this.text,
    this.press
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
        width: double.infinity,
        height: getProportionateScreenHeight(56.0),
        child: RaisedButton(
            onPressed: press,
            color: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(
                  width: 1.5,
                    color: Theme.of(context).buttonColor)),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                      color: Theme.of(context).buttonColor),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                )
              ],
            ))
    );
  }
}