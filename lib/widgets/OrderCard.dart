import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget{
  OrderCard();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
              elevation: 0.5,
              child: Padding(padding: EdgeInsets.all(9), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(1),
                          child: Text(
                            "Order Id",
                            style: TextStyle(color: Theme.of(context).buttonColor),
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
                                  child: Text("Wash Clothes (Hand Wash)", style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold),)
                              ),
                              Container(
                                  child: Text("Trousers(3), T-Shirts(8)", style: TextStyle(color: Colors.black87),)
                              ),
                              Container(
                                  child: Text("@Ngara Desai Road Total Door 51", style: TextStyle(color:Colors.black45),)
                              )
                            ],
                          )
                      ),
                      Container(
                        child: Center(
                            child: Icon(Icons.check_circle, color: Theme.of(context).buttonColor, size: 24,)
                        ),
                      )
                    ],
                  ),


                  Padding(
                      padding: EdgeInsets.all(1),
                      child: Chip(
                        label: Text("Awaiting Payment"),
                        backgroundColor: Theme.of(context).buttonColor,
                      ))
                ],
              ),
              ));
    }
  }