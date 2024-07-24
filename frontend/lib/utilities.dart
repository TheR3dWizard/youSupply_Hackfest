// ignore_for_file: must_be_immutable, avoid_print, no_logic_in_create_state

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';

class LabelledTextField extends StatelessWidget {
  final String label;
  TextEditingController? controller;
  bool? enabled;
  bool? hidden;

  //final Function(String) subFunction;
  LabelledTextField({
    super.key,
    required this.label,
    //required this.subFunction
  });

  LabelledTextField.readable({
    super.key,
    required this.label,
    required this.controller,
  });

  LabelledTextField.offOn({
    super.key,
    required this.label,
    required this.enabled,
  });

  LabelledTextField.hidden({
    super.key,
    required this.label,
    this.hidden = true,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: SizedBox(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: TextField(
            style: const TextStyle(
              color: Colors.white,
            ),
            obscureText: hidden ?? false,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gapPadding: 5.0,
              ),
              labelText: label,
              labelStyle: const TextStyle(
                color: Colors.white70,
              ),
            ),
            controller: controller,
            enabled: enabled,
            //onSubmitted: subFunction,
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final String label1;
  PasswordField(
      {super.key,
      this.obscureText = true,
      required this.controller,
      required this.label1});
  TextEditingController controller;
  bool obscureText = true;

  @override
  _PasswordFieldState createState() => _PasswordFieldState(
      obscureText: obscureText, controller: controller, label1: label1);
}

class _PasswordFieldState extends State<PasswordField> {
  final String label1;
  _PasswordFieldState(
      {required this.obscureText,
      required this.controller,
      required this.label1});
  bool obscureText;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: SizedBox(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gapPadding: 5.0,
              ),
              labelText: label1,
              labelStyle: TextStyle(
                color: Colors.white70, // White label text color
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  color: Colors.white70,
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Bet extends StatefulWidget {
  final String name;
  final String pool;
  final String players;
  const Bet(
      {super.key,
      required this.name,
      required this.pool,
      required this.players});

  @override
  State<Bet> createState() =>
      _BetState(name: name, pool: pool, players: players);
}

class _BetState extends State<Bet> {
  String name;
  String pool;
  String players;

  _BetState({required this.name, required this.pool, required this.players});
  //TODO add on pressed function

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
        child: Container(
          width: 100,
          height: 50,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(100, 0, 0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 4.0), // shadow direction: bottom right
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(name),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(pool), Text(players)],
                ),
              )
            ],
          ),
        ));
  }
}

class Pill extends StatefulWidget {
  final String rightText;
  final String leftText;
  const Pill({super.key, required this.rightText, required this.leftText});

  @override
  State<Pill> createState() =>
      _PillState(rightText: rightText, leftText: leftText);
}

class _PillState extends State<Pill> {
  String rightText;
  String leftText;

  _PillState({required this.rightText, required this.leftText});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
        child: Container(
          width: 500,
          height: 50,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(100, 0, 0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 4.0), // shadow direction: bottom right
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(leftText),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Text(rightText)),
            ],
          ),
        ));
  }
}

class Option extends StatelessWidget {
  final String label;
  final String route;

  Option({super.key, required this.label, required this.route});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
      child: Container(
        width: 370,
        height: 80,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 225, 255),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0.0, 2.0),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    letterSpacing: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: IconButton(
                  icon: Icon(
                    size: 30,
                    Icons.arrow_right_outlined,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, route);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class Select extends StatelessWidget {
  final String label;
  final String route;
  final IconData icon;
  final Function onpressed;

  Select(
      {super.key,
      required this.label,
      required this.route,
      required this.icon,
      required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 250,
        maxWidth: 500,
        // minWidth: 250,
      ),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0.0, 2.0),
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(0.0, 0.0),
            )
          ]),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                child: IconButton(
                  icon: Icon(
                    icon,
                    size: 70,
                    color: Color.fromARGB(255, 0, 225, 255),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, route);
                  },
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 30),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 25,
                  //fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Color.fromARGB(255, 0, 225, 255),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String label1;
  final String label2;
  final String route;

  Item({
    super.key,
    required this.label1,
    required this.label2,
    required this.route,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
      child: Container(
        width: 450,
        height: 100,
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0.0, 2.0),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      label1,
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 1,
                        color: Color.fromARGB(255, 0, 225, 255),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      label2,
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Icon(
                  size: 30,
                  Icons.arrow_right_outlined,
                  color: Colors.grey[700],
                )),
          ],
        ),
      ),
    );
  }
}

