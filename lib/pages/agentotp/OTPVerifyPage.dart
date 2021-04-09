import 'package:dinas/constants.dart';
import 'package:dinas/models/AppState.dart';
import 'package:dinas/pages/HomePage.dart';
import 'package:dinas/pages/agent/ProfilePage.dart';
import 'package:dinas/pages/main/MainPage.dart';
import 'package:dinas/widgets/DefaultButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;

final usersReference = Firestore.instance.collection("agents");

class OTPVerifyPage extends StatefulWidget{
  String verificationId;
  bool signIn;
  static String routeName = "/agentotp";


  OTPVerifyPage({Key key, this.verificationId, this.signIn}) : super(key : key);

  @override
  _OTPVerifyPageState createState() => _OTPVerifyPageState(verificationId, signIn);
}
class _OTPVerifyPageState extends State<OTPVerifyPage>{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;
  FocusNode pin7FocusNode;

  String verificationId;
  bool signIn;
  String one;
  String two;
  String three;
  String four;
  String five;
  String six;
  String code;

  @override
  void initState(){
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    pin7FocusNode = FocusNode();
  }

  void saveUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userType', "agent");
  }


  @override
  void dispose(){
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
    pin7FocusNode.dispose();
  }

  _OTPVerifyPageState(this.verificationId, this.signIn);
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void nextField(String value, FocusNode focusNode){
    if(value.length == 1 ){
      focusNode.requestFocus();
    }
  }

  void showSnackbar(String message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  signInWithPhoneNumber() async {
    code = one.trim() + two.trim() + three.trim() + four.trim() + five.trim() + six.trim();
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      final User user = (await auth.signInWithCredential(credential)).user;

      showSnackbar("Successfully signed in UID: ${user.uid}");

        storeUserDetails();
        _saveDeviceToken();
        await Future.delayed(Duration(milliseconds: 150));
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return ProfilePage();
        //     },
        //   ),
        // );
      Navigator.pushReplacementNamed(context, ProfilePage.routeName);

    } catch (e) {
      print(e);
      showSnackbar("Failed to sign in: " + e.toString());
    }
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

    var form1 = store.state.form1;
    var form2 = store.state.form2;

    usersReference.doc(auth.currentUser.uid)
        .set({
      'email':form1['email'],
      'first_name':form1['first_name'],
      'last_name':form1['last_name'],
      'face_photo':form2['face_photo'],
      'id_photo':form2['id_photo'],
      'id_number':form2['ID_NO'],
      'languages':form2['languages'],
      'services':form1['services'],
      'location':form1['location'],
      'registration_date': DateTime.now().toString(),
      'userid': auth.currentUser.uid,
      'username': auth.currentUser.displayName,
      'phone_number': form2['phoneNumber'],
      'active':true,
      'available':true
    })

        .then((value) => print("Posted"))
        .catchError((error) => print(error));
    saveUserType();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body:   Center(child:Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Text("Verify your phone details", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),)
                ),

                Container(
                  margin: EdgeInsets.only(top:10),
                    child: Text("A message has been sent to phone number ending with (*233)", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 24),)
                ),

                Container(
                  margin: EdgeInsets.only(top:30),
                  child: Container(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                    width: 50,
                                    padding: EdgeInsets.all(4.0),
                                    child:TextFormField(
                                      autofocus: true,
                                      obscureText: true,
                                      style: TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (newValue){
                                        nextField(newValue, pin2FocusNode);
                                        setState(() {
                                          one = newValue;
                                        });
                                      },
                                      decoration: otpInputDecoration,
                                    )
                                ),
                                Container(
                                    width: 50,
                                    padding: EdgeInsets.all(4.0),
                                    child:TextFormField(
                                      obscureText: true,
                                      focusNode: pin2FocusNode,
                                      style: TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (newValue){
                                        nextField(newValue, pin3FocusNode);
                                        setState(() {
                                          two = newValue;
                                        });
                                      },
                                      decoration: otpInputDecoration,
                                    )
                                ),
                                Container(
                                    width: 50,
                                    padding: EdgeInsets.all(4.0),
                                    child:TextFormField(
                                      obscureText: true,
                                      focusNode: pin3FocusNode,
                                      style: TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (newValue){
                                        nextField(newValue, pin4FocusNode);
                                        setState(() {
                                          three = newValue;
                                        });
                                      },
                                      decoration: otpInputDecoration,
                                    )
                                ),

                                Container(
                                    width: 50,
                                    padding: EdgeInsets.all(4.0),
                                    child:TextFormField(
                                      obscureText: true,
                                      focusNode: pin4FocusNode,
                                      style: TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (newValue){
                                        nextField(newValue, pin5FocusNode);
                                        setState(() {
                                          four = newValue;
                                        });
                                      },
                                      decoration:  otpInputDecoration,
                                    )
                                ),
                                Container(
                                    width: 50,
                                    padding: EdgeInsets.all(4.0),
                                    child:TextFormField(
                                      obscureText: true,
                                      focusNode: pin5FocusNode,
                                      style: TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (newValue){
                                        nextField(newValue, pin6FocusNode);
                                        setState(() {
                                          five = newValue;
                                        });
                                      },
                                      decoration: otpInputDecoration,
                                    )
                                ),
                                Container(
                                    width: 50,
                                    padding: EdgeInsets.all(4.0),
                                    child:TextFormField(
                                      obscureText: true,
                                      focusNode: pin6FocusNode,
                                      style: TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (newValue){
                                        pin6FocusNode.unfocus();
                                        setState(() {
                                          six = newValue;
                                        });
                                      },
                                      decoration:otpInputDecoration,
                                    )
                                ),


                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ),

              ],
            ),









              DefaultButton(
                      press: (){
                        signInWithPhoneNumber();
                      },
                     text: "Submit",
              ),

            SizedBox(
              height: MediaQuery.of(context).size.width * 0.2,
            )

          ],
        ),
      ),
      )
    );
  }
}