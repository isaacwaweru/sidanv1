
import 'package:dinas/models/AppState.dart';
import 'package:dinas/models/CartItem.dart';
import 'package:dinas/redux/actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/customer/ScheduleOrderPage.dart';

FirebaseAuth auth = FirebaseAuth.instance;


class CatalogPage extends StatefulWidget{
  String id;
  String type;
  int collection;
  static String routeName = "/catalogue";
  CatalogPage(this.id, this.type);
  _CatalogPageState createState() => _CatalogPageState(this.id, this.type);
}

class _CatalogPageState extends State<CatalogPage>{
  int total = 0;
  double totalPrice = 0;
  double charge = 0;
  String id;
  String type;
  int collection;

  String collectionName;


  var currentSelection = {};


  _CatalogPageState(this.id, this.type);

  @override
  void initState(){

    super.initState();

  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  getTotal(){
    var store = StoreProvider.of<AppState>(context);
    var total = 0.0;
    store.state.orders.forEach((key, cart) => total += cart.price * cart.quantity);
    setState(() {
      charge = total;
    });
  }

  getQuatityOfItem(id){
    var store = StoreProvider.of<AppState>(context);
    if(store.state.orders.containsKey(id)){
      print("_____________________________");
      print(store.state.orders[id]);

      return store.state.orders[id].quantity.toString();
    }
    else{
      return total.toString();
    }
  }

  addItemToOrders(title, price,id){
    var store = StoreProvider.of<AppState>(context);
    price = double.parse(price);
    CartItem item = CartItem(title:title, price:price, id:id);
    store.dispatch(AddOrder(item));
    getTotal();
  }

  removeItemFromOrders(id){
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(RemoveOrder(id));
    getTotal();
  }
  
  removeSingleItem(id){
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(RemoveSingleOrder(id));
    getTotal();
  }

  Card catalogItem(id, title, price, icon){
    return new Card(
      elevation: 1,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.94,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(

              width: MediaQuery.of(context).size.width * 0.1,
              child:Container(
                height: 45,
                width: 45,
                padding: EdgeInsets.all(3),
                child: Center(
                    child: Image.network(
                      icon,
                      fit: BoxFit.contain,
                    )),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
                child: Padding(
              padding: EdgeInsets.all(1.0),
              child: Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 19),)
            )
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.32,

              child: Padding(padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.add_circle_outline,  color: Theme.of(context).indicatorColor, size: 24,), onPressed: (){addItemToOrders(title, price, id);}),
                    Text(getQuatityOfItem(id), style: TextStyle(color: Theme.of(context).backgroundColor, fontWeight: FontWeight.bold, fontSize: 13),),
                    IconButton(icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).indicatorColor,size: 24), onPressed: (){removeSingleItem(id);})
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Text("K $price", style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),)
              )
            )

          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<AppState>(context);

    return  Scaffold(
      appBar: AppBar(
        title: Text(type, style: TextStyle(fontWeight: FontWeight.w800,fontSize: 25),),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        margin: EdgeInsets.only(top:15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<QuerySnapshot>(

                future: Firestore.instance.collection("items").where("service_id", isEqualTo: id).get(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    final List<DocumentSnapshot> documents =
                        // ignore: missing_return, missing_return
                        snapshot.data.docs;
                    return ListView.builder(
                        itemCount: documents.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index){
                          return catalogItem(
                              documents[index].id,
                              documents[index]['name'],
                              documents[index]['price'],
                              documents[index]['icon'] );
                        });
                  }else{
                    return Container(
                        child: Center(
                            child: Text('No Services Available')));
                  }
                }),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
          ),
                margin: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
                child: new InkWell(
                  child: new Card(
                    child: new SizedBox(
                      height: 56.0,
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Expanded(
                            child: Center(child:Padding(
                              padding: EdgeInsets.all(2.9),
                              child: Column(
                                children: [
                                  Text("Total"),
                                  Text("K $charge", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
                                ],
                              )
                            ),
                          )),
                          new Expanded(
                            child: InkWell(
                              onTap: () async {
                                await Future.delayed(Duration(milliseconds: 100));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return new ScheduleOrderPage();
                                    },
                                  ),
                                );
                              },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).buttonColor,
                                ),
                            child:Center(
                              child:new Text(
                              "PROCEED",
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
              ),
          ],
        ),
      ),
    );

  }

}