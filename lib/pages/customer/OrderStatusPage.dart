import 'package:dinas/pages/main/MainPage.dart';
import 'package:dinas/pages/customer/OrdersPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderStatusPage extends StatefulWidget{
  static String routeName = "/orderstatus";
  _OrderStatusPage createState() => _OrderStatusPage();
}

class _OrderStatusPage extends State<OrderStatusPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Order Status"),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).buttonColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(child:Text("1", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)),
                    ),


                    Container(
                      width: 30,
                      height:30,
                      decoration: BoxDecoration(
                          color: Theme.of(context).buttonColor,
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Center(child:Text("2", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)),

                    ),
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.only(top:24),
                child: Row(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/ordertaken.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 18),
                        child: Text('Order Taken', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ],

                ),
              ),
              Container(
                margin: EdgeInsets.only(top:20),
                child: Row(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Center(
                        child:
                            Image.asset(
                              'assets/icons/orderdelivery.png',
                              fit: BoxFit.contain,
                            ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 18),
                      child: Text('Order is Being Delivered', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),

                  ],

                ),
              ),

              Container(
                margin: EdgeInsets.only(top:20),
                child: Row(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/orderdone.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 18),
                      child: Text('Order is Complete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ],

                ),
              ),
              Container(
                  margin: EdgeInsets.only(top:20),
                child: Card(

                  child: Container(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(

                          child: Text("Payment Details", textAlign: TextAlign.start,style: TextStyle(color: Colors.black, fontSize: 23),)
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("House Services", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                                  ),
                                  Container(
                                    child: Text("Trousers(3), T-Shirts(8)", style: TextStyle(color:Colors.black45),)
                                  )
                                ],
                              ),
                              Container(
                                child: Text("K 1700", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text("Rating")
                              ),
                              Container(
                                child: Text("5/5")
                              )
                            ],
                          )
                        ),
                       ButtonTheme(
                            buttonColor: Colors.greenAccent,
                              minWidth: MediaQuery.of(context).size.width * 0.8,
                              child: RaisedButton(
                                color: Color(0xFF4cd964),
                                  onPressed: (){},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Make Payment",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      Text(
                                        "K 1,700",
                                        style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                              )
                       ),


                      ],
                    ),
                  )
                )
              ) ,
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15)
                ),
                margin: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 0.0),
                child: new InkWell(
                  child: new Card(
                    child: new SizedBox(
                      height: 50.0,
                      width:MediaQuery.of(context).size.width,
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await Future.delayed(Duration(milliseconds: 100));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return OrdersPage();
                                      },
                                    ),
                                  );
                                },
                                child:Center(child:Padding(
                                  padding: EdgeInsets.all(2.9),
                                  child: Center(
                                    child:new Text(
                                      "Go To Orders",
                                      style: new TextStyle(color: Colors.black, fontSize:24),
                                    ),
                                  ),
                                )
                                ),
                              )),
                          new Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await Future.delayed(Duration(milliseconds: 100));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MainPage();
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                    ),
                                    child:Center(
                                      child:new Text(
                                        "Go To Home",
                                        style: new TextStyle(color: Colors.white, fontSize:24),
                                      ),
                                    )
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),//Payment Card,


            ],
          ),
        ),
      ),
    );
  }
}