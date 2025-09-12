// class Space {
//   final String id;
//   final String buildingId;
//   final String floor;
//   final int capacity;
//   final List<String> equipment;
//
//   Space({
//     required this.id,
//     required this.buildingId,
//     this.floor = '',
//     this.capacity = 0,
//     this.equipment = const [],
//   });
//
//   factory Space.fromFirestore(doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Space(
//       id: doc.id,
//       buildingId: data['buildingId'] ?? '',
//       floor: data['floor'] ?? '',
//       capacity: data['capacity'] ?? 0,
//       equipment: List<String>.from(data['equipment'] ?? []),
//     );
//   }
//
//   Map<String, dynamic> toMap() => {
//     'buildingId': buildingId,
//     'floor': floor,
//     'capacity': capacity,
//     'equipment': equipment,
//   };
// }

class Space {
  final String id;
  final String buildingId;
  final String floor;
  final int capacity;
  final List<String> equipment;

  Space({
    required this.id,
    required this.buildingId,
    required this.floor,
    required this.capacity,
    required this.equipment,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['id'],
      buildingId: json['building_id'],
      floor: json['floor'],
      capacity: json['capacity'],
      equipment: List<String>.from(json['equipment'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'building_id': buildingId,
    'floor': floor,
    'capacity': capacity,
    'equipment': equipment,
  };
}
