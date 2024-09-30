import "dart:convert";
import "dart:ffi";
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
      body: json
          .encode({'username': username, 'password': password, "role": role}),
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

  var response = await http.post(url,
      body: json.encode({
        "username": getUsername(),
      }),
      headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    Map<String, dynamic> jsonFile = jsonDecode(await file.readAsString());
    jsonFile['curpaths'] = body;
    await file.writeAsString(jsonEncode(jsonFile));
  }
}

Future<void> acceptPath(Int16 pathid) async {
  final file = await _localFile;
  Map<String, dynamic> jsonFile = jsonDecode(await file.readAsString());

  var curpathsfromfile = jsonFile['curpaths']['paths'];

  var targetpath = curpathsfromfile[pathid];

  var listofnodes = targetpath["nodeids"];

  jsonFile['accroutes'] = targetpath;

  var url = Uri.parse('$baseUrl/path/accept');
  var response = await http.post(url,
      body: json.encode({"username": getUsername(), "nodeids": listofnodes}),
      headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    await savePathData();
  }
}

Future<List<Map<String, dynamic>>> getAllPaths() async {
  final file = await _localFile;
  var url = Uri.parse('$baseUrl/path/get');

  // HTTP request to get paths from the server
  var response = await http.post(url,
      body: json.encode({
        "username": getUsername(),
      }),
      headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    // Parse response body
    var body = jsonDecode(response.body);

    // Update local file with the new paths
    Map<String, dynamic> jsonFile = jsonDecode(await file.readAsString());
    jsonFile['curpaths'] = body;
    await file.writeAsString(jsonEncode(jsonFile));

    // Extract and return the relevant path data (startloc and distance)
    List<Map<String, dynamic>> paths = [];
    for (var path in body) {
      paths.add({
        'startloc': path['startloc'],
        'distance': path['distance'],
      });
    }
    return paths;
  } else {
    throw Exception("Failed to load paths");
  }
}
