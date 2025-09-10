class Space {
  final String id;
  final String buildingId;
  final String floor;
  final int capacity;
  final List<String> equipment;

  Space({
    required this.id,
    required this.buildingId,
    this.floor = '',
    this.capacity = 0,
    this.equipment = const [],
  });

  factory Space.fromFirestore(doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Space(
      id: doc.id,
      buildingId: data['buildingId'] ?? '',
      floor: data['floor'] ?? '',
      capacity: data['capacity'] ?? 0,
      equipment: List<String>.from(data['equipment'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'buildingId': buildingId,
    'floor': floor,
    'capacity': capacity,
    'equipment': equipment,
  };
}