import 'package:flutter/material.dart';
import 'package:frontend/delAgents/MapView.dart';
import 'package:frontend/delAgents/accepted.dart';
import 'package:frontend/delAgents/available.dart';
import 'package:frontend/delAgents/claimed.dart';
import 'package:frontend/delAgents/completed.dart';
import 'package:frontend/delAgents/homePageDel.dart';
import 'package:frontend/generalUsers/homePageGU.dart';
import 'package:frontend/generalUsers/cartPageStatic.dart';
import 'package:frontend/generalUsers/providePage.dart';
import 'package:frontend/generalUsers/requestPage.dart';
import 'package:frontend/generalUsers/cartPage.dart';
import 'package:frontend/delAgents/history.dart';
import 'package:frontend/settings.dart';
import 'package:frontend/profile.dart';
import 'package:frontend/utilities.dart';
import 'loginPage.dart';
import 'signUpPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    isLoggedIn().then((value) {
      setState(() {
        loggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deliveryDetailsList = [
      DeliveryDetails(
          fromLoc: '123 Main St, Springfield', distanceFromDelAgent: 4.5),
      DeliveryDetails(
          fromLoc: '456 Elm St, Shelbyville', distanceFromDelAgent: 3.2),
      DeliveryDetails(
          fromLoc: '789 Oak St, Capital City', distanceFromDelAgent: 5.8),
      DeliveryDetails(
          fromLoc: '321 Pine St, Springfield', distanceFromDelAgent: 2.5),
      DeliveryDetails(
          fromLoc: '654 Maple St, Shelbyville', distanceFromDelAgent: 6.1),
      DeliveryDetails(
          fromLoc: '987 Cedar St, Capital City', distanceFromDelAgent: 1.7),
      DeliveryDetails(
          fromLoc: '135 Birch St, Springfield', distanceFromDelAgent: 4.9),
      DeliveryDetails(
          fromLoc: '246 Walnut St, Shelbyville', distanceFromDelAgent: 3.3),
      DeliveryDetails(
          fromLoc: '357 Ash St, Capital City', distanceFromDelAgent: 5.2),
      DeliveryDetails(
          fromLoc: '468 Beech St, Springfield', distanceFromDelAgent: 2.8),
    ];

    return MaterialApp(
      initialRoute: loggedIn ? '/homegu' : '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signupGU': (context) => SignUpPageGU(),
        '/homegu': (context) => homePageGU(),
        '/homedel': (context) => homePageDel(),
        '/provide': (context) => providePage(),
        '/request': (context) => requestPage(),
        '/history': (context) => history(),
        '/settings': (context) => settings(),
        '/profile': (context) => profile(),
        '/accepted': (context) => accepted(),
        '/available': (context) =>
            Available(deliveryDetailsList: deliveryDetailsList),
        '/claimed': (context) => claimed(),
        '/cartstatic': (context) => cartPageStatic(),
        '/completed': (context) => completed(),
        '/cart': (context) => Cartpage(),
        '/mapview': (context) => MapView(
              toLocations: [],
              resourcesToCollect: [],
            ),
      },
      title: 'youSupply',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
