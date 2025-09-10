import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/building.dart';

class BuildingService {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection("buildings");

  // CREATE
  Future<Building> addBuilding(String name, String address) async {
    final docRef = await _collection.add({"name": name, "address": address});
    return Building(id: docRef.id, name: name, address: address);
  }

  // READ
  Future<List<Building>> getAllBuildings() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => Building.fromFirestore(doc)).toList();
  }

  // UPDATE
  Future<void> updateBuilding(Building building) async {
    await _collection.doc(building.id).update(building.toMap());
  }

  // DELETE
  Future<void> deleteBuilding(String id) async {
    await _collection.doc(id).delete();
  }
}
