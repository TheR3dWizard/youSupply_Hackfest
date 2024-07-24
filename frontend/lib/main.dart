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
    return MaterialApp(
      initialRoute: loggedIn ? '/homegu' : '/login',
      onGenerateRoute: (settings) {
        if (settings.name == '/claimed') {
          final pathIndex = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => ClaimedRoutes(pathIndex: pathIndex),
          );
        } else if (settings.name == '/mapview') {
          final pathIndex = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => MapView(pathIndex: pathIndex),
          );
        }
        return null; // Let `routes` handle the rest
      },
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/homegu': (context) => homePageGU(),
        '/homedel': (context) => homePageDel(),
        '/provide': (context) => providePage(),
        '/request': (context) => requestPage(),
        '/history': (context) => history(),
        '/settings': (context) => settings(),
        '/profile': (context) => profile(),
        '/accepted': (context) => accepted(),
        '/available': (context) => Available(),
        '/cartstatic': (context) => cartPageStatic(),
        '/completed': (context) => completed(),
        '/cart': (context) => cartPage(),
      },
      title: 'youSupply',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
