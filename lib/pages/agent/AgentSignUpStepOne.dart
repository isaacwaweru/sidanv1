import 'package:dinas/models/AppState.dart';
import 'package:dinas/widgets/StepOneForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'AgentSignUpStepTwo.dart';

class AgentSignUpStepOne extends StatefulWidget {
  static String routeName = "/agentsignup";
  _AgentSignUpStepOneState createState() => _AgentSignUpStepOneState();
}

class _AgentSignUpStepOneState extends State<AgentSignUpStepOne> {
  heading() {
    return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                child:Padding(
                    padding: EdgeInsets.all(0),
                    child: Text("Become a Sidan Agent", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white70, fontSize: 23),)
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                child: Padding(padding: EdgeInsets.all(0),
                    child: Icon(Icons.person_pin_outlined, size: 40,color: Colors.white, )
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child:Padding(padding: EdgeInsets.all(0),
                    child: Text("Step 1/2",textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),)
                )
              ),
              Container(child: StepOneForm()),
            ],
          )),

        ],
      ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: StoreConnector<AppState, AppState>(
        converter: (store)=>store.state,
        builder: (context, state){
          return SingleChildScrollView(
              child: Center(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width * 0.96,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            heading(),
                          ]))));
        },
      ),
    );
  }
}
