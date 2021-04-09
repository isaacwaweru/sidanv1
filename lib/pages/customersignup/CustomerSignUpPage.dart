import 'package:dinas/pages/customersignup/components/CustomerSignUp.dart';
import 'package:dinas/widgets/StepTwoForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomerSignUpPage extends StatefulWidget {
  static String routeName = "/customersignup";
  _CustomerSignUpPageState createState() => _CustomerSignUpPageState();
}

class _CustomerSignUpPageState extends State<CustomerSignUpPage> {
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
                height: MediaQuery.of(context).size.height * 0.89,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children:[
                      Container(
                          padding: EdgeInsets.fromLTRB(0,20, 0, 15),
                          child: Text("Sign Up To Sidan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 23),)
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.77,
                          child: CustomerSignUp()),
                    ]
                )
            ),
          ),
        )
    );
  }
}
