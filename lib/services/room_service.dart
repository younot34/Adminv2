import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/room.dart';
import 'device_service.dart';

class RoomService {
  final CollectionReference _devicesCollection = FirebaseFirestore.instance.collection("devices");
  Future<List> getRoomsFromDevices() async {
    final snapshot = await _devicesCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data["roomName"] ?? "Unknown Room";
    }).toList();
  }

  Future<Room> createRoom(Room room) async {
    final docRef = await _devicesCollection.add(room.toMap());
    return room.copyWith(id: docRef.id);
  }

  Future<List<Room>> getRooms() async {
    final snapshot = await _devicesCollection.get();
    return snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList();
  }

  Future<void> updateRoom(Room room) async {
    await _devicesCollection.doc(room.id).update(room.toMap());
  }

  Future<void> deleteRoom(String id) async {
    await _devicesCollection.doc(id).delete();
  }
}
