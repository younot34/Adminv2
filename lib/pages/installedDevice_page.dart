import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_service.dart';

class InstalledDevicePage extends StatefulWidget {
  const InstalledDevicePage({super.key});

  @override
  _InstalledDevicePageState createState() => _InstalledDevicePageState();
}

class _InstalledDevicePageState extends State<InstalledDevicePage> {
  final DeviceFirestoreService deviceService = DeviceFirestoreService();
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    loadDevices();
  }

  Future<void> loadDevices() async {
    final loadedDevices = await deviceService.getDevices();
    setState(() {
      devices = loadedDevices;
    });
  }

  void openDeviceDetail(Device device) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(device.deviceName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Room: ${device.roomName}"),
            Text("Location: ${device.location}"),
            Text("Installed: ${device.installDate.toIso8601String().split('T')[0]}"),
            Text("Capacity: ${device.capacity}"),
            Text("Equipment: ${device.equipment.join(', ')}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schedule")),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            title: Text(device.deviceName),
            subtitle: Text(device.roomName),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => openDeviceDetail(device),
          );
        },
      ),
    );
  }
}
