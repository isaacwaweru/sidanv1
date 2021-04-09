import 'package:dinas/pages/HomePage.dart';
import 'package:dinas/routes.dart';
import 'package:flutter/material.dart';
import 'package:dinas/redux/reducers.dart';
import 'package:dinas/redux/actions.dart';
import 'package:dinas/models/AppState.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _initialState = AppState(orders: {});
  final Store<AppState> _store =
  Store<AppState>(reducer, initialState:_initialState);
  await Firebase.initializeApp();
  runApp(MyApp(store: _store));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Store<AppState> store;



  MyApp({this.store});


  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        
        title: 'Dinas App',
        theme: ThemeData(
          backgroundColor: Color(0xFF0061e2),
          buttonColor: Color(0xFFffa451),
          indicatorColor: Color(0xFFffc501),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: HomePage.routeName,
        routes: routes,
      ),
    );
  }
}