//Cart Functions using localFile

Future<void> printFile() async {
  final file = await _localFile;
  print(await file.readAsString());
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;

  File file = File('$path/account.json');
  if (!file.existsSync()) {
    await file.create(exclusive: false);
    String jsonString = await rootBundle.loadString('assets/account.json');
    await file.writeAsString(jsonString);
  }

  return file;
}

Future<void> setUserDetails(
    String username, String xpos, String ypos, String role) async {
  final file = await _localFile;

  Map<String, dynamic> json = jsonDecode(await file.readAsString());
  json['username'] = username;
  json['location']['xpos'] = xpos;
  json['location']['ypos'] = ypos;
  json['userrole'] = role;

  await file.writeAsString(jsonEncode(json));
}

Future<void> addToCart(String item, int quantity) async {
  final file = await _localFile;
  bool found = false;
  Map<String, dynamic> json = jsonDecode(await file.readAsString());

  print("File before adding:");
  printFile();
  json['cart'].forEach((element) {
    if (element['item'] == item) {
      found = true;
      element['quantity'] = quantity;
      return;
    }
  });

  if (!found) {
    json['cart'].add({'item': item, 'quantity': quantity});
  }

  await file.writeAsString(jsonEncode(json));
  print("File after adding: ");
  printFile();

}

//empties the cart
Future<void> emptyCart() async {
  final file = await _localFile;
  Map<String, dynamic> json = jsonDecode(await file.readAsString());
  json['cart'] = [];
  await file.writeAsString(jsonEncode(json));
}

Future<List<String>> getCoords() async {
  final file = await _localFile;
  Map<String, dynamic> json = jsonDecode(await file.readAsString());
  return [json['location']['xpos'], json['location']['ypos']];
}

List<double> getrandomCoords() {
  Random random = new Random();
  double x = random.nextDouble() * 100;
  double y = random.nextDouble() * 100;
  return [x,y];
}

Future<void> removeFromCart(String item) async {
  final file = await _localFile;
  Map<String, dynamic> json = jsonDecode(await file.readAsString());
  json['cart'].removeWhere((element) => element['item'] == item);

  await file.writeAsString(jsonEncode(json));
}

Future<bool> isLoggedIn() async {
  final file = await _localFile;
  Map<String, dynamic> json = jsonDecode(await file.readAsString());
  return json['loggedin'];
}

Future<void> setLoggedIn(bool value, String username) async {
  final file = await _localFile;
  print("File is: ${await file.readAsString()}");
  Map<String, dynamic> json = jsonDecode(await file.readAsString());
  print("Hello CUrrent");

  json['loggedin'] = value;
  json['username'] = username;

  await file.writeAsString(jsonEncode(json));
}

Future<List<Map<String, dynamic>>> readCart() async {
  final file = await _localFile;
  Map<String, dynamic> json = jsonDecode(await file.readAsString());
  List<dynamic> cartDynamic = json['cart'];
  print("File when reading cart");
  printFile();
  // Convert List<dynamic> to List<Map<String, dynamic>>
  List<Map<String, dynamic>> cart =
      cartDynamic.map((item) => item as Map<String, dynamic>).toList();

  return cart;
}

// Backend Functions

String baseUrl = 'https://hackfest.akashshanmugaraj.com';
String basealgoUrl = 'https://algorithm.akashshanmugaraj.com';


//item id and item name map

Map<String, String> itemnameToID = {
  'First Aid Kit': 'c8b1d27f-e9c4-4c28-a7db-332daba4ac42',
  'water bottle': '9fdb9531-29d9-41e6-aeb3-5e1fdf79c867',
  'Water Bottle': '9fdb9531-29d9-41e6-aeb3-5e1fdf79c867',
  'Blanket': '6674ea86-9340-4a81-bf7a-d583b054f7a0',
  'Flashlight': '619d8b87-a67c-4769-bbf0-839715a3603d',
  'Food Packages': '754788e4-a944-44d3-ad80-f3e5c6a8b689'
};

List<String> items = [
  'First Aid Kit',
  'Water Bottle',
  'water bottle',

  'Blanket',
  'Flashlight',
  'Food Packages'
];

Future<bool> login(String username, String password, String role) async {
  print("USERNAME: $username, PASSWORD: $password, ROLE: $role");
  var url = Uri.parse('$baseUrl/authenticate/login');
  var response = await http.post(url,
      body: json.encode(
          {'username': username, 'password': password, "userrole": role}),
      headers: {"Content-Type": "application/json"});
  print(response.body);
  if (response.statusCode == 200) {
    print("Hello");
    var json = jsonDecode(response.body);
    print("Hello 2");
    //await setUserDetails(
    //    username, json['latitude'], json['longitude'], json['userrole']);
    await setLoggedIn(true, username);
    print("Works!");
    return true;
  }
  return false;
}

//TODO change everything once we get the actual API
Future<bool> register(String username, String password, String phone,
    String role, double longitude, double latitude) async {
  var url = Uri.parse('$baseUrl/register');
  var response = await http.post(url, body: {
    'username': username,
    'password': password,
    'phone': phone,
    'role': role,
  }, headers: {
    "Content-Type": "application/json"
  });

  return response.statusCode == 200;
}

Future<bool> addnode(String itemtype, int quantity) async {
  var url = Uri.parse('$baseUrl/add/request');
  List<String> coords = await getCoords();
  var response = await http.post(url, body: {
    'xposition': coords[0],
    'yposition': coords[1],
    'itemtype': itemtype,
    'quantity': quantity,
  }, headers: {
    "Content-Type": "application/json"
  });

  return response.statusCode == 200;
}

//sends all nodes in cart to backend
Future<void> sendcart() async {
  final file = await _localFile;
  Map<String, dynamic> json = jsonDecode(await file.readAsString());
  print("File before sending:");
  printFile();

  // print("Dictionary is");
  // print(itemnameToID);
  
  // List<String> coords = await getCoords();
  List<double> coords = getrandomCoords();

  json['cart'].forEach((element) async {
    if (element['quantity'] == 0) {
    }

    var url = Uri.parse('$basealgoUrl/add/node');
    
    // print("KEY is ${element['item']}");
    // print("VALUE is ${itemnameToID[element['item']]}");
    
    String itemid = itemnameToID[element['item']] ?? "";
    if (itemid == "") {
      print("Item ID not found for ${element['item']}");
      return;
    }

    print(
        "Item: ${element['item']}, quantity: ${element['quantity']},xposition: ${coords[0]}, yposition: ${coords[1]}");

    var response = await http.post(url,
        body: jsonEncode({
          'itemid': itemid,
          'quantity': element['quantity'],
          'xposition': coords[0],
          'yposition': coords[1],
          'username': json['username'],
        })
        ,headers: {"Content-Type": "application/json"}
        );

    await Future.delayed(const Duration(seconds: 1));

    print(jsonEncode({
          'itemid': itemid,
          'quantity': element['quantity'],
          'xposition': coords[0],
          'yposition': coords[1],
          'username': json['username'],
        }));

    if (response.statusCode == 200) {
      print("Successfully sent ${element['item']}");
      removeFromCart(element['item']);
    } else {
      print(response.statusCode);
      print("Failed to send ${element['item']}");
      print(response.body);
    }
  });
  print("File after sending:");
  printFile();
}

Future<Map<String, dynamic>> loadPaths() async {
  var url = Uri.parse('https://algorithm.akashshanmugaraj.com/sample/paths');
  var response = await http.post(url,
      body: jsonEncode(
          {"username": "abc", "password": "abc", "userrole": "client"}),
      headers: {"Content-Type": "application/json"});
  Map<String, dynamic> json = jsonDecode(response.body);
  print(json['paths']);
  return json['paths'];
}


