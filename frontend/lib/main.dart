import 'package:flutter/material.dart';
import 'package:frontend/delAgents.dart/homePageDel.dart';
import 'loginPage.dart';
import 'signUpPage.dart';
import 'generalUsers.dart/homePageGU.dart';

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
        '/homegu': (context) =>  homePageGU(),
        '/homedel':(context) =>  homePageDel(),
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

