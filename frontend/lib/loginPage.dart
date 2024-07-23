import 'package:flutter/material.dart';
import 'utilities.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final ValueNotifier<String> usernameNotifier = ValueNotifier<String>("");
  // final ValueNotifier<String> passwordNotifier = ValueNotifier<String>("");
  final ValueNotifier<String> typeNotifier = ValueNotifier<String>("Client");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ),
            Column(
              children: [
                LabelledTextField.readable(
                  label: "Username",
                  controller: usernameController,
                ),
                // PasswordField(
                //   label1: "Password",
                //   controller: passwordController,
                // ),
                LabelledTextField.readable(
                  label: "Password",
                  controller: passwordController,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder<String>(
                valueListenable: typeNotifier,
                builder: (context, value, child) {
                  return ToggleSwitch(
                    customTextStyles: [
                      TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                    ],
                    activeFgColor: Colors.black,
                    inactiveFgColor: Colors.black,
                    borderColor: [Colors.black45],
                    borderWidth: 1.5,
                    minWidth: 140,
                    minHeight: 50,
                    initialLabelIndex: value == "Client" ? 0 : 1,
                    totalSwitches: 2,
                    labels: const ['Client', 'Delivery Agent'],
                    activeBgColor: const [Color.fromARGB(255, 0, 225, 255)],
                    inactiveBgColor: Colors.grey[400],
                    onToggle: (index) {
                      typeNotifier.value = index == 0 ? "client" : "delagent";
                    },
                  );
                },
              ),
            ),
            OutlinedButton(
              onPressed: () {
                authenticateUser(context);
              },
              style: OutlinedButton.styleFrom(
                shadowColor: Colors.black,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
              child: const Text('Login'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signupGU');
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Color.fromARGB(255, 0, 225, 255),
                    decorationColor: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void authenticateUser(BuildContext context) async {
    //TODO authentication
    String username = usernameController.text;
    String password = passwordController.text;
    String role = typeNotifier.value;
    if (await login(username, password, role)) {
      setLoggedIn(true, usernameController.text);
      if (role == "client") {
        Navigator.pushNamed(context, '/homegu');
      } else {
        Navigator.pushNamed(context, '/homedel');
      }
    }
    // else{
    //   if (typeNotifier.value == "Client") {
    //     Navigator.pushNamed(context, '/homegu');
    //   } else {
    //     Navigator.pushNamed(context, '/homedel');
    //   }
    // }
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid Credentials"),
            content: const Text("Please enter valid credentials"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
