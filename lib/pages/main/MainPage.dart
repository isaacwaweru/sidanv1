import 'package:dinas/models/AppState.dart';
import 'package:dinas/models/CartItem.dart';
import 'package:dinas/models/HomeService.dart';
import 'package:dinas/models/HouseService.dart';
import 'package:dinas/pages/customer/BasketPage.dart';
import 'package:dinas/redux/actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../catalogue/CatalogPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dinas/widgets/ProgressWidget.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final homeReference = Firestore.instance.collection("home_services");
final houseReference = Firestore.instance.collection("house_services");

class MainPage extends StatefulWidget {
  static String routeName = "/products";
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool houseloading;
  bool homeloading;
  List services = [];

  getHouseService() async {
    print("fetching data");
    QuerySnapshot querySnapshot = await houseReference.getDocuments();
    List<HouseService> _houseService = [];
    querySnapshot.documents.forEach((document) {
      HouseService service = HouseService.fromMap(document.data());
      service.id = document.id;
      _houseService.add(service);
      print(service.id);
    });

    final store = StoreProvider.of<AppState>(context);
    store.dispatch(House(_houseService));
    setState(() {
      houseloading = false;
    });
  }

  void initState() {
    super.initState();
    setState(() {
      houseloading = true;
      homeloading = true;
    });
  }

  _onItemTap(String id,String type,int collection) async {
    await Future.delayed(Duration(milliseconds: 80));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return new CatalogPage(id,type, collection);
        },
        fullscreenDialog: true,
      ),
    );
  }

  gestureGridCells(id, icon, title, subtitle, collection) {
    return Container(
        child: GestureDetector(
            onTap: () => _onItemTap(id, title, collection),
            child: SizedBox(
              width: 150,
              child: Card(
                elevation: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(3),
                            child: Center(
                                child: Image.network(
                                  icon,
                                  fit: BoxFit.contain,
                                )),
                          ),
                          SizedBox(width: 1,),
                          Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Text(title,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16.0))),
                                  Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Padding(
                                          padding: EdgeInsets.all(0),
                                          child: Text(
                                            subtitle,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13.0),
                                          ))),
                                ],
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  searchBar() {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 9.0, 0.0, 9.0),
        margin: EdgeInsets.only(bottom: 15),
        child: Center(
          child: TextFormField(
            decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Search For Service'),
          ),
        ));
  }

  categoryTitle(title) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(15, 10.0, 0, 7.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0)),
                Text(
                  'TOP SERVICES',
                  style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0),
                )
              ],
            )),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.96,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Container(
                            padding: EdgeInsets.only(top: 90),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Hello Kante,',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20.0)),
                                          SizedBox(width: 10,),
                                          Text('What Home',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0)),
                                        ],
                                      ),
                                      Text('Service Do You Want?',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: InkWell(
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BasketPage();
                                        },
                                        fullscreenDialog: true,
                                      ),),
                                    child: Container(
                                      width: 40,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Align(child: Icon(Icons.shopping_basket, size: 35, color: Theme.of(context).buttonColor,)),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  color: Colors.white, shape: BoxShape.circle),
                                              child: StoreConnector<AppState, Map<String,CartItem>>(
                                                  converter: (store) => store.state.orders,
                                                  builder: (context, list) {
                                                    return Text(
                                                      list.length.toString(),
                                                      style: TextStyle(

                                                          fontSize: 20, color: Colors.red),
                                                    );
                                                  }),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: 80.0,
                          child: searchBar(),
                        ),
                      ),
                          categoryTitle("Home Services"),
                          Container(
                              height: 250,
                              child: FutureBuilder<QuerySnapshot>(
                                future: homeReference.getDocuments(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final List<DocumentSnapshot> documents =
                                        snapshot.data.docs;
                                    return GridView.count(
                                      shrinkWrap: true,
                                      crossAxisSpacing: 3,
                                      mainAxisSpacing: 3,
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.75,
                                      scrollDirection: Axis.horizontal,
                                      children:
                                      List.generate(documents.length, (index) {
                                        return gestureGridCells(
                                            documents[index].id,
                                            documents[index]['icon'],
                                            documents[index]['title'],
                                            documents[index]['type'],1);
                                      }),
                                    );
                                  } else {
                                    return Container(
                                        child: Center(
                                            child: circularProgress()
                                        )
                                    );
                                  }
                                },
                              )),
                          categoryTitle("House Services"),
                          Container(
                              height: 250,
                              child: FutureBuilder<QuerySnapshot>(
                                future: houseReference.getDocuments(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final List<DocumentSnapshot> documents =
                                        snapshot.data.docs;
                                    return  GridView.count(
                                      shrinkWrap: true,
                                      crossAxisSpacing: 3,
                                      mainAxisSpacing: 3,
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.75,
                                      scrollDirection: Axis.horizontal,
                                      children:
                                      List.generate(documents.length, (index) {
                                        return gestureGridCells(
                                            documents[index].id,
                                            documents[index]['icon'],
                                            documents[index]['name'],
                                            documents[index]['type'],2);
                                      }),
                                    );
                                  }else{
                                    return Container(
                                        child: Center(
                                            child: circularProgress()
                                        )
                                    );
                                  }
                                },
                              )),
                    ])))));
  }
}
