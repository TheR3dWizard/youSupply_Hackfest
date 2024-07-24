import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utilities.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:geolocator/geolocator.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({
    super.key,
  }) {
    location = _determinePosition();
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController setPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final ValueNotifier<String> typeNotifier = ValueNotifier<String>("Client");
  late Future<Position> location;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   //centerTitle: false,
        //   title: Text(
        //     ' Sign Up',
        //     style: TextStyle(
        //       letterSpacing: 1.5,
        //       color: Colors.white70,
        //     ),
        //   ),
        //   backgroundColor: Colors.grey[850],
        // ),
        backgroundColor: Colors.black12,
        body: Center(
          child: SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      activeFgColor: Colors.black,
                      customTextStyles: [
                        TextStyle(fontWeight: FontWeight.bold)
                      ],
                      inactiveFgColor: Colors.black,
                      borderColor: [Colors.black45],
                      borderWidth: 1.5,
                      minWidth: 140,
                      minHeight: 50,
                      initialLabelIndex: 0,
                      totalSwitches: 2,
                      labels: const ['Client', 'Delivery Agent'],
                      activeBgColor: const [Color.fromARGB(255, 0, 225, 255)],
                      inactiveBgColor: Colors.grey[400],
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
                      FutureBuilder<Position>(
                        future: location,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return LabelledTextField.offOn(
                              enabled: false,
                              label:
                                  "Latitude: ${snapshot.data!.latitude}, Longitude: ${snapshot.data!.longitude}",
                            );
                          } else if (snapshot.hasError) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text(
                                  '${snapshot.error} \n Please enable location services and restart the app'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    SystemNavigator.pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
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
                      // Additional fields for delivery agents
                      ValueListenableBuilder<String>(
                        valueListenable: typeNotifier,
                        builder: (context, value, child) {
                          if (value == "Delivery Agent") {
                            return Column(
                              children: [
                                LabelledTextField.readable(
                                  label: "Vehicle Registration Number",
                                  controller: vehicleTypeController,
                                ),
                                LabelledTextField.readable(
                                  label: "License Number",
                                  controller: licenseNumberController,
                                ),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      authenticateUser(context, usernameController,
                          setPasswordController, confirmPasswordController);
                    },
                    style: OutlinedButton.styleFrom(
                      shadowColor: Colors.black,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: const Text('Sign Up'),
                  ),
                ])),
          ),
        ));
  }

  void authenticateUser(
      BuildContext context,
      TextEditingController username,
      TextEditingController setPassword,
      TextEditingController confirmPassword) {
    if (setPassword.text == confirmPassword.text) {
      print('User Authenticated');
      if (typeNotifier.value == 'Client') {
        Navigator.pushNamed(context, '/homegu');
      } else {
        Navigator.pushNamed(context, '/homedel');
      }
    } else {
      print('Passwords do not match');
    }
  }
}
