import 'package:flutter/material.dart';

import 'ProgressWidget.dart';class Dialogshow {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.transparent,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        circularProgress(),
                        SizedBox(height: 15,),
                        Text("Please Wait....",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25))
                      ]),
                    )
                  ]));
        });
  }
}