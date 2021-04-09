import 'package:dinas/models/AppState.dart';
import 'package:dinas/models/CartItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';
import 'OrderStatusPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinas/models/AppState.dart';
import 'package:dinas/redux/reducers.dart';
import 'package:firebase_auth/firebase_auth.dart';


FirebaseAuth auth = FirebaseAuth.instance;


final ordersReference = Firestore.instance.collection("orders");

class ScheduleOrderPage extends StatefulWidget {
  static String routeName = "/schedule";
  _ScheduleOrderPageState createState() => _ScheduleOrderPageState();
}

class _ScheduleOrderPageState extends State<ScheduleOrderPage> {

  DateTime _selectedDate = DateTime.now();
  TextEditingController _textEditingController = TextEditingController();
  String dropdownValue = '00:00';
  String location;
  String house_no;
  String details;
  String phoneNumber;
  double startPoint;
  double endPoint;
  bool locationSet = false;
  final _phoneNumberController = TextEditingController();
  TextEditingController _houseNumberController = TextEditingController();


  GlobalKey firstkey = GlobalKey();
  GlobalKey secondkey = GlobalKey();

  @override
  void initState(){
    super.initState();
    // this.getOffsets();

  }


  String validatePhoneNumber(String value){
    if(!(value.length > 9) && value.isNotEmpty){
      return 'Incorrect Format For Phone number';
    }
    return null;
  }

  String validateHouseNumber(String value){
    if(value.isEmpty){
      return 'House Number Cannot Be Empty';
    }
    return null;
  }

  submitOrders() async {
    final store = StoreProvider.of<AppState>(context);
    Map<String,CartItem> orders = store.state.orders;
    List ordersmade = List();
    orders.forEach((key, value) {
      double total = value.price * value.quantity;
      ordersmade.add({
        "id":value.id,
        "title":value.title,
        "quantity":value.quantity,
        "total":  total,
        "price_unit": value.price
      });
    });


    if(ordersmade.isEmpty){
      return null;
    }
    ordersReference.add({
      'location': location,
      'house_no': house_no,
      'customer': auth.currentUser.uid,
      'details': details,
      'contacts': phoneNumber,
      'time':dropdownValue,
      'scheduled_date': _selectedDate,
      'orders': ordersmade,
      'order_taken':false,
      'order_being_delivered':false,
      'order_complete':false,
      'paid': false,
    })
        .then((value) async {
      await Future.delayed(
          Duration(milliseconds: 120));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return OrderStatusPage();
          },
        ),
      );
    })
        .catchError((error) => print(error));
  }

  timeDropDown() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 20,
      elevation: 0,
      style: TextStyle(color: Colors.blueAccent),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['00:00','02:00','04:00']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Theme.of(context).backgroundColor,
                onPrimary: Colors.white,
                surface: Theme.of(context).backgroundColor,
                onSurface: Theme.of(context).buttonColor,

              ),
              dialogBackgroundColor:Colors.white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _textEditingController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _textEditingController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  getUserCurrentLocation() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: "AIzaSyBH4FrgjqOR68RHVS6hfHVet7XpQrhWwcc",   // Put YOUR OWN KEY here.
          onPlacePicked: (result) {
            print(result.name);
            setState((){
              location = result.name;
              locationSet = true;
            });
            Navigator.of(context).pop();
          },
          initialPosition: LatLng(-33.8567844, 151.213108),
          useCurrentLocation: true,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Schedule Your Order"),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 13),
                            child: CustomPaint(
                              painter: ShapePainter(startPoint, endPoint),
                              child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              Container(
                                key: firstkey,
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).buttonColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Text(
                                  "1",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                              ),
                              Container(
                                key: secondkey,
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Text(
                                  "2",
                                  style: TextStyle(
                                      color: Theme.of(context).buttonColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                              ),
                          ],
                        ),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.99,
                            child: Card(
                                child: Padding(
                              padding: EdgeInsets.all(11.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child:
                                        Text("Add Address and Contact Details", style: TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.w800),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child:   Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          locationSet ?
                                          Text(location, style: TextStyle(color: Theme.of(context).backgroundColor, fontWeight: FontWeight.bold, fontSize: 25)) :
                                          Text("Location ...", style: TextStyle(color: Theme.of(context).backgroundColor, fontWeight: FontWeight.bold, fontSize: 25)),
                                          FlatButton(
                                              onPressed: getUserCurrentLocation,
                                              child: Icon(Icons.location_on_outlined, color: Theme.of(context).buttonColor, size: 30,)
                                          )
                                        ]
                                    )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: TextFormField(
                                      onChanged: (newValue){
                                        setState(() {
                                          house_no = newValue;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'HOUSE NO',
                                          border: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.black))),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.99,
                            child: Card(
                                child: Padding(
                              padding: EdgeInsets.all(11.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Text("Schedule Date And Time",style: TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.w800)),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: TextFormField(
                                                onTap: () {
                                                  _selectDate(context);
                                                },
                                                controller:
                                                    _textEditingController,
                                                decoration: InputDecoration(
                                                  border:
                                                      new UnderlineInputBorder(
                                                          borderSide:
                                                              new BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                  hintText: 'Date',
                                                ),
                                              )),
                                          timeDropDown()
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                        child: TextFormField(
                                          onChanged: (newValue){
                                            setState(() {
                                              details = newValue;
                                            });
                                          },
                                          minLines: 2,
                                          maxLines: 5,
                                      decoration: InputDecoration(
                                          border: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.black)),
                                          hintText:
                                              'Extra Details/Land Mark (Optional)'),
                                    )),
                                  ),
                                ],
                              ),
                            ))),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.99,
                            child: Card(
                                child: Padding(
                              padding: EdgeInsets.all(11.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Text("Contact Details",style: TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.w800)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: TextFormField(
                                      controller: _phoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      onChanged: (newValue){
                                        setState(() {
                                          phoneNumber = newValue;
                                        });
                                      },
                                      minLines: 2,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        errorText: validatePhoneNumber(_phoneNumberController.text),
                                          border: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.black)),
                                          hintText: 'PHONE NUMBER'),

                                    ),
                                  ),
                                ],
                              ),
                            ))),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.99,
                      margin: EdgeInsets.only(top:6),
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: ButtonTheme(
                            child: RaisedButton(
                                onPressed: () async {
                                 submitOrders();
                                },
                                color: Theme.of(context).buttonColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Confirm Order",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                    )
                                  ],
                                ))),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void getOffsets() {
      RenderBox box = firstkey.currentContext.findRenderObject();
      Offset position = box.localToGlobal(Offset.zero); //this is global position
      double y = position.dy;

      RenderBox box2 = secondkey.currentContext.findRenderObject();
      Offset position2 = box2.localToGlobal(Offset.zero); //this is global position
      double y2 = position2.dy;

      setState(() {
        startPoint = y;
        endPoint = y2;
      });
    }
}

class ShapePainter extends CustomPainter{
  double y;
  double y2;
  ShapePainter(this.y, this.y2);


  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint()
        ..color = Color(0xFFffa451)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;

    Offset startingPoint = Offset(0, size.width/2);
    Offset endingPoint = Offset(size.width, size.width/2);
    
    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return false;
  }
}
