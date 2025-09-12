import 'package:flutter/material.dart';
import '../models/building.dart';
import '../models/device.dart';
import '../models/space.dart';
import '../services/building_service.dart';
import '../services/device_service.dart';
import '../services/space_service.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final SpaceService spaceService = SpaceService();
  final BuildingService buildingService = BuildingService();

  List<Device> devices = [];
  List<Space> spaces = [];
  List<Building> buildings = [];
  List<String> selectedEquipment = [];
  int selectedCapacity = 0;

  final Color primaryGreen = const Color(0xFF168757);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final loadedDevices = await DeviceService().getDevices();
    final loadedSpaces = await spaceService.getSpaces();
    final loadedBuildings = await buildingService.getAllBuildings();
    loadedDevices.sort((a, b) {
      final regex = RegExp(r'(\d+)');
      final matchA = regex.firstMatch(a.roomName);
      final matchB = regex.firstMatch(b.roomName);

      final numA = matchA != null ? int.parse(matchA.group(0)!) : 0;
      final numB = matchB != null ? int.parse(matchB.group(0)!) : 0;

      return numA.compareTo(numB);
    });
    setState(() {
      devices = loadedDevices;
      spaces = loadedSpaces;
      buildings = loadedBuildings;
    });
  }

  void openDeviceForm(Device? device) {
    final deviceNameController =
    TextEditingController(text: device?.deviceName ?? '');
    final roomNameController =
    TextEditingController(text: device?.roomName ?? '');
    String? selectedLocation =
    device?.location?.isNotEmpty == true ? device!.location : null;
    final installDateController = TextEditingController(
        text: device?.installDate?.toIso8601String().split("T")[0] ?? ''
    );

    final locationItems = spaces.map((s) {
      final building = buildings.firstWhere(
            (b) => b.id == s.buildingId,
        orElse: () => Building(id: '', name: 'Unknown', address: ''),
      );
      return "${building.name} - ${s.floor}";
    }).toList();

    if (selectedLocation != null && !locationItems.contains(selectedLocation)) {
      selectedLocation = null;
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              device == null ? "Add Device" : "Edit Device",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: deviceNameController,
                    decoration: InputDecoration(
                      labelText: "Device Name",
                      prefixIcon: Icon(Icons.devices, color: primaryGreen),
                    ),
                  ),
                  TextField(
                    controller: roomNameController,
                    decoration: InputDecoration(
                      labelText: "Room Name",
                      prefixIcon: Icon(Icons.meeting_room, color: primaryGreen),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    items: locationItems
                        .map((loc) => DropdownMenuItem(
                      value: loc,
                      child: Text(loc),
                    ))
                        .toList(),
                    onChanged: (v) {
                      setStateDialog(() {
                        selectedLocation = v;
                        final selectedSpace = spaces.firstWhere(
                              (s) {
                            final building = buildings.firstWhere(
                                    (b) => b.id == s.buildingId,
                                orElse: () =>
                                    Building(id: '', name: '', address: ''));
                            return "${building.name} - ${s.floor}" == v;
                          },
                          orElse: () => Space(
                              id: '',
                              buildingId: '',
                              floor: '',
                              capacity: 0,
                              equipment: []),
                        );
                        selectedCapacity = selectedSpace.capacity;
                        selectedEquipment = selectedSpace.equipment;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Location",
                      prefixIcon:
                      Icon(Icons.location_on, color: primaryGreen),
                    ),
                    hint: const Text("Pilih lokasi"),
                  ),
                  TextField(
                    controller: installDateController,
                    decoration: InputDecoration(
                      labelText: "Install Date (YYYY-MM-DD)",
                      prefixIcon:
                      Icon(Icons.calendar_today, color: primaryGreen),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (deviceNameController.text.isEmpty ||
                      roomNameController.text.isEmpty ||
                      selectedLocation == null ||
                      installDateController.text.isEmpty) return;

                  final newDevice = Device(
                    id: device?.id ?? '',
                    deviceName: deviceNameController.text,
                    roomName: roomNameController.text,
                    location: selectedLocation ?? device?.location ?? '',
                    installDate: DateTime.parse(installDateController.text),
                    capacity: selectedCapacity != 0
                        ? selectedCapacity
                        : (device?.capacity ?? 0),
                    equipment: selectedEquipment.isNotEmpty
                        ? selectedEquipment
                        : (device?.equipment ?? []),
                    isOn: device?.isOn ?? false,
                  );

                  if (device == null) {
                    await DeviceService().createDevice(newDevice);
                  } else {
                    await DeviceService().updateDevice(newDevice);
                  }

                  Navigator.pop(context);
                  loadData();
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Devices"),
        centerTitle: true,
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: primaryGreen.withOpacity(0.1),
                child: Icon(Icons.devices, size: 28, color: primaryGreen),
              ),
              title: Text(
                "${device.deviceName} - ${device.roomName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: device.isOn ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      device.isOn ? "Status: ON" : "Status: OFF",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: device.isOn ? Colors.green : Colors.red,
                      ),
                    ),
                    Text(device.location.isEmpty
                        ? "📍 Location: Belum diisi"
                        : "📍 ${device.location}"),
                    Row(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.red, Colors.white],
                          ).createShader(bounds),
                          child: const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          device.installDate != null && device.installDate!.year > 2000
                              ? "Installed: Belum diisi"
                              : "Installed: ${device.installDate!.toIso8601String().split("T")[0]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Text(device.capacity! > 0
                        ? "👥 Capacity: ${device.capacity}"
                        : "👥 Capacity: Belum diisi"),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: -8,
                      children: device.equipment.isNotEmpty
                          ? device.equipment
                          .map((e) => Chip(
                        label: Text(
                          e,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor:
                        primaryGreen.withOpacity(0.08),
                        labelStyle: TextStyle(color: primaryGreen),
                        side:
                        BorderSide(color: primaryGreen),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                      ))
                          .toList()
                          : [const Text("Equipment: Belum diisi")],
                    ),
                  ],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: primaryGreen),
                    onPressed: () => openDeviceForm(device),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      await DeviceService().deleteDevice(device.id);
                      loadData();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        onPressed: () => openDeviceForm(null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
