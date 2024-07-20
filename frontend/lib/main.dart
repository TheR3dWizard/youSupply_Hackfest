import 'package:flutter/material.dart';
import 'package:frontend/delAgents/accepted.dart';
import 'package:frontend/delAgents/available.dart';
import 'package:frontend/delAgents/homePageDel.dart';
import 'loginPage.dart';
import 'signUpPage.dart';
import 'generalUsers/providePage.dart';
import 'generalUsers/requestPage.dart';
import 'package:frontend/generalUsers/homePageGU.dart';
import 'delAgents/history.dart';
import 'settings.dart';
import 'profile.dart';
//import 'frontend/lib/delAgents/available.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signupGU': (context) => SignUpPageGU(),
        '/homegu': (context) => homePageGU(),
        '/homedel': (context) => homePageDel(),
        '/provide': (context) => providePage(),
        '/request': (context) => requestPage(),
        'history' : (context) => history(),
        '/settings': (context) => settings(),
        '/profile': (context) => profile(),
        '/accepted': (context) => accepted(),
       '/available':(context)=> available()

      },
      title: 'youSupply',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
