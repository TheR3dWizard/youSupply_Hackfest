import "dart:convert";
import "dart:io";
import "package:flutter/services.dart";
import "package:frontend/utilities/apiFunctions.dart";
import "package:geolocator/geolocator.dart";
import "package:http/http.dart" as http;
import "package:frontend/utilities/fileFunctions.dart";
import "package:path_provider/path_provider.dart";

String baseUrl = 'https://algorithm.akashshanmugaraj.com';

Future<bool> login(String username, String password, String role) async {
  print("USERNAME: $username, PASSWORD: $password, ROLE: $role");
  var url = Uri.parse('$baseUrl/user/login');
  var response = await http.post(url,
      body: json.encode(
          {'username': username, 'password': password,"role": role}),
      headers: {"Content-Type": "application/json"});
  print(response.body);
  if (response.statusCode == 200) { 
    var json = jsonDecode(response.body);
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



Future<void> savePathData() async {
  final file = await _localFile;
  var url = Uri.parse('$baseUrl/path/get');


  var response = await http.post(url,body: json.encode({
    "username": getUsername(),
  }), headers: {
    "Content-Type": "application/json"
  });

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    Map<String,dynamic> jsonFile = jsonDecode(await file.readAsString());
    jsonFile['curpaths'] = body;
  }

}