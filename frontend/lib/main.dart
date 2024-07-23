import 'package:flutter/material.dart';
import 'package:frontend/delAgents/accepted.dart';
import 'package:frontend/delAgents/available.dart';
import 'package:frontend/delAgents/claimed.dart';
import 'package:frontend/delAgents/completed.dart';
import 'package:frontend/delAgents/homePageDel.dart';
import 'loginPage.dart';
import 'signUpPage.dart';
import 'generalUsers/providePage.dart';
import 'generalUsers/requestPage.dart';
import 'package:frontend/generalUsers/homePageGU.dart';
import 'package:frontend/generalUsers/cartPage.dart';

import 'delAgents/history.dart';
import 'settings.dart';
import 'profile.dart';
import 'utilities.dart';
//import 'frontend/lib/delAgents/available.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  bool loggedIn = false;

  MyApp.initState() {
    isLoggedIn().then((value) {
      loggedIn = value;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/cart': (context) => Cartpage(),
        '/login': (context) => LoginPage(),
        '/signupGU': (context) => SignUpPageGU(),
        '/homegu': (context) => homePageGU(),
        '/homedel': (context) => homePageDel(),
        '/provide': (context) => providePage(),
        '/request': (context) => requestPage(),
        'history': (context) => history(),
        '/settings': (context) => settings(),
        '/profile': (context) => profile(),
        '/accepted': (context) => accepted(),
        '/available': (context) => available(),
        '/claimed': (context) => claimed(),
        '/completed': (context) => completed(),
        '/cart': (context) => Cartpage(),
      },
      title: 'youSupply',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: () {
        if (loggedIn) {
          return homePageGU();
        } else {
          return LoginPage();
        }
      }(),
    );
  }
}
