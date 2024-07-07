import 'package:flutter/material.dart';
import 'utilities.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SignUpPageGU extends StatelessWidget {
  SignUpPageGU({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController setPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ValueNotifier<String> typeNotifier = ValueNotifier<String>("Client");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
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
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            )),
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
        Column(
          children: [
            LabelledTextField.readable(
              label: "Username",
              controller: usernameController,
            ),
            LabelledTextField.readable(
              label: "Contact Number",
              controller: contactController,
            ),
            PasswordField(
              label1: "Set Password",
              controller: setPasswordController,
            ),
            PasswordField(
              label1: "Confirm Password",
              controller: confirmPasswordController,
            ),
            // LabelledTextField.readable(
            //   label: "Address",
            //   controller: addressController,
            // ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                  onPressed: () {
                    print('pressed');
                  },
                  icon: Icon(Icons.photo),
                  color: Colors.grey),
              const Text('Upload Profile Picture'),
            ]),
          ],
        ),
        OutlinedButton(
          onPressed: () {
            authenticateUser(context, usernameController, setPasswordController,
                confirmPasswordController);
          },
          style: OutlinedButton.styleFrom(
            shadowColor: Colors.black,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
          ),
          child: const Text('Sign Up',
          
              ),
        ),
      ],
    )));
  }

  void authenticateUser(
      BuildContext context,
      TextEditingController username,
      TextEditingController setPassword,
      TextEditingController confirmPassword) {
    //TODO authentication
  }
}


// Delivery agents vehicle?