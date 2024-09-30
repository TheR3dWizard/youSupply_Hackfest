import "dart:convert";
import "package:frontend/utilities/apiFunctions.dart";
import "package:http/http.dart" as http;

String baseUrl = 'https://algorithm.akashshanmugaraj.com';

Future<bool> login(String username, String password, String role) async {
  print("USERNAME: $username, PASSWORD: $password, ROLE: $role");
  var url = Uri.parse('$baseUrl/user/login');
  var response = await http.post(url,
      body: json.encode(
          {'username': username, 'password': password}),
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


Future<void> getPathData() async {

}