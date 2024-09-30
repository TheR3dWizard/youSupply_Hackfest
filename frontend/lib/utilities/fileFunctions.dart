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
  Random random = Random();
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
