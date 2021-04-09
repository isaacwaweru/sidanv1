import 'package:dinas/pages/HomePage.dart';
import 'package:dinas/pages/agent/AgentSignUpStepOne.dart';
import 'package:dinas/pages/agent/AgentSignUpStepTwo.dart';
import 'package:dinas/pages/agentotp/OTPVerifyPage.dart';
import 'package:dinas/pages/agent/ProfilePage.dart';
import 'package:dinas/pages/agent/SignInPage.dart';
import 'package:dinas/pages/customer/BasketPage.dart';
import 'package:dinas/catalogue/CatalogPage.dart';
import 'package:dinas/pages/customerotp/CustomerOTPVerifyPage.dart';
import 'package:dinas/pages/customer/CustomerProfliePage.dart';
import 'package:dinas/pages/customersignup/CustomerSignUpPage.dart';
import 'package:dinas/pages/main/MainPage.dart';
import 'package:dinas/pages/customer/OrderStatusPage.dart';
import 'package:dinas/pages/customer/OrdersPage.dart';
import 'package:dinas/pages/customer/ScheduleOrderPage.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  // agent routes
  SigninPage.routeName: (context) => SigninPage(),
  AgentSignUpStepOne.routeName: (context) => AgentSignUpStepOne(),
  AgentSignUpStepTwo.routeName: (context) => AgentSignUpStepTwo(),
  OTPVerifyPage.routeName: (context) => OTPVerifyPage(),
  ProfilePage.routeName: (context) => ProfilePage(),
  // end of agent routes

  // customer routes
  BasketPage.routeName: (context) => BasketPage(),
  CustomerOTPVerifyPage.routeName: (context) => CustomerOTPVerifyPage(),
  CustomerProfilePage.routeName: (context) => CustomerProfilePage(),
  CustomerSignUpPage.routeName: (context) => CustomerSignUpPage(),
  MainPage.routeName: (context) => MainPage(),
  OrdersPage.routeName: (context) => OrdersPage(),
  OrderStatusPage.routeName: (context) => OrderStatusPage(),
  ScheduleOrderPage.routeName: (context) => ScheduleOrderPage(),
  HomePage.routeName: (context) => HomePage()
};