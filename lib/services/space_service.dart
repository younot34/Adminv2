import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/space.dart';

class SpaceService {
  final String url = "${ApiConfig.baseUrl}/spaces";

  Future<List<Space>> getSpaces() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Space.fromJson(e)).toList();
    }
    throw Exception("Failed to fetch spaces");
  }

  Future<List<Space>> getSpacesByBuilding(int buildingId) async {
    final response = await http.get(Uri.parse("$url?building_id=$buildingId"));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Space.fromJson(e)).toList();
    }
    throw Exception("Failed to fetch spaces by building");
  }

  Future<Space> createSpace(Space space) async {
    final response = await http.post(
      Uri.parse(url),
      headers: ApiConfig.headers,
      body: jsonEncode(space.toJson()),
    );
    if (response.statusCode == 201) {
      return Space.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to create space");
  }

  Future<void> updateSpace(Space space) async {
    final response = await http.put(
      Uri.parse("$url/${space.id}"),
      headers: ApiConfig.headers,
      body: jsonEncode(space.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update space");
    }
  }

  Future<void> deleteSpace(String id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    if (response.statusCode != 204) {
      throw Exception("Failed to delete space");
    }
  }
}