Future<List<LatLng>> loadLocations(int index) async {

  Map<String, dynamic> paths = await loadPaths();
  List<LatLng> toLocations = [];
  paths.forEach((key, value) {
    if (key == index.toString()) {
      value.forEach((element) {
        toLocations.add(LatLng(element['latitude'], element['longitude']));
      });
    }
  });

  return toLocations;
  
}

List<Marker> _setMarkers(List<LatLng> coordinates) {

  List<Marker> _markers = [];
  for (int i = 0; i < coordinates.length; i++) {
    _markers.add(
      Marker(
        markerId: MarkerId('marker_$i'),
        position: coordinates[i],
      ),
    );
  }

  return _markers;
}

Future<List<String>> loadResourcesToCollect(int index) async {
  Map<String, dynamic> paths = await loadPaths();
  List<String> resourcesToCollect = [];
  paths.forEach((key, value) {
    if (key == index.toString()) {
      value.forEach((element) {
        String resource;
        if (element['quantity'] < 0) {
          resource =
              "${-1 * element['quantity']}  $element['itemtype'] to deliver";
        } else {
          resource = "${element['quantity']}  $element['itemtype'] to collect";
        }
        resourcesToCollect.add(resource);
      });
    }
  });

  return resourcesToCollect;
}

//The data that should be passed into a single row of the routes widget
//pass it in the constructor and access the data
// the current format for everything is correct just use this data (if the data seems wrong just lmk and I can change it)
class Tuple {
  String startLoc;
  String endLoc;
  String resources;

  Tuple(this.startLoc, this.endLoc, this.resources);

  void printData() {
    print('Start Location: $startLoc');
    print('End Location: $endLoc');
    print('Resources: $resources');
  }
}

//It takes an index as the parameter and generates all the tuples for the path that is referenced by that index
//The index is the key of the path in the paths json
//Call this function via a future builder in the MapView widget and use a list view builder or smtng to create it (similar to cartpage)

Future<List<Tuple>> loadPathsTuple(int index) async {
  Map<String, dynamic> paths = await loadPaths();
  List<Tuple> pathList = [];
  List<dynamic> pathDynamic = paths[index.toString()];
  List<Map<String, dynamic>> path = pathDynamic.map((item) => item as Map<String, dynamic>).toList();
  for (int i = 1; i < path.length; i++) {
    print("Here");
    // String startLoc = await getAddress(path[i - 1]['latitude'], path[i - 1]['longitude']);
    String startLoc = "${path[i - 1]['latitude']},${path[i - 1]['longitude']}";
    String endLoc = "${path[i]['latitude']},${path[i]['longitude']}";
    String resources;
    if (path[i - 1]['quantity'] < 0) {
      resources =
          "${-1 * path[i-1]['quantity']}  ${path[i-1]['itemtype']} to deliver";
    } else {
      resources = "${path[i-1]['quantity']}  ${path[i-1]['itemtype']} to collect";
    }
    pathList.add(Tuple(startLoc, endLoc, resources));
  }

  print('Path List: ');
  for (int i = 0; i < pathList.length; i++) {
    pathList[i].printData();
  }
  return pathList;
}

//This loads all the tuple lists for all the paths
Future<List<List<Tuple>>> loadAllPathsTuple() async {
  Map<String, dynamic> paths = await loadPaths();
  List<List<Tuple>> allPaths = [];
  paths.forEach((key, value) async {
    allPaths.add(await loadPathsTuple(int.parse(key)));
  });

  return allPaths;
}

//This will load all the data needed in the available widget
//Call this function via a future builder in the available widget and use a list view builder or smtng to create it (similar to cartpage)
Future<List<List<String>>> loadPathsNames() async {
  Map<String, dynamic> paths = await loadPaths();
  List<List<String>> pathNames = [];
  paths.forEach((key, value) {
    pathNames
        .add(["${value[0]['latitude']},${value[0]['longitude']}", "5 kms"]);
  });

  return pathNames;
}


Future<String> getAddress(double lat,double lng) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat,lng);
  Placemark place = placemarks[0];
  return place.name ?? place.locality ?? place.subLocality ?? place.administrativeArea ?? "Unknown";
}
