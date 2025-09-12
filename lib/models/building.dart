// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Building {
//   final String id;
//   final String name;
//   final String address;
//
//   Building({required this.id, required this.name, required this.address});
//
//   factory Building.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Building(
//       id: doc.id,
//       name: data['name'] ?? '',
//       address: data['address'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'address': address,
//     };
//   }
// }

class Building {
  final String id;
  final String name;
  final String address;

  Building({required this.id, required this.name, required this.address});

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
  };
}

