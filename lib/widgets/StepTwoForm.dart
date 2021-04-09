import 'dart:io';
import 'package:dinas/pages/agentotp/OTPVerifyPage.dart';
import 'package:dinas/pages/agent/ProfilePage.dart';
import 'package:dinas/pages/main/MainPage.dart';
import 'package:dinas/redux/actions.dart';
import 'package:dinas/widgets/DefaultTextField.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:dinas/models/AppState.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'DefaultButton.dart';
import 'Dialog.dart';



final usersReference = Firestore.instance.collection("users");
FirebaseAuth auth = FirebaseAuth.instance;

class Languages {
  final int id;
  final String name;

  Languages({
    this.id,
    this.name,
  });
}

class StepTwoForm extends StatefulWidget {
  _StepTwoFormState createState() => _StepTwoFormState();
}

class _StepTwoFormState extends State<StepTwoForm> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _stepOneKey = GlobalKey<FormState>();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File face;
  File ID;
  String ID_NO;
  String phoneNumber;
  String languages;

  // select box
  static List<Languages> _animals = [
    Languages(id: 1, name: "Kiswahili"),
    Languages(id: 2, name: "English"),
    Languages(id: 3, name: "French"),
    Languages(id: 4, name: "German"),
  ];
  final _items = _animals
      .map((animal) => MultiSelectItem<Languages>(animal, animal.name))
      .toList();
  List<Languages> _selectedAnimals = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();
  // end of selectbox variables

  phoneNumberFormat(){
    String suffix = '+254';
  }

  attemptAuth() async{
    _indicate(context);
  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    timeout: Duration(seconds: 120),
    verificationCompleted: (PhoneAuthCredential credential) {
      submitForm();
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => ProfilePage()
      ));
      storeUserDetails();
      _saveDeviceToken();
      saveUserType();

    },
    verificationFailed: (FirebaseAuthException e) {
      print(e);
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
    },
    codeSent: (String verificationId, int resendToken) {
      submitForm();
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPVerifyPage(verificationId: verificationId,signIn: false,)));
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      verificationId = verificationId;
      print("Code AutoRetrieval Timed out");
    },
    );

  }

  void saveUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userType', "agent");
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

  Future<void> _indicate(BuildContext context) async {
    try {      Dialogshow.showLoadingDialog(context, _keyLoader);//invoking login
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
    } catch (error) {
      print(error);
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
  }

  submitForm() async {

    final DateTime now = DateTime.now();
    final int millSeconds = now.millisecondsSinceEpoch;
    final String month = now.month.toString();
    final String date = now.day.toString();
    final String storageId = (millSeconds.toString());
    final String today = ('$month-$date');
    final photo = 'faces/' + today + '/' + storageId;
    final Id = 'IDs/' + today + '/' + storageId;
    firebase_storage.UploadTask task =
        firebase_storage.FirebaseStorage.instance.ref(photo).putFile(face);
    firebase_storage.TaskSnapshot snapshot = await task;
    firebase_storage.UploadTask idtask =
        firebase_storage.FirebaseStorage.instance.ref(Id).putFile(ID);
    firebase_storage.TaskSnapshot snapshot_id = await task;

    String downloadUrl = await snapshot_id.ref.getDownloadURL();
    String id_downloadUrl = await snapshot_id.ref.getDownloadURL();

    if(downloadUrl != null && id_downloadUrl != null){
      var data = {
        'ID_NO': ID_NO,
        'phoneNumber': phoneNumber,
        'languages': _selectedAnimals.map((e) => e.name).toList(),
        'face_photo': downloadUrl,
        'id_photo': id_downloadUrl
      };

      final store = StoreProvider.of<AppState>(context);
      store.dispatch(FormTwo(data));
    }
    return null;
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);

    setState(() {
      this.face = imageFile;
    });
  }

  captureIDithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);

    setState(() {
      this.ID = imageFile;
    });
  }

  pickImageFromGallery() async {

    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 680, maxWidth: 970);
    setState(() {
      this.face = imageFile;
    });
  }

  pickIdFromGallery() async {

    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 680, maxWidth: 970);
    setState(() {
      this.ID = imageFile;
    });
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload Face Photo",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.blue,
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Capture Image With Camera",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Select Face Photo From Gallery",
                    style: TextStyle(color: Colors.white)),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  takeId(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload Identity Card",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.blue,
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Capture ID With Camera",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Select ID Photo From Gallery",
                    style: TextStyle(color: Colors.white)),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    _selectedAnimals = _animals;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _stepOneKey,
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    onPressed: () {
                      pickImageFromGallery();
                    },
                    child: Text(
                      'Upload Face Photo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                      child: face != null
                          ? Center(
                              child: Container(
                                height: 100,
                                width: 100,
                                margin: EdgeInsets.all(4),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(

                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                        image: DecorationImage(
                                            image: FileImage(face),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 50,
                              ),
                            )),
                ],
              )),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    onPressed: () {
                      pickIdFromGallery();
                    },
                    child: Text(
                      'Upload ID Card',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                      child: ID != null
                          ? Center(
                              child: Container(
                                margin: EdgeInsets.all(4),
                                height: 90,
                                width: 100,
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlueAccent,
                                        image: DecorationImage(
                                            image: FileImage(ID),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              child: Icon(
                                Icons.crop_square,
                                color: Colors.white,
                                size: 50,
                              ),
                            )),
                ],
              )),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: DefaultTextField(
                      changed: (newValue) {
                        setState(() {
                          ID_NO = newValue;
                        });
                      },
                      label: "I.D Number",
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: MultiSelectChipField(
                  scroll: false,
                  items: _items,
                  title: Text("Languages You Speak", style: TextStyle(color: Colors.white),),
                  headerColor: Theme.of(context).backgroundColor,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.8),
                  ),
                  selectedChipColor: Theme.of(context).buttonColor,
                  selectedTextStyle: TextStyle(color: Theme.of(context).backgroundColor, fontWeight: FontWeight.bold),
                  onTap: (values) {
                    _selectedAnimals = values;
                  },
                ),
              ),
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

                   DefaultButton(
                        press: () {
                          attemptAuth();
                        },
                        text:"Sign UP"

              )
            ],
          );
        },
      ),
    );
  }
}
