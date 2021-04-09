import 'package:dinas/models/AppState.dart';
import 'package:dinas/models/CartItem.dart';
import 'package:dinas/pages/customer/ScheduleOrderPage.dart';
import 'package:dinas/redux/actions.dart';
import 'package:dinas/widgets/DefaultButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';

class BasketPage extends StatefulWidget{
  static String routeName = "/basket";
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage>{
  double charge = 0.0;


  @override
  void initState(){

    super.initState();


  }

  getTotal(){
    var store = StoreProvider.of<AppState>(context);
    var total = 0.0;
    store.state.orders.forEach((key, cart) => total += cart.price * cart.quantity);
    setState(() {
      charge = total;
    });
    print(total);
  }

  void clearCart(){
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(ClearCart());
  }

  void deleteItem(id){
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(RemoveOrder(id));
  }

  Dismissible catalogItem(id,title, price,icon){
    return Dismissible(
      key: Key(id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          deleteItem(id);
        });
      },
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFFFFE6E6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Spacer(),
            SvgPicture.asset("assets/icons/Trash.svg"),
          ],
        ),
      ),
      child: new Card(
          elevation: 1,
          child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.94,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [


                    Container(
                      height: 45,
                      width: 45,
                      padding: EdgeInsets.all(3),
                      child: Center(
                          child: Image.asset(
                            icon,
                            fit: BoxFit.contain,
                          )),
                    ),

                  Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 19),)
                      )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,

                    child: Padding(padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          IconButton(icon: Icon(Icons.add_circle_outline,  color: Theme.of(context).indicatorColor, size: 24,), onPressed: null),
                          // Text(price.toString(), style: TextStyle(color: Theme.of(context).backgroundColor, fontWeight: FontWeight.bold, fontSize: 15),),
                          IconButton(icon: Icon(Icons.remove_circle_outline, color: Colors.red,size: 24), onPressed: null)
                        ],
                      ),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Text(price.toString(), style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),)
                      )
                  )

                ],
              )
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    var state = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, List<CartItem>>(
      converter: (cartItemStore) => cartItemStore.state.orders.values.toList(),
      builder: (context, list) {
        return Scaffold(
            backgroundColor: Theme
                .of(context)
                .backgroundColor,
            appBar: AppBar(

              title: Text("My Basket"),
              elevation: 0.0,
              backgroundColor: Theme
                  .of(context)
                  .backgroundColor,

              actions: [
                // action button
                IconButton(
                  icon: Icon( Icons.delete, color: Colors.redAccent, size: 32, ),
                  onPressed: () { clearCart();},
                ),

              ],
            ),
            body: Container(
                    margin: EdgeInsets.only(bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: list?.length ?? 0,
                                  itemBuilder: (BuildContext context, int index) {
                                    return catalogItem(list[index].id,list[index].title,
                                        list[index].price,
                                        "assets/icons/watering-can.png");
                                  }),

                          ),


                            DefaultButton(
                                    press: () async {
                                      await Future.delayed(Duration(milliseconds: 80));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return new ScheduleOrderPage();
                                          },
                                          fullscreenDialog: true,
                                        ),
                                      );
                                    },
                                         text: "PROCEED",


                            ),
                        ],
                      ),
                ),
            );
      }
    );
  }
}
