// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Booking {
//   final String id;
//   final String roomName;
//   final String date;
//   final String time;
//   final String? duration;
//   final int? numberOfPeople;
//   final List<String> equipment;
//   final String hostName;
//   final String meetingTitle;
//   final bool isScanEnabled;
//   final String? scanInfo;
//   final String status;
//   String? location;
//
//   Booking({
//     required this.id,
//     required this.roomName,
//     required this.date,
//     required this.time,
//     this.duration,
//     this.numberOfPeople,
//     required this.equipment,
//     required this.hostName,
//     required this.meetingTitle,
//     this.isScanEnabled = false,
//     this.scanInfo,
//     this.status = "upcoming",
//     this.location,
//   });
//
//   factory Booking.newBooking({
//     required String roomName,
//     required String date,
//     required String time,
//     String? duration,
//     int? numberOfPeople,
//     required List<String> equipment,
//     required String hostName,
//     required String meetingTitle,
//     bool isScanEnabled = false,
//     String? scanInfo,
//   }) {
//     return Booking(
//       id: "",
//       roomName: roomName,
//       date: date,
//       time: time,
//       duration: duration,
//       numberOfPeople: numberOfPeople,
//       equipment: equipment,
//       hostName: hostName,
//       meetingTitle: meetingTitle,
//       isScanEnabled: isScanEnabled,
//       scanInfo: scanInfo,
//
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       "roomName": roomName,
//       "date": date,
//       "time": time,
//       "duration": duration,
//       "numberOfPeople": numberOfPeople,
//       "equipment": equipment,
//       "hostName": hostName,
//       "meetingTitle": meetingTitle,
//       "isScanEnabled": isScanEnabled,
//       "scanInfo": scanInfo,
//     };
//   }
//
//   factory Booking.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Booking(
//       id: doc.id,
//       roomName: data["roomName"] ?? "",
//       date: data["date"] ?? "",
//       time: data["time"] ?? "",
//       duration: data["duration"],
//       numberOfPeople: data["numberOfPeople"],
//       equipment: List<String>.from(data["equipment"] ?? []),
//       hostName: data["hostName"] ?? "",
//       meetingTitle: data["meetingTitle"] ?? "",
//       isScanEnabled: data["isScanEnabled"] ?? false,
//       scanInfo: data["scanInfo"],
//     );
//   }
//   Booking copyWith({
//     String? id,
//     String? roomName,
//     String? date,
//     String? time,
//     String? duration,
//     int? numberOfPeople,
//     List<String>? equipment,
//     String? hostName,
//     String? meetingTitle,
//     bool? isScanEnabled,
//     String? scanInfo,
//   }) {
//     return Booking(
//       id: id ?? this.id,
//       roomName: roomName ?? this.roomName,
//       date: date ?? this.date,
//       time: time ?? this.time,
//       duration: duration ?? this.duration,
//       numberOfPeople: numberOfPeople ?? this.numberOfPeople,
//       equipment: equipment ?? this.equipment,
//       hostName: hostName ?? this.hostName,
//       meetingTitle: meetingTitle ?? this.meetingTitle,
//       isScanEnabled: isScanEnabled ?? this.isScanEnabled,
//       scanInfo: scanInfo ?? this.scanInfo,
//     );
//   }
// }

class Booking {
  final String id;
  final String roomName;
  final String date;
  final String time;
  final String duration;
  final int numberOfPeople;
  final List<String> equipment;
  final String hostName;
  final String meetingTitle;
  final bool isScanEnabled;
  final String? scanInfo;
  final String? status;
  late final String? location;

  Booking({
    required this.id,
    required this.roomName,
    required this.date,
    required this.time,
    required this.duration,
    required this.numberOfPeople,
    required this.equipment,
    required this.hostName,
    required this.meetingTitle,
    required this.isScanEnabled,
    this.scanInfo,
    this.status,
    this.location,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'].toString(),
      roomName: json['room_name'],
      date: json['date'],
      time: json['time'],
      duration: json['duration'],
      numberOfPeople: json['number_of_people'],
      equipment: List<String>.from(json['equipment'] ?? []),
      hostName: json['host_name'],
      meetingTitle: json['meeting_title'],
      isScanEnabled: json['is_scan_enabled'] ?? false,
      scanInfo: json['scan_info'],
      status: json['status'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() => {
    'room_name': roomName,
    'date': date,
    'time': time,
    'duration': duration,
    'number_of_people': numberOfPeople,
    'equipment': equipment,
    'host_name': hostName,
    'meeting_title': meetingTitle,
    'is_scan_enabled': isScanEnabled,
    'scan_info': scanInfo,
    'status': status,
    'location': location,
  };
}
