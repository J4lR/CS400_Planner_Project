import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://127.0.0.1:8000';

String? authToken;

Future<Map<String, dynamic>> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {'username': username, 'password': password},
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    authToken = data['access_token'];
    return {'success': true, 'username': data['username']};
  } else {
    return {'success': false, 'message': 'Invalid username or password'};
  }
}

Future<Map<String, dynamic>> register(String username, String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'email': email, 'password': password}),
  );
  if (response.statusCode == 200) {
    return {'success': true};
  } else {
    final data = jsonDecode(response.body);
    return {'success': false, 'message': data['detail']};
  }
}

Future<List<dynamic>> getTasks({String? category, String? filter}) async {
  String url = '$baseUrl/tasks';
  if (category != null) url += '?category=$category';
  if (filter != null) url += '?filter=$filter';
  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $authToken'},
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return [];
  }
}

Future<bool> createTask(Map<String, dynamic> task) async {
  final response = await http.post(
    Uri.parse('$baseUrl/tasks'),
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $authToken'},
    body: jsonEncode(task),
  );
  return response.statusCode == 200;
}

Future<bool> updateTask(int id, Map<String, dynamic> updates) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/tasks/$id'),
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $authToken'},
    body: jsonEncode(updates),
  );
  return response.statusCode == 200;
}

Future<bool> deleteTask(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/tasks/$id'),
    headers: {'Authorization': 'Bearer $authToken'},
  );
  return response.statusCode == 200;
}