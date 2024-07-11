import 'package:flutter/material.dart';
import 'utilities.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'homePage.dart';

class SignUpPageGU extends StatelessWidget {
  SignUpPageGU({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController setPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ValueNotifier<String> typeNotifier = ValueNotifier<String>("Client");
  late Future<Position> location;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void initState() {
    location = _determinePosition();
  }

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
                        return Text("Error: ${snapshot.error}");
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
                  authenticateUser(context, usernameController,
                      setPasswordController, confirmPasswordController);
                },
                style: OutlinedButton.styleFrom(
                  shadowColor: Colors.black,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Sign Up',
                ),
              ),
            ])));
  }

  void authenticateUser(
      BuildContext context,
      TextEditingController username,
      TextEditingController setPassword,
      TextEditingController confirmPassword) {
    //TODO authentication
    if (setPassword.text == confirmPassword.text) {
      print('User Authenticated');
      Navigator.pushNamed(context, '/home');
    } else {
      print('Passwords do not match');
    }
  }
}

// Delivery agents vehicle?
