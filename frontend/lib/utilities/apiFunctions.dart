// ignore_for_file: must_be_immutable, avoid_print, no_logic_in_create_state

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';

//cart functions with file

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


Future<String> getUsername() async {
  final file = await _localFile;
  Map<String, dynamic> json = jsonDecode(await file.readAsString());
  return json['username'];
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
  List<Map<String, dynamic>> nodelist = [];
  for (var item in json['cart']) {
    nodelist.add({
      'xposition': json['location']['xpos'],
      'yposition': json['location']['ypos'],
      'itemid': item['item'],
      'quantity': item['quantity'],
      'username': json['username']
    });
  }
  Map<String, dynamic> payload = {'nodelist': nodelist};
  print(jsonEncode(payload));
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

Future<Map<String, dynamic>> loadNewPaths() async {
  var url = Uri.parse('https://algorithm.akashshanmugaraj.com/get/paths');
  var response = await http.post(url,
      body: jsonEncode(
          {
    "xposition": 42.989979,
    "yposition": 53.004152
      }),
      headers: {"Content-Type": "application/json"});
  Map<String, dynamic> json = jsonDecode(response.body);
  print(json);
  return json;
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

Future<Set<Marker>> setMarkers(int index) async {
  List<LatLng> coordinates = await loadLocations(index);
  Set<Marker> _markers = {};
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

Future<Set<Polyline>> setPolylines(int index) async {
  List<LatLng> coordinates = await loadLocations(index);
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  for (int i = 0; i < coordinates.length; i++) {
    polylineCoordinates.add(coordinates[i]);
  }
  _polylines.add(Polyline(
    polylineId: PolylineId('polyline_$index'),
    color: Colors.blue,
    points: polylineCoordinates,
    width: 5,
  ));

  return _polylines;
}