import 'package:flutter/material.dart';
import 'package:frontend/newdelAgent/MapView.dart';
import 'package:frontend/delAgents/accepted.dart';
import 'package:frontend/newdelAgent/accepted.dart';
import 'package:frontend/newdelAgent/available.dart';
import 'package:frontend/newdelAgent/homePageDel.dart';
import 'package:frontend/generalUsers/homePageGU.dart';
import 'package:frontend/generalUsers/cartPageStatic.dart';
import 'package:frontend/generalUsers/providePage.dart';
import 'package:frontend/generalUsers/requestPage.dart';
import 'package:frontend/generalUsers/cartPage.dart';
import 'package:frontend/delAgents/history.dart';
import 'package:frontend/settings.dart';
import 'package:frontend/profile.dart';
import 'package:frontend/utilities/apiFunctions.dart';
import 'package:frontend/utilities.dart';
import 'loginPage.dart';
import 'signUpPage.dart';
import 'package:frontend/newdelAgent/completed_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      debugShowCheckedModeBanner: false,
      initialRoute: loggedIn ? '/homegu' : '/login',
      // onGenerateRoute: (settings) {
      //   if (settings.name == '/claimed') {
      //     final pathIndex = settings.arguments as int;
      //     return MaterialPageRoute(
      //       builder: (context) => ClaimedRoutes(pathIndex: pathIndex),
      //     );
      //   } else if (settings.name == '/mapview') {
      //     final pathIndex = settings.arguments as int;
      //     return MaterialPageRoute(
      //       builder: (context) => MapView(pathIndex: pathIndex),
      //     );
      //   }
      //   return null; // Let `routes` handle the rest
      // },
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/homegu': (context) => const homePageGU(),
        '/homedel': (context) => homePageDel(),
        '/provide': (context) => providePage(),
        '/request': (context) => requestPage(),
        '/history': (context) => const history(),
        '/settings': (context) => const settings(),
        '/profile': (context) => const profile(),
        '/accepted': (context) => accepted(),
        '/available': (context) => const Available(),
        '/cartstatic': (context) => const cartPage(),
        '/cart': (context) => const cartPage(),
        // '/completed_routes': (context) => const CompletedRoutes(),
      },
      title: 'youSupply',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
