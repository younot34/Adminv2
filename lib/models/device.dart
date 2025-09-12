// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Device {
//   final String id;
//   final String deviceName;
//   final String roomName;
//   final String location;
//   final DateTime installDate;
//   final int capacity;
//   final List<String> equipment;
//   final bool isOn;
//
//   Device({
//     required this.id,
//     required this.deviceName,
//     required this.roomName,
//     required this.location,
//     required this.installDate,
//     required this.capacity,
//     required this.equipment,
//     required this.isOn,
//   });
//
//   factory Device.fromFirestore(doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Device(
//       id: doc.id,
//       deviceName: data['deviceName'] ?? '',
//       roomName: data['roomName'] ?? 'Unknown Room',
//       location: data['location'] ?? '',
//       installDate: data['installDate'] is Timestamp
//           ? (data['installDate'] as Timestamp).toDate()
//           : DateTime.now(),
//       capacity: data['capacity'] ?? 0,
//       equipment: List<String>.from(data['equipment'] ?? []),// fallback default
//       isOn: data['isOn'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toMap() => {
//     'deviceName': deviceName,
//     'roomName': roomName,
//     'location': location,
//     'installDate': installDate,
//     'capacity': capacity,
//     'equipment': equipment,
//     'isOn': isOn,
//   };
// }

class Device {
  final String id;
  final String deviceName;
  final String roomName;
  final String location;
  final DateTime? installDate;
  final int? capacity;
  final List<String> equipment;
  final bool isOn;

  Device({
    required this.id,
    required this.deviceName,
    required this.roomName,
    required this.location,
    required this.installDate,
    this.capacity,
    this.equipment = const [],
    this.isOn = false,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      deviceName: json['device_name'] ?? '',
      roomName: json['room_name'] ?? 'Unknown Room',
      location: json['location'] ?? '',
      installDate: json['install_date'] != null && json['install_date'] != ''
          ? DateTime.tryParse(json['install_date'])
          : null,
      capacity: json['capacity'],
      equipment: List<String>.from(json['equipment'] ?? []),
      isOn: json['is_on'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'device_name': deviceName,
    'room_name': roomName,
    'location': location,
    'install_date': installDate?.toIso8601String(),
    'capacity': capacity,
    'equipment': equipment,
    'is_on': isOn,
  };
}