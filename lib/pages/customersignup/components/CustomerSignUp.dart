import 'package:dinas/SizeConfig.dart';
import 'package:dinas/models/AppState.dart';
import 'package:dinas/pages/agent/AgentSignUpStepTwo.dart';
import 'package:dinas/pages/customerotp/CustomerOTPVerifyPage.dart';
import 'package:dinas/redux/actions.dart';
import 'package:dinas/widgets/DefaultButton.dart';
import 'package:dinas/widgets/DefaultTextField.dart';
import 'package:dinas/widgets/Dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main/MainPage.dart';

final usersReference = Firestore.instance.collection("users");
FirebaseAuth auth = FirebaseAuth.instance;

class CustomerSignUp extends StatefulWidget {
  _CustomerSignUpState createState() => _CustomerSignUpState();
}

class _CustomerSignUpState extends State<CustomerSignUp> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _stepOneKey = GlobalKey<FormState>();

  String first_name;
  String phone_number;
  String email;


  Future<void> _indicate(BuildContext context) async {
    try {      Dialogshow.showLoadingDialog(context, _keyLoader);//invoking login
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
    } catch (error) {
      print(error);
    }
  }

  attemptAuth() async{
    // Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerOTPVerifyPage(verificationId: '',)));
    _indicate(context);
    await auth.verifyPhoneNumber(
      phoneNumber: phone_number,
      // phoneNumber: '+254719546525',
      timeout: Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) {
        FormOneSubmit();
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => MainPage()
        ));
        storeUserDetails();
        saveUserType();
        _saveDeviceToken();
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      },
      codeSent: (String verificationId, int resendToken) {
        FormOneSubmit();
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerOTPVerifyPage(verificationId: verificationId,)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
        verificationId = verificationId;
      },
    );
  }

  void saveUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userType', "customer");
  }

  _saveDeviceToken() async {
    String userId = auth.currentUser.uid;

    String token = await _firebaseMessaging.getToken();

    if (token != null) {
      var tokens = usersReference
          .document(userId)
          .collection('tokens')
          .document(token);

      await tokens.setData({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(), // optional
      });
    }
  }

  storeUserDetails(){
    final store = StoreProvider.of<AppState>(context);

    var customer = store.state.customer;


    print(customer);


    usersReference.doc(auth.currentUser.uid).set({
      'name': customer['first_name'],
      'phone_number': customer['phone_number'],
      'email': customer['email'],
      'registration_date': DateTime.now().toString(),
      'userid': auth.currentUser.uid,
      'username': auth.currentUser.displayName,

    })
        .then((value) => print("Posted"))
        .catchError((error) => print("Failed to post"));
  }


  FormOneSubmit() {
    var data  = {
      'first_name': first_name,
      'phone_number': phone_number,
      'email': email,
    };
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(Customer(data));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Form(
          key: _stepOneKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.25,),
                  Container(
                      margin: EdgeInsets.only(bottom: 35),
                      child: Center(
                        child: DefaultTextField(
                          keyboard: TextInputType.name,
                          changed: (newValue) {
                            setState(() {
                              first_name = newValue;
                            });
                          },
                            label: "Full Name"
                        ),

                      )),


                  Container(
                      margin: EdgeInsets.only(bottom: 35),
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
                                phone_number = phone.completeNumber;
                              });

                            },
                          )
                      )),


                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: DefaultTextField(
                          keyboard: TextInputType.emailAddress,
                            changed: (newValue) {
                            setState(() {
                              email = newValue;
                            });
                          },
                          label: "Email addrress",
                        ),
                      )),
                ],
              ),

              DefaultButton(
                        text: "Continue",
                        press:  (){attemptAuth();},

                    )
            ],
          ),
        );
      },
    );
  }
}
