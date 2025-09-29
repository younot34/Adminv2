import 'package:admin/pages/HistoryPage.dart';
import 'package:flutter/material.dart';

import '../pages/building_page.dart';
import '../pages/device_page.dart';
import '../pages/mediaLibrary_page.dart';
import '../pages/reporting_page.dart';
import '../pages/space_resource.dart';
import '../pages/userPage.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onSelectMenu;

  const Sidebar({super.key, required this.onSelectMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2C),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header / Branding
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Color(0xFF27293D),
            ),
            child: const Text(
              "Admin Panel",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Menu Items
          Expanded(
            child: ListView(
              children: [
                _menuButton(context, "Building", Icons.apartment),
                _menuButton(context, "Space & Resource", Icons.meeting_room),
                _menuButton(context, "Device", Icons.devices),
                _menuButton(context, "Media Library", Icons.perm_media),
                _menuButton(context, "Booking", Icons.library_books_outlined),
                _menuButton(context, "User", Icons.person),
                _menuButton(context, "History", Icons.schedule),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[300]),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      horizontalTitleGap: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hoverColor: Colors.white10,
      onTap: () {
        switch (title) {
          case "Building":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BuildingPage()),
            );
            break;
          case "Space & Resource":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SpaceResourcePage()),
            );
            break;
          case "Device":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DevicePage()),
            );
            break;
          case "Media Library":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MediaLibraryPage()),
            );
            break;
          case "Booking":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportingPage()),
            );
            break;
          case "User":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserPage()),
            );
            break;
          case "History":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryPage()),
            );
            break;
        }
      },
    );
  }
}
