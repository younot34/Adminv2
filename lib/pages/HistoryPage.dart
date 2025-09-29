import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> allHistory = [];
  Map<String, List<dynamic>> groupedHistory = {};
  List<String> roomList = [];

  String? selectedRoom;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final response =
        await http.get(Uri.parse("https://a-meet.cloud/api/history"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      for (var item in data) {
        // Format date jadi YYYY-MM-DD
        if (item['date'] != null) {
          item['date'] = item['date'].toString().split("T")[0];
        }
        // Ubah status jadi Finished
        item['status'] = "Finished";
      }

      setState(() {
        allHistory = data;
        roomList = data
            .map<String>((e) => (e['room_name'] ?? "Unknown Room").toString())
            .toSet()
            .toList();
      });

      applyFilter();
    } else {
      debugPrint("Failed to load history: ${response.statusCode}");
    }
  }

  void applyFilter() {
    Map<String, List<dynamic>> grouped = {};

    for (var item in allHistory) {
      final roomName = (item['room_name'] ?? 'Unknown Room').toString();

      // filter room
      if (selectedRoom != null && selectedRoom != roomName) continue;

      // filter tanggal
      if (selectedDate != null) {
        final itemDate = DateTime.tryParse(item['date']);
        if (itemDate == null) continue;
        if (itemDate.year != selectedDate!.year ||
            itemDate.month != selectedDate!.month ||
            itemDate.day != selectedDate!.day) continue;
      }

      grouped.putIfAbsent(roomName, () => []);
      grouped[roomName]!.add(item);
    }

    setState(() {
      groupedHistory = grouped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: const Color(0xFF168757),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // FILTER
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Room filter
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    decoration: const InputDecoration(
                      labelText: "Filter Room",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedRoom,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text("All Rooms"),
                      ),
                      ...roomList.map(
                        (room) => DropdownMenuItem<String?>(
                          value: room,
                          child: Text(room),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = value;
                        applyFilter();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // Date filter
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(selectedDate == null
                        ? "Pilih Tanggal"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                          applyFilter();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Reset filter
                IconButton(
                  tooltip: "Reset filter",
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      selectedRoom = null;
                      selectedDate = null;
                      applyFilter();
                    });
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          // LIST HISTORY
          Expanded(
            child: groupedHistory.isEmpty
                ? const Center(child: Text("No history found"))
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: groupedHistory.entries.map((entry) {
                      final roomName = entry.key;
                      final histories = entry.value;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header room
                              Row(
                                children: [
                                  const Icon(Icons.meeting_room,
                                      color: Color(0xFF3949AB), size: 28),
                                  const SizedBox(width: 10),
                                  Text(
                                    roomName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3949AB)),
                                  ),
                                ],
                              ),
                              const Divider(height: 20, thickness: 1),

                              // List history
                              if (histories.isEmpty)
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "No history found",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              else
                                ...histories.map((h) {
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 1,
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        backgroundColor: Color(0xFF3949AB),
                                        child: Icon(Icons.event,
                                            color: Colors.white, size: 20),
                                      ),
                                      title: Text(
                                        h['meeting_title'] ?? "No Title",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                          "${h['date']} • ${h['time']} • Host: ${h['host_name'] ?? 'Unknown'}"),
                                      trailing: Text(
                                        h['status'] ?? "",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
