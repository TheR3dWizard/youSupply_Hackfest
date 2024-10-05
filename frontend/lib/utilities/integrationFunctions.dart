import "dart:convert";
import "dart:io";
import "package:flutter/services.dart";
import "package:frontend/utilities/apiFunctions.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
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

Future<bool> acceptPath(int pathid) async {
  final file = await _localFile;
  String fileContents = await file.readAsString();
  Map<String, dynamic> jsonFile = jsonDecode(fileContents);
  var curpathsfromfile = jsonFile['curpaths']['paths'];
  print("CURPATHS: $curpathsfromfile");
  print("PATHID: $pathid");
  var targetpath = curpathsfromfile['$pathid'];
  print("TARGETPATH: $targetpath");

  var listofnodes = targetpath["nodeids"];
  String username = await getUsername();
  jsonFile['accroutes'] = targetpath;
  await file.writeAsString(jsonEncode(jsonFile));

  var url = Uri.parse('$baseUrl/path/accept');
  var body = json.encode({"username": username, "nodes": listofnodes});
  print("BODY: $body");
  var response = await http.post(url,
      body: body,
      headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    print('Path accepted');
    return true;
  } else {
    print('Failed to accept path with status code: ${response.statusCode}');
    return false;
  }
}

Future<List<Map<String, dynamic>>> getAllPaths() async {
  final file = await _localFile;
  var url = Uri.parse('$baseUrl/path/get');
  String username = await getUsername();
  var response = await http.post(url,
      body: json.encode({
        "username": username,
      }),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    Map<String, dynamic> jsonFile = jsonDecode(await file.readAsString());
    jsonFile['curpaths'] = body;
    await file.writeAsString(jsonEncode(jsonFile));
    List<Map<String, dynamic>> paths = [];
    int numpaths = body['numpaths'];

    for (int i = 0; i < numpaths; i++) {
      print("PATH $i: ${body['paths']["$i"]}");
      paths.add(body['paths']["$i"]);
      print("WORKS");
    }
    return paths;
  } else {
    throw Exception("Failed to load paths");
  }
}

class RouteStep {
  String Location;
  String resources;
  String action;
  bool? completed;

  RouteStep(this.Location, this.action, this.resources, {this.completed});

  void printData() {
    print("Location: $Location, Action: $action, Resources: $resources");
  }
}

Future<List<RouteStep>> viewSpecificPath(String key) async {
  final file = await _localFile;
  Map<String, dynamic> jsonFile = jsonDecode(await file.readAsString());
  Map<String, dynamic> curpath = jsonFile['curpaths'];

  Map<String, dynamic> paths = curpath['paths'];
  List<RouteStep> result = [];

  if (paths.containsKey(key)) {
    var pathDetails = paths[key]['path_details'];

    for (var path in pathDetails) {
      String inwords = path['inwords'];
      String itemtype = path['itemtype'];
      int quantity = path['quantity'];
      String action = (quantity > 0) ? 'pickup' : 'deliver';
      String resources = 'Item Type: $itemtype, Quantity: $quantity';
      RouteStep step = RouteStep(inwords, action, resources);
      result.add(step);
    }
  }

  return result;
}

Future<List<RouteStep>> viewAcceptedPath() async {
  print("acc path func called");

  final file = await _localFile;
  Map<String, dynamic> jsonFile = jsonDecode(await file.readAsString());
  Map<String, dynamic> curpath = jsonFile['accroutes'];
  List<RouteStep> result = [];

  int completedStep = await getCompletedStep();
  int i = 0;
  var pathDetails = curpath['path_details'];

  for (var path in pathDetails) {
    String inwords = path['inwords'];
    String itemtype = path['itemtype'];
    int quantity = path['quantity'];
    String action = (quantity > 0) ? 'pickup' : 'deliver';
    String resources = 'Item Type: $itemtype, Quantity: $quantity';
    RouteStep step =
        RouteStep(inwords, action, resources, completed: completedStep >= i);
    i++;
    result.add(step);
  }

  return result;
}

Future<int> getCompletedStep() async {
  String username = await getUsername();
  var url = Uri.parse('$baseUrl/path/lookup');
  var response = await http.post(url,
      body: json.encode({"username": username}),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body['completed'];
  } else {
    throw Exception("Failed to load paths");
  }
}

Future<void> markStep() async {
  String username = await getUsername();
  var url = Uri.parse('$baseUrl/path/markstep');
  var response = await http.post(url,
      body: json.encode({"userid": username}),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode != 200) {
    throw Exception("Failed to mark step");
  }
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
