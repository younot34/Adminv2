import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_service.dart';
import 'HomePage.dart';

class ReportingPage extends StatefulWidget {
  const ReportingPage({super.key});

  @override
  _ReportingPageState createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  final DeviceFirestoreService deviceService = DeviceFirestoreService();
  List<Device> devices = [];
  List<String> allRooms = [];

  @override
  void initState() {
    super.initState();
    loadDevices();
  }

  Future<void> loadDevices() async {
    final devices = await deviceService.getDevices();
    devices.sort((a, b) {
      final regex = RegExp(r'(\d+)');
      final na = int.tryParse(regex.firstMatch(a.roomName)?.group(0) ?? "0") ?? 0;
      final nb = int.tryParse(regex.firstMatch(b.roomName)?.group(0) ?? "0") ?? 0;
      return na.compareTo(nb);
    });
    setState(() {
      this.devices = devices;
      allRooms = devices.map((d) => d.roomName).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking Report",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF168757),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: allRooms.length,
        itemBuilder: (context, index) {
          final room = allRooms[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 2,
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF168757),
                child: Icon(Icons.meeting_room, color: Colors.white),
              ),
              title: Text(
                room,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(roomName: room),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}