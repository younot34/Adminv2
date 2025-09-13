import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/media.dart';
import '../services/media_service.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';


class MediaLibraryPage extends StatefulWidget {
  const MediaLibraryPage({super.key});

  @override
  _MediaLibraryPageState createState() => _MediaLibraryPageState();
}

class _MediaLibraryPageState extends State<MediaLibraryPage> {
  final MediaService mediaService = MediaService();
  List<Media> mediaList = [];


  @override
  void initState() {
    super.initState();
    loadMedia();
  }

  Future<void> loadMedia() async {
    final data = await mediaService.getAllMedia();
    setState(() {
      mediaList = data;
    });
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted ||
        await Permission.photos.request().isGranted) {
      print("Permission granted ✅");
    } else {
      print("Permission denied ❌");
    }
  }

  Widget buildImage(String base64Image) {
    final bytes = base64Decode(base64Image);
    return Image.memory(bytes, fit: BoxFit.cover);
  }

  void openMediaForm([Media? media]) {
    String? logoBase64 = media?.logoUrl;
    String? subLogoBase64 = media?.subLogoUrl;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(media == null ? "Add Media" : "Edit Media"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _buildImagePicker(
                    label: "Logo",
                    base64Image: logoBase64,
                    onPick: (base64) => setStateDialog(() => logoBase64 = base64),
                  ),
                  const SizedBox(height: 16),
                  _buildImagePicker(
                    label: "Sub Logo",
                    base64Image: subLogoBase64,
                    onPick: (base64) => setStateDialog(() => subLogoBase64 = base64),
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
                  if (media == null) {
                    await mediaService.createMedia(Media(
                      id: '',
                      logoUrl: logoBase64 ?? '',
                      subLogoUrl: subLogoBase64 ?? '',
                    ));
                  } else {
                    await mediaService.updateMedia(Media(
                      id: media.id,
                      logoUrl: logoBase64 ?? '',
                      subLogoUrl: subLogoBase64 ?? '',
                    ));
                  }
                  Navigator.pop(context);
                  loadMedia();
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    String? base64Image,
    required Function(String base64) onPick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            await requestStoragePermission();
            final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (picked != null) {
              final bytes = await picked.readAsBytes();
              final base64 = base64Encode(bytes);
              onPick(base64);
            }
          },
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: base64Image != null && base64Image.isNotEmpty
                ? buildImage(base64Image)
                : const Center(child: Icon(Icons.add_a_photo, size: 40)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Media Library"),
        backgroundColor: const Color(0xFF168757),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: mediaList.isEmpty
          ? const Center(child: Text("No media available"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: mediaList.length,
        itemBuilder: (context, index) {
          final item = mediaList[index];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            child: ListTile(
              leading: item.logoUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: buildImage(item.logoUrl)
              ): const Icon(Icons.image, size: 40, color: Colors.grey),
              title: const Text("Media Item"),
              subtitle: item.subLogoUrl.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(top: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: buildImage(item.subLogoUrl),
                ),
              )
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueGrey),
                    onPressed: () => openMediaForm(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await mediaService.deleteMedia(item.id);
                      loadMedia();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF168757),
        onPressed: () => openMediaForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
