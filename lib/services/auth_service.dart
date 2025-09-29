import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AuthService {
  static Future<String?> login(String email, String password) async {
    if (email != "admin@gmail.com") {
      return null; // langsung gagal tanpa request ke backend
    }
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/login"),
      headers: ApiConfig.headers,
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"]; // simpan token JWT / Sanctum
    } else {
      return null;
    }
  }

  static Future<void> logout(String token) async {
    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/logout"),
      headers: {
        ...ApiConfig.headers,
        "Authorization": "Bearer $token",
      },
    );
  }
}