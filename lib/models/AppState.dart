
import 'package:dinas/models/CartItem.dart';

class AppState{

  Map<String, CartItem> orders = {};
  bool loggedIn = false;
  var cart = [];
  var form1 = {};
  var form2 = {};
  var homeservices = [];
  var houseservices = [];
  var total = 0;
  var customer = {};

  AppState(
  {this.loggedIn,this.form1, this.form2, this.orders, this.total, this.customer});

  AppState.fromAppState(AppState another){
    loggedIn = another.loggedIn;
    form1 = another.form1;
    form2 = another.form2;
    orders = another.orders;
    total = another.total;
    customer = another.customer;
  }
}