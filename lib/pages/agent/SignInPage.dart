import 'package:dinas/pages/agentotp/OTPVerifyPage.dart';
import 'package:dinas/pages/agent/ProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

final usersReference = Firestore.instance.collection("users");
FirebaseAuth auth = FirebaseAuth.instance;

class SigninPage extends StatefulWidget {
  static String routeName = "/agentsignin";
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  String phoneNumber;


  attemptAuth() async{

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      // phoneNumber: '+254719546525',
      timeout: Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ProfilePage()
        ));
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int resendToken) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPVerifyPage(verificationId: verificationId,signIn: true,)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        print(verificationId);
        print("Timed out");
      },
    );
  }

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
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Center(
                          child: Image.asset(
                            'assets/icons/icon.png',
                            scale: 1,
                          )),
                    ),

                    Container(
                        child: Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'KE',
                            onChanged: (phone) {
                              setState(() {
                                phoneNumber = phone.completeNumber;
                              });

                            },
                          )
                        )),

                  ],
                ),
              ),


              Container(
                height: 50,
                child: ButtonTheme(
                  minWidth: 300.0,
                  child: RaisedButton(
                      onPressed: ()=> attemptAuth(),
                      color: Theme.of(context).buttonColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SIGN IN",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          )
                        ],
                      )))),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
