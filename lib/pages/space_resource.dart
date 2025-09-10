import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../models/building.dart';
import '../models/space.dart';
import '../services/building_service.dart';
import '../services/space_service.dart';

class SpaceResourcePage extends StatefulWidget {
  const SpaceResourcePage({super.key});

  @override
  _SpaceResourcePageState createState() => _SpaceResourcePageState();
}

class _SpaceResourcePageState extends State<SpaceResourcePage> {
  final SpaceService spaceService = SpaceService();
  final BuildingService buildingService = BuildingService();

  List<Space> spaces = [];
  List<Building> buildings = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  final Map<String, IconData> equipmentOptions = {
    "Meja": Icons.table_bar,
    "Kursi": Icons.chair,
    "Whiteboard": Icons.border_color,
    "Flipchart": Icons.edit_note,
    "Microphone": Icons.mic,
    "Speaker": Icons.speaker,
    "Sound System": Icons.surround_sound,
    "Headset": Icons.headset,
    "Proyektor": Icons.present_to_all,
    "Layar Proyektor": Icons.theaters,
    "TV": Icons.tv,
    "Video Conference": Icons.videocam,
    "Laptop": Icons.laptop_mac,
    "PC": Icons.computer,
    "Tablet": Icons.tablet,
    "HP": Icons.phone_android,
    "Printer": Icons.print,
    "WiFi": Icons.wifi,
    "LAN": Icons.settings_ethernet,
    "HDMI": Icons.cable,
    "Charger": Icons.power,
    "AC": Icons.ac_unit,
    "Lampu": Icons.light,
    "Jam": Icons.access_time,
    "Tirai": Icons.window,
    "Remote": Icons.settings_remote,
    "Name Tag": Icons.badge,
    "Air Minum": Icons.local_drink,
    "Snack": Icons.fastfood,
    "Dokumen": Icons.folder,
  };

  Future<void> loadData() async {
    final loadedSpaces = await spaceService.getSpaces();
    final loadedBuildings = await buildingService.getAllBuildings();
    setState(() {
      spaces = loadedSpaces;
      buildings = loadedBuildings;
    });
  }

  void openSpaceForm([Space? space]) {
    final floorController = TextEditingController(text: space?.floor ?? '');
    final capacityController =
    TextEditingController(text: space?.capacity.toString() ?? '');
    List<String> selectedEquipments = space?.equipment ?? [];
    String? selectedBuildingId = space?.buildingId;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          space == null ? "Add Space" : "Edit Space",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedBuildingId,
                items: buildings
                    .map((b) =>
                    DropdownMenuItem(value: b.id, child: Text(b.name)))
                    .toList(),
                onChanged: (v) => selectedBuildingId = v,
                decoration: InputDecoration(
                  labelText: "Building",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: floorController,
                decoration: InputDecoration(
                  labelText: "Floor",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: capacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Capacity",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              MultiSelectDialogField<String>(
                items: equipmentOptions.keys
                    .map((name) => MultiSelectItem<String>(name, name))
                    .toList(),
                initialValue: selectedEquipments,
                title: const Text("Select Equipment"),
                buttonText: const Text("Select Equipment"),
                listType: MultiSelectListType.LIST,
                onConfirm: (values) {
                  selectedEquipments = values;
                },
                chipDisplay: MultiSelectChipDisplay(
                  chipColor: Colors.green.shade100,
                  textStyle: const TextStyle(color: Colors.black),
                  icon: const Icon(Icons.close, size: 16),
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
            onPressed: () async {
              if (selectedBuildingId == null) return;

              final newSpace = Space(
                id: space?.id ?? '',
                buildingId: selectedBuildingId!,
                floor: floorController.text,
                capacity: int.tryParse(capacityController.text) ?? 0,
                equipment: selectedEquipments,
              );

              if (space == null) {
                await spaceService.createSpace(newSpace);
              } else {
                await spaceService.updateSpace(newSpace);
              }

              Navigator.pop(context);
              loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF168757),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentChips(List<String> equipment) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: equipment.map((e) {
        return Chip(
          avatar: Icon(
            equipmentOptions[e] ?? Icons.extension,
            size: 16,
            color: Colors.green.shade700,
          ),
          label: Text(e, style: const TextStyle(fontSize: 12)),
          backgroundColor: Colors.green.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Space & Resource",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
        backgroundColor: const Color(0xFF168757),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: spaces.length,
          itemBuilder: (context, index) {
            final space = spaces[index];
            final buildingName = buildings
                .firstWhere((b) => b.id == space.buildingId,
                orElse: () =>
                    Building(id: '', name: 'Unknown', address: ''))
                .name;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  buildingName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Floor: ${space.floor} • Capacity: ${space.capacity}",
                        style: TextStyle(color: Colors.grey.shade700)),
                    const SizedBox(height: 6),
                    _buildEquipmentChips(space.equipment),
                  ],
                ),
                trailing: Wrap(
                  spacing: 6,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => openSpaceForm(space),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await spaceService.deleteSpace(space.id);
                        loadData();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openSpaceForm(),
        backgroundColor: const Color(0xFF168757),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
