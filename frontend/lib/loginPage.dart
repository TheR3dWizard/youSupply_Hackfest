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
                  ),
            )),
        Column(
          children: [
            LabelledTextField.readable(
              label: "Username",
              controller: usernameController,
            ),
            LabelledTextField.hidden(
              label: "Password",
              controller: passwordController,
            ),
          ],
        ),
        ToggleSwitch(
          minWidth: 175,
          minHeight: 50,
              initialLabelIndex: 0,
              totalSwitches: 2,
              labels: const ['Client','Delivery Agent'],
              activeBgColor: const [Colors.blueAccent],
              inactiveBgColor: Colors.grey,
              onToggle: (index) {
                if (index == 0) {
                  typeNotifier.value = "Client";
                } else {
                  typeNotifier.value = "Delivery Agent";
                }
              },
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
      ],
    )));
  }

  void authenticateUser(BuildContext context, TextEditingController username,
      TextEditingController password) {
    //TODO authentication

  }
}