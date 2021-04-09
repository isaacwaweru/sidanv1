import 'package:dinas/pages/HomePage.dart';
import 'package:dinas/pages/main/MainPage.dart';
import 'package:dinas/widgets/ProgressWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final ordersReference = Firestore.instance.collection("orders");

class ProfilePage extends StatefulWidget {
  static String routeName = "/agentprofile";

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String first_name;
  String face;
  List services;

  DocumentReference user =
      Firestore.instance.collection("agents").doc(auth.currentUser.uid);

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void showSnackbar(String message) {
    _scaffoldkey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).buttonColor,
            content: Text(message, style: TextStyle(color: Colors.white, fontSize: 18),)
        )
    );
  }

  getUser() async {
    Firestore.instance
        .collection("agents")
        .doc(auth.currentUser.uid)
        .get()
        .then((snapshot) => {
              setState(() {
                face = snapshot.get("face_photo");
                first_name = snapshot.get("first_name");
                services = snapshot.get("services");
              })
            });
  }

  void initState() {
    super.initState();
    getUser();
  }

  logout() async {
    auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userType');
    Navigator.pushReplacementNamed(context, HomePage.routeName);
  }

  acceptOrder(docId) async {
    // take order
    ordersReference.doc(docId).update({
      "assigned_to_user": auth.currentUser.uid
    }).then((value) => {
      print("done")
    });
    showSnackbar("Task has been assigned to you");
    print("_________________________________________");
    print(docId);
    print("_________________________________________");
  }

  profile() {
    this.getUser();
    return Container(
        margin: EdgeInsets.fromLTRB(10, 15, 0, 10),
        child: Row(children: [
          face != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(face),
                  radius: 50,
                )
              : CircleAvatar(
                  backgroundColor: Colors.lightBlueAccent,
                  child: Text(
                    'SD',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  radius: 50,
                ),
          Padding(
            padding: EdgeInsets.all(0),
            child: Container(
                margin: EdgeInsets.fromLTRB(15.0, 0, 0, 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello $first_name',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 27),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text('available'),
                            backgroundColor: Colors.greenAccent,
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          FlatButton(
                              color: Colors.redAccent,
                              onPressed: () {
                                logout();
                              },
                              child: Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              ))
                        ])
                  ],
                )),
          )
        ]));
  }

  servicesOffered() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
      child: Row(
        children: [
          services != null
              ? Padding(
                  padding: EdgeInsets.all(2),
                  // margin: EdgeInsets.all(2),
                  child: Chip(
                    label: Text(services[0]),
                    backgroundColor: Colors.white,
                    labelStyle:
                        TextStyle(color: Theme.of(context).backgroundColor),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(2),
                  child: Chip(
                      label: Text("No Services Found"),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.redAccent)),
                )
        ],
      ),
    );
  }

  statistics() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
              padding: EdgeInsets.all(4),
              child: Column(children: [
                Text(
                  'SERVED',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Text('20',
                    style: TextStyle(
                        color: Theme.of(context).buttonColor, fontSize: 22)),
              ])),
          Padding(
              padding: EdgeInsets.all(4),
              child: Column(children: [
                Text(
                  'RATINGS',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.supervisor_account_sharp,
                      color: Colors.white,
                    ),
                    Text('5/5',
                        style: TextStyle(
                            color: Theme.of(context).buttonColor,
                            fontSize: 22)),
                  ],
                )
              ])),
          Padding(
              padding: EdgeInsets.all(4),
              child: Column(children: [
                Text(
                  'Amount',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Text('20,000',
                    style: TextStyle(
                        color: Theme.of(context).buttonColor, fontSize: 22)),
              ]))
        ],
      ),
    );
  }

  userNotifications() {
    return FutureBuilder<QuerySnapshot>(
        future: ordersReference.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            if (documents.length > 0) {
              return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                        child: Card(
                            elevation: 1,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                    child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Text(documents[index].id,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .buttonColor,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Chip(
                                              label: Text('Pending'),
                                              backgroundColor: Colors.green,
                                            ))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 4),
                                                child: Text(
                                                  'Wash Clothes',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                            Text('Nairobi Ngara Area house 51'),
                                            Text('Tommorrow at 3:00pm'),
                                            Text(
                                                'Please come with your own scrubber'),
                                          ],
                                        )),
                                        Container(
                                            child: Column(
                                          children: [
                                            Text('****'),
                                            Text("££££")
                                          ],
                                        ))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ButtonTheme(
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: RaisedButton(
                                                onPressed: () {acceptOrder(documents[index].id);},
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "TAP TO ACCEPT TASK",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ))),
                                        ButtonTheme(
                                            minWidth: 50,
                                            child: RaisedButton(
                                                onPressed: () {},
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    side: BorderSide(
                                                        color: Colors.red)),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "CANCEL",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ],
                                                ))),
                                      ],
                                    )
                                  ],
                                )))));
                  });
            } else {
              return Container(child: Center(child: Text('No New Job Posts')));
            }
          }
        });
  }

  completedServices() {
    return FutureBuilder<QuerySnapshot>(
      future: ordersReference
          .where("assigned_to_user", isEqualTo: auth.currentUser.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data.docs;
          if (documents.length > 0) {
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: documents.length,
                itemBuilder: (BuildContext, int index) {
                  return Container(
                      child: Card(
                          elevation: 1,
                          child: Container(
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Text(
                                                "ORDER NO #35678",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .buttonColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Chip(
                                                label:
                                                    Text('Process Completed'),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .buttonColor,
                                              ))
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Wash Clothes',
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                  'Nairobi Ngara Area house 51'),
                                              Text('Tommorrow at 3:00pm'),
                                              Text(
                                                  'Please come with your own scrubber'),
                                            ],
                                          )),
                                          Container(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text("18 items"),
                                              Text(" Ksh 1700")
                                            ],
                                          ))
                                        ],
                                      ),
                                      Divider(
                                        color:
                                            Theme.of(context).backgroundColor,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(top: 2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Task Completed',
                                                style: TextStyle(
                                                    color: Colors.blueAccent)),
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )))));
                });
          } else {
            return Container(
                child: Center(child: Text("You haven't completed any job")));
          }
        } else {
          return Container(child: Center(child: circularProgress()));
        }
      },
    );
  }

  userTabs() {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              color: Theme.of(context).backgroundColor,
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(
                      tabs: [
                        new Text("Notifications"),
                        new Text("Complete Services")
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Expanded(child: userNotifications()),
              ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return completedServices();
                  })
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                children: [
                  profile(),
                  servicesOffered(),
                  statistics(),
                  Divider(
                    color: Theme.of(context).buttonColor,
                    thickness: 2,
                  ),
                  Container(height: 400, child: userTabs())
                ],
              ))),
    );
  }
}
