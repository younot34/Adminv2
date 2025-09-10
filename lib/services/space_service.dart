import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/space.dart';

class SpaceService {
  final CollectionReference spacesCollection =
  FirebaseFirestore.instance.collection('spaces');

  /// Ambil semua space
  Future<List<Space>> getSpaces() async {
    final snapshot = await spacesCollection.get();
    return snapshot.docs.map((doc) => Space.fromFirestore(doc)).toList();
  }

  /// Buat space baru
  Future<void> createSpace(Space space) async {
    await spacesCollection.add(space.toMap());
  }

  /// Update space existing
  Future<void> updateSpace(Space space) async {
    if (space.id.isEmpty) return;
    await spacesCollection.doc(space.id).update(space.toMap());
  }

  /// Hapus space
  Future<void> deleteSpace(String id) async {
    await spacesCollection.doc(id).delete();
  }

  /// Ambil space berdasarkan Building ID
  Future<List<Space>> getSpacesByBuilding(String buildingId) async {
    final snapshot = await spacesCollection
        .where('buildingId', isEqualTo: buildingId)
        .get();
    return snapshot.docs.map((doc) => Space.fromFirestore(doc)).toList();
  }
}