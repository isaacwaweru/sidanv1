import 'package:dinas/SizeConfig.dart';
import 'package:dinas/models/AppState.dart';
import 'package:dinas/models/CartItem.dart';
import 'package:dinas/pages/customer/BasketPage.dart';
import 'package:dinas/widgets/DefaultTextField.dart';
import 'package:dinas/widgets/ProgressWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'CatalogPage.dart';


// query service_type
// query services for the service type
final service_type = FirebaseFirestore.instance.collection("service_type");
final service = FirebaseFirestore.instance.collection("services");

class IndexPage extends StatefulWidget{
  _IndexPageState createState() => _IndexPageState();
}


class _IndexPageState extends State{
  bool searching = false;
  bool results = false;

  headerBar(){
    return  Container(
      margin: EdgeInsets.fromLTRB(0, 50, 0, 5),
      width: SizeConfig.screenWidth * 0.92,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20.0)),
                Text('What Home Service Do You Want?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold))
              ]),
          Padding(
            padding: EdgeInsets.all(5.0),
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
      ),
    );
  }

  searchResults(documentList){
    if(results){


    return  Container(
      height: SizeConfig.screenHeight * 0.8,
      child: ListView.builder(
          itemCount: documentList.length,
          itemBuilder: (context, index){
            var results = documentList;
            return ListTile(
                title: Text("results are here")
            );
          }
      ),
    );
    }else{
      return Container(
        height: SizeConfig.screenHeight * 0.8,
        child: Center(
          child: Text("Sorry, We don't have that yet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
        )
      );
    }
  }

  searchService(String query) async{
    List<DocumentSnapshot> documentList;
    documentList = (await FirebaseFirestore.instance
                    .collection("services")
                    .where("name",isGreaterThanOrEqualTo: query)
                    .get()).docs;

    if(query.isNotEmpty){
      setState(() {
        searching = true;
      });

    }else{
      setState(() {
        searching = false;
      });

    }
    if(documentList.length > 0){
      setState(() {
        results = true;
      });
    }else{
     setState(() {
       results = false;
     });
    }

  }


  searchBar() {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 9.0, 0.0, 9.0),
        margin: EdgeInsets.only(bottom: 15),
        child: Center(
          child: DefaultTextField(
            changed: (value){
              searchService(value);
            },
            label: "Search For Service",
          ),
        ));
  }

  _onItemTap(String id,String type) async {
    await Future.delayed(Duration(milliseconds: 80));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return new CatalogPage(id,type);
        },
        fullscreenDialog: true,
      ),
    );
  }


  categoryTitle(title) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 10.0, 0, 7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22.0)),
                    Text(
                      'TOP SERVICES',
                      style: TextStyle(
                          color: Colors.white60,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0),
                    )
                  ],
                )),
          ],
        ));
  }

  gestureGridCells(id, icon, title, subtitle, collection) {
    return Container(
        child: GestureDetector(
            onTap: () => _onItemTap(id, title),
            child: Card(
              elevation: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      padding: EdgeInsets.all(3),
                      child: Center(
                          child: Image.network(
                            icon,
                            fit: BoxFit.contain,
                          )),
                    ),
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
                                        fontSize: 14.0))),
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
                ),
              ),
            )));
  }

  serviceData(title, id){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          categoryTitle(title),
          Container(
                width: SizeConfig.screenWidth,
                height: 300,
                child: FutureBuilder<QuerySnapshot>(
                  future: service.where('service_type_id',isEqualTo: id).get(),
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
                              documents[index]['name'],
                              documents[index]['service_type_id'],1);
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
                ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     backgroundColor: Theme.of(context).backgroundColor,
     body: RefreshIndicator(
       child: SingleChildScrollView(

         child: Column(
           children:[
             headerBar(),
             searchBar(),
             searching ?
                 searchResults([1,2])
                 :
             Container(
               width: SizeConfig.screenWidth * 0.92,
                child: FutureBuilder(
                    future: service_type.get(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          final List<DocumentSnapshot> documents = snapshot.data.docs;
                          return Column(
                            children:  List.generate(documents.length, (index) =>
                                serviceData(documents[index]['name'], documents[index].id)
                              ),
                          );
                        }else{
                          return Container(
                              child: Center(
                                  child: circularProgress()
                              )
                          );
                        }
                      }
                  )

           ),
    ]
         ),
       ),
       onRefresh: (){
         return Future.delayed(Duration(seconds: 2),
             (){
               setState(() {

               });
             }
         );
       },
     )
   );
  }
}