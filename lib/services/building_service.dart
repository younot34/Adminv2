import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/booking.dart';
import '../models/building.dart';

class BuildingService {
  final String url = "${ApiConfig.baseUrl}/buildings";

  Future<List<Building>> getAllBuildings() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Building.fromJson(e)).toList();
    }
    throw Exception("Failed to fetch buildings");
  }

  Future<Building> create(Building building) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(building.toJson()),
    );
    if (response.statusCode == 201) {
      return Building.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to create building");
  }

  Future<void> update(Building building) async {
    final response = await http.put(
      Uri.parse("$url/${building.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(building.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update building");
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    if (response.statusCode != 204) {
      throw Exception("Failed to delete building");
    }
  }

}