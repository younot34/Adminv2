import 'package:flutter/material.dart';
import '../models/building.dart';
import '../services/building_service.dart';

class BuildingPage extends StatefulWidget {
  @override
  _BuildingPageState createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage> {
  final BuildingService _service = BuildingService();
  List<Building> buildings = [];

  final nameController = TextEditingController();
  final addressController = TextEditingController();

  Building? editingBuilding; // <--- simpan state kalau lagi edit

  @override
  void initState() {
    super.initState();
    _loadBuildings();
  }

  void _loadBuildings() async {
    buildings = await _service.getAllBuildings();
    setState(() {});
  }

  void _addOrUpdateBuilding() async {
    final name = nameController.text;
    final address = addressController.text;
    if (name.isEmpty || address.isEmpty) return;

    if (editingBuilding == null) {
      // mode tambah
      final newBuilding = Building(
        id: '',
        name: name,
        address: address,
      );
      await _service.create(newBuilding);
    } else {
      // mode edit
      final updated = Building(
        id: editingBuilding!.id,
        name: name,
        address: address,
      );
      await _service.update(updated);
      editingBuilding = null; // reset mode edit
    }

    nameController.clear();
    addressController.clear();
    _loadBuildings();
  }

  void _deleteBuilding(String id) async {
    await _service.delete(id);
    _loadBuildings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Building Management",
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 2,
        backgroundColor: const Color(0xFF168757),
        foregroundColor: Colors.white,
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Add / Edit
                SizedBox(
                  width: 320,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              editingBuilding == null
                                  ? "Add Building"
                                  : "Edit Building",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF168757),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: "Building Name",
                                prefixIcon: const Icon(Icons.apartment),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                labelText: "Address",
                                prefixIcon: const Icon(Icons.location_on),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _addOrUpdateBuilding,
                                icon: Icon(editingBuilding == null
                                    ? Icons.add
                                    : Icons.save),
                                label: Text(editingBuilding == null
                                    ? "Add Building"
                                    : "Update Building"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF168757),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // List Building
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Building List",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF168757),
                            ),
                          ),
                          const Divider(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: buildings.length,
                              itemBuilder: (context, index) {
                                final b = buildings[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0xFF168757),
                                      child: Text(
                                        b.name.isNotEmpty ? b.name[0].toUpperCase() : "?",
                                        style: const TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                    title: Text(
                                      b.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      b.address,
                                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                    ),
                                    trailing: Wrap(
                                      spacing: 6,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                          onPressed: () {
                                            setState(() {
                                              editingBuilding = b;
                                              nameController.text = b.name;
                                              addressController.text = b.address;
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                                          onPressed: () => _deleteBuilding(b.id),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}