import 'package:flutter/material.dart';
import 'utilities.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<String> typeNotifier = ValueNotifier<String>("Client");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        body: Center(

            
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Text(
              "YouSupply",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
        Column(
          children: [
            LabelledTextField.readable(
              label: "Username",
              controller: usernameController,
            ),
            PasswordField(
              label1: "Password",
              controller: passwordController,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ToggleSwitch(
            activeFgColor: Colors.white,
            inactiveFgColor: Colors.white,
            borderColor: [Colors.black45],
          
            borderWidth: 1.5,
            minWidth: 140,
            minHeight: 50,
            initialLabelIndex: 0,
            totalSwitches: 2,
            labels: const ['Client', 'Delivery Agent'],
            activeBgColor: const [Colors.blueAccent],
            inactiveBgColor: Colors.grey[850],
            onToggle: (index) {
              if (index == 0) {
                typeNotifier.value = "Client";
              } else {
                typeNotifier.value = "Delivery Agent";
              }
            },
          ),
        ),
        OutlinedButton(
          onPressed: () {
            authenticateUser(context, usernameController, passwordController);
          },
          style: OutlinedButton.styleFrom(
            shadowColor: Colors.black,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
          ),
          child: const Text('Login'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical:1.0),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signupGU');
            },
            child: const Text('Sign Up',

            style: TextStyle(decoration: TextDecoration.underline,
           color: Colors.blue,
            decorationColor: Colors.blue),
                ),
          ),
        ),
      ],
    )));
  }

  void authenticateUser(BuildContext context, TextEditingController username,
      TextEditingController password) {
    //TODO authentication
  }
}


// Background theme
// Sign up underline
