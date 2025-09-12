import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "http://10.21.161.65:8000/api/users"; // emulator
  // ganti dengan IP lokal kalau pakai device nyata

  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl), headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    throw Exception("Failed to fetch users");
  }

  Future<void> createUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create user: ${response.body}");
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse("http://localhost:8000/api/users/$id"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal hapus user");
    }
  }

}
