import 'package:dinas/widgets/StepTwoForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../agentotp/OTPVerifyPage.dart';

class AgentSignUpStepTwo extends StatefulWidget {
  static String routeName = "/agentsignuptwo";
  _AgentSignUpStateTwoState createState() => _AgentSignUpStateTwoState();
}

class _AgentSignUpStateTwoState extends State<AgentSignUpStepTwo> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Center(

          child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Container(
                  padding: EdgeInsets.fromLTRB(0,20, 0, 15),
                  child: Text("Sign Up To Sidan", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 23),)
                ),
                Container(child: StepTwoForm()),
              ]
            )
          ),
        ),
      )
    );
  }
}
