import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../services/device_service.dart';
import '../services/booking_service.dart';
import '../widgets/sidebar.dart';
import '../models/device.dart';
import '../models/booking.dart';
import 'BookingTile.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedMenu = "Reporting";
  String? selectedRoom;
  DateTime? selectedDate;
  final BookingService bookingService = BookingService();

  @override
  void initState() {
    super.initState();
  }
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  DateTime? parseBookingDate(String dateStr) {
    try {
      if (dateStr.contains("T")) {
        return DateTime.parse(dateStr).toLocal();
      }

      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
        return DateTime.parse(dateStr).toLocal();
      }

      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }

      return null;
    } catch (e) {
      debugPrint("ERROR parseBookingDate: $dateStr ($e)");
      return null;
    }
  }

  void _onSelectMenu(String menu) {
    setState(() {
      selectedMenu = menu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Row(
        children: [
          Sidebar(onSelectMenu: _onSelectMenu),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _buildMainContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header + filter
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 12,
          children: [
            const Text(
              "Reporting Dashboard",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(width: 400),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // room filter
                FutureBuilder<List<Device>>(
                  future: DeviceService().getDevices(),
                  builder: (context, snapshot) {
                    var devices = snapshot.data ?? [];
                    devices.sort((a, b) {
                      final regex = RegExp(r'(\d+)');
                      final matchA = regex.firstMatch(a.roomName);
                      final matchB = regex.firstMatch(b.roomName);

                      final numA = matchA != null ? int.parse(matchA.group(0)!) : 0;
                      final numB = matchB != null ? int.parse(matchB.group(0)!) : 0;

                      return numA.compareTo(numB);
                    });
                    return DropdownButton<String>(
                      hint: const Text("Filter Room"),
                      value: selectedRoom,
                      items: devices
                          .map((d) => DropdownMenuItem(
                        value: d.roomName,
                        child: Text(d.roomName),
                      ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedRoom = val;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(width: 12),
                // date filter
                OutlinedButton.icon(
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
                      });
                    }
                  },
                ),
                const SizedBox(width: 12),
                // reset filter
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  tooltip: "Reset Filter",
                  onPressed: () {
                    setState(() {
                      selectedRoom = null;
                      selectedDate = null;
                    });
                  },
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),

        // dashboard content
        Expanded(
          child: FutureBuilder<List<Device>>(
            future: DeviceService().getDevices(),
            builder: (context, deviceSnapshot) {
              var devices = deviceSnapshot.data ?? [];
              devices.sort((a, b) {
                final regex = RegExp(r'(\d+)');
                final matchA = regex.firstMatch(a.roomName);
                final matchB = regex.firstMatch(b.roomName);

                final numA = matchA != null ? int.parse(matchA.group(0)!) : 0;
                final numB = matchB != null ? int.parse(matchB.group(0)!) : 0;

                return numA.compareTo(numB);
              });

              if (devices.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return FutureBuilder<Map<String, List<Booking>>>(
                future: _bookingsByDeviceFuture(devices),
                builder: (context, bookingSnapshot) {
                  final bookingsByRoom = bookingSnapshot.data ?? {};
                  return ListView(
                    children: devices.map((device) {
                      final room = device.roomName;

                      // filter room
                      if (selectedRoom != null && selectedRoom != room) {
                        return const SizedBox.shrink();
                      }

                      final bookings = bookingsByRoom[room] ?? [];

                      // filter date
                      final filteredBookings = bookings.where((b) {
                        if (selectedDate == null) return true;

                        final bookingDate = parseBookingDate(b.date);
                        debugPrint("CHECK => raw=${b.date}, parsed=$bookingDate, selected=$selectedDate");

                        return bookingDate != null && isSameDay(bookingDate, selectedDate!);
                      }).toList();

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
                              Row(
                                children: [
                                  const Icon(Icons.meeting_room,
                                      color: Color(0xFF3949AB), size: 28),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${device.roomName} ",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3949AB)),
                                  ),
                                  Text(
                                    "(${device.deviceName})",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const Divider(height: 20, thickness: 1),
                              if (filteredBookings.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "No bookings found",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              else
                                ...filteredBookings.map((b) => BookingTile(booking: b)).toList()
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Stream gabungan semua booking per device
  Future<Map<String, List<Booking>>> _bookingsByDeviceFuture(List<Device> devices) async {
    final map = <String, List<Booking>>{};
    for (var device in devices) {
      final bookings = await bookingService.getBookingsByRoom(device.roomName);
      map[device.roomName] = bookings;
    }
    return map;
  }
}