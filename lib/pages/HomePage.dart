//view memes here
import 'package:dinas/index/IndexPage.dart';
import 'package:dinas/models/message.dart';
import 'package:dinas/pages/agent/AgentSignUpStepOne.dart';
import 'package:dinas/pages/agentotp/OTPVerifyPage.dart';
import 'package:dinas/pages/agent/ProfilePage.dart';
import 'package:dinas/pages/agent/SignInPage.dart';
import 'package:dinas/pages/customersignup/CustomerSignUpPage.dart';
import 'package:dinas/pages/customer/ScheduleOrderPage.dart';
import 'package:dinas/pages/customersignup/components/CustomerSignUp.dart';
import 'package:dinas/pages/main/MainPage.dart';
import 'package:dinas/widgets/SecondaryButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customer/OrdersPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dinas/models/HomeService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dinas/widgets/SnackWidget.dart';
import 'package:dinas/widgets/DefaultButton.dart';
import 'package:dinas/SizeConfig.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
FirebaseAuth auth = FirebaseAuth.instance;

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

class HomePage extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  PageController controller = PageController();
  int getPageIndex = 0;
  bool checkIn = false;
  String userType;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        successSnackBar('You have a new message');
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        successSnackBar("You have a new message");
      },
      onResume: (Map<String, dynamic> message) async {
        successSnackBar("You have new message");
      },
    );
    checkAuth();
    getUserType();
  }

  getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString('userType');
    });
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  checkAuth() async {
    if (auth.currentUser != null) {
      setState(() {
        checkIn = true;
      });
    } else {
      setState(() {
        checkIn = false;
      });
    }
  }

  onTapChangePage(int pageIndex) {
    controller.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          IndexPage()
          // MainPage()
          // ,ProfilePage(),
          ,OrdersPage()],
        controller: controller,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: getPageIndex,
        elevation: 0.0,
        onTap: onTapChangePage,
        backgroundColor: Theme.of(context).backgroundColor,
        // activeColor: Colors.white,
        // inactiveColor: Colors.white70,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              )),
          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Icons.person_outline_sharp,
          //       color: Colors.white,
          //       size: 40,
          //     ),
          //     title: Text(
          //       "Profile",
          //       style: TextStyle(color: Colors.white),
          //     )),

          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_outlined, color: Colors.white),
              title: Text(
                "Orders",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }

  Scaffold buildSignUpScreen() {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.94,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Column(
                          children: [
                            Container(
                              child: Center(
                                  child: Image.asset(
                                'assets/icons/icon.png',
                                scale: 1,
                              )),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                                padding: EdgeInsets.all(7.0),
                                child: Text(
                                  "Sidan App",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22.0),
                                )),
                            Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                                child: Text(
                                  "Kenya's best home service app",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                )),
                            SizedBox(height: 30,),
                          ],
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Container(
                          height: 50,
                          margin: EdgeInsets.only(top: 15),
                          child: DefaultButton(
                            text: "SIGN IN",
                            press: () async {
                              await Future.delayed(Duration(milliseconds: 80));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return new SigninPage();
                                  },
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                          )
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 15),
                        child: DefaultButton(
                          text: "SIGN UP",
                          press: () async {
                            await Future.delayed(Duration(milliseconds: 80));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return new CustomerSignUpPage();
                                },
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        )
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 15),
                        child: SecondaryButton(
                          text: "REQUEST FOR SERVICES",
                          press: () async {
                            await Future.delayed(Duration(milliseconds: 80));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return new MainPage();
                                },
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FlatButton(
                                  onPressed: () async {
                                    await Future.delayed(
                                        Duration(milliseconds: 80));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return new AgentSignUpStepOne();
                                        },
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Apply to work with us.',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15.0),
                                  ),
                                )
                              ])),
                    )
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (checkIn) {
      if(userType == "customer"){
        return buildHomeScreen();
      }else{
        return ProfilePage();
      }
    } else {
      return buildSignUpScreen();
    }
  }
}
