import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CatalogueCard extends StatelessWidget{
  final String orderId;
  final String total;
  final String unitPrice;
  final String scheduledTIme;
  final String houseNo;
  final String location;
  final bool paid;
  final Function pressed;

  CatalogueCard({
    this.orderId,
    this.total,
    this.unitPrice,
    this.scheduledTIme,
    this.houseNo,
    this.location,
    this.paid,
    this.pressed
  });


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                            "",
                            fit: BoxFit.contain,
                          )),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Text(orderId, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 19),)
                      )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.32,

                    child: Padding(padding: EdgeInsets.all(0),
                      child: Row(
                        children: [
                          IconButton(icon: Icon(Icons.add_circle_outline,  color: Theme.of(context).indicatorColor, size: 24,), onPressed: pressed),
                          Text(total.toString(), style: TextStyle(color: Theme.of(context).backgroundColor, fontWeight: FontWeight.bold, fontSize: 13),),
                          IconButton(icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).indicatorColor,size: 24), onPressed: pressed)
                        ],
                      ),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Text("K $total", style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),)
                      )
                  )

                ],
              )
          )
      );
    }
  }