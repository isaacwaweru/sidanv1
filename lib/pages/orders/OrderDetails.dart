import 'package:dinas/widgets/ProgressWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final ordersReference = Firestore.instance.collection("orders");

class OrderDetails extends StatefulWidget{
  String orderId;
  OrderDetails(this.orderId);
  _OrderDetailState createState() => _OrderDetailState(this.orderId);
}

class _OrderDetailState extends State{
  String orderId;
  dynamic order;

  _OrderDetailState(this.orderId);

  @override
  void initState(){
    super.initState();
    print(this.orderId);
  }

  fetchOrder(){
    return FutureBuilder<DocumentSnapshot>(
      future: ordersReference.doc(this.orderId).get(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          order = snapshot.data.data();
          print("*****************************");
          print(order['house_no']);
          print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
          return Padding(
              padding: EdgeInsets.all(1.0),
              child: orderCard(order));
        }else{
          return Container(
              child: Center(
                  child: circularProgress()
              ));
        }
      },

    );
  }


  orderCard(order){
    String house_no = order['house_no'];
    String location = order['location'];
    String time = order['time'];
    String date = order['scheduled_date'].toDate().toString();
    List items = order['orders'];
    return Container(
      padding: EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text("House Number $house_no", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),)
              ),
              Container(
                child: Text('Location $location', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20))
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    Container(
                      child: Text('Order Catalogue', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, position) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [ Text(items[position]['title'], style: TextStyle(fontSize: 22.0),), Text(items[position]['price_unit'].toString())]),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ),
              Container(
                  child: Text('Date: $date', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Theme.of(context).backgroundColor))
              ),
              Container(
                  child: Text('Time: $time', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Theme.of(context).buttonColor))
              ),
            ],
          ),
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
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text("Order Details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: fetchOrder()

        )
      ),
    );
  }
}