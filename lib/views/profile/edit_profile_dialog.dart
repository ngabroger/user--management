import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';

class EditProfileDialog extends StatefulWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final Function(String, String, File?) onSave;

  const EditProfileDialog({
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.onSave,
    super.key,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  File? avatarFile;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profil'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                // Gunakan controller dari Get
                final controller = Get.find<ProfileController>();
                final picked = await controller.pickAvatar();
                if (picked != null) {
                  setState(() {
                    avatarFile = picked;
                  });
                }
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage: avatarFile != null
                    ? FileImage(avatarFile!)
                    : (widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty
                              ? NetworkImage(widget.avatarUrl!)
                              : null)
                          as ImageProvider<Object>?,
                child:
                    avatarFile == null &&
                        (widget.avatarUrl == null || widget.avatarUrl!.isEmpty)
                    ? Icon(Icons.camera_alt, size: 32)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              nameController.text,
              emailController.text,
              avatarFile,
            );
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}
