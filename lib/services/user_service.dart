import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class UserService {
  final String url = "${ApiConfig.baseUrl}/users";
  // ganti dengan IP lokal kalau pakai device nyata

  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    throw Exception("Failed to fetch users");
  }

  Future<void> createUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/users"),
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
      Uri.parse("${ApiConfig.baseUrl}/users/$id"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal hapus user");
    }
  }

}
