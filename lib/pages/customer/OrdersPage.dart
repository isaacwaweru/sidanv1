import 'package:dinas/pages/orders/OrderDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dinas/widgets/ProgressWidget.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final ordersReference = Firestore.instance.collection("orders");


class OrdersPage extends StatefulWidget {
  static String routeName = "/orders";
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  viewOrderDetails(orderId){
    Navigator.push(
        context,
        MaterialPageRoute(
              builder: (context){
                return OrderDetails(orderId);
              },
          fullscreenDialog: true
        )
    );
  }


  allOrders() {
    return FutureBuilder<QuerySnapshot>(
        future: ordersReference.where('customer',isEqualTo:auth.currentUser.uid).get(),
      builder: (context, snapshot){
          if(snapshot.hasData){
              final List<DocumentSnapshot> documents = snapshot.data.docs;
              if(documents.length > 0) {
                return new ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return orderCard(documents[index].id, documents[index]["house_no"], documents[index]['paid'], documents[index]['location']);
                    });
              }else{
                return Container(
                  child: Center(
                    child: Text('You havent made any orders')
                  )
                );
              }

          }else{
            return Container(
                child: Center(
                    child: circularProgress()
        ));
          }
      },

    );
  }

  orderCard(String orderId, totalPrice, paid, location) {
    return GestureDetector(
      onTap:() {viewOrderDetails(orderId);},
      child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Card(
            elevation: 0.5,
            child: Padding(padding: EdgeInsets.all(9), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(1),
                        child: Text("Order Id #$orderId",
                          style: TextStyle(color: Theme.of(context).buttonColor, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Click To View Order Details", style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold),)
                          ),
                        ],
                      )
                    ),
                    paid == true ?
                    Container(
                      child: Center(
                        child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 24,)
                      ),
                    ):
                        Container(
                          child: Center(
                            child: Icon(Icons.check_circle, color: Theme.of(context).buttonColor, size: 25)
                          )
                        )
                  ],
                ),
                paid == true ?
                  Padding(
                      padding: EdgeInsets.all(1),
                      child: Chip(
                        label: Text("Paid"),
                        backgroundColor: Colors.greenAccent,
                      )):

                  Padding(
                      padding: EdgeInsets.all(1),
                      child: Chip(
                        label: Text("Awaiting Payment"),
                        backgroundColor: Theme.of(context).buttonColor,
                      ))

              ],
            ),
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("My Orders"),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
        ),
        body: Center(child:Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child:  Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(6, 10.0, 0, 10.0),
              child: Text("I have been served", style: TextStyle(color: Colors.white70),)
            ),
            Expanded(
                child: allOrders()

            ),
          ],
        )))));
  }
}
