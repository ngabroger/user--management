import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/profile_controller.dart';

import 'edit_profile_dialog.dart';

class ProfileView extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (profileController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              profileController.errorMessage.value,
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        final user = profileController.userData;
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (user['avatar'] != null &&
                      user['avatar'].toString().isNotEmpty)
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(
                        user['avatar'].toString().startsWith('http')
                            ? user['avatar']
                            : 'http://10.0.2.2:8000/storage/${user['avatar']}',
                      ),
                    )
                  else
                    CircleAvatar(
                      radius: 48,
                      child: Text(
                        user['name'] != null && user['name'].isNotEmpty
                            ? user['name'][0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  SizedBox(height: 24),
                  Text(
                    user['name'] ?? '-',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user['email'] ?? '-',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.edit),
                        label: Text('Edit Profil'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => EditProfileDialog(
                              name: user['name'] ?? '',
                              email: user['email'] ?? '',
                              avatarUrl: user['avatar'],
                              onSave: (name, email, avatar) async {
                                await profileController.updateProfile(
                                  name: name,
                                  email: email,
                                );
                                if (avatar != null) {
                                  await profileController.updateAvatar(avatar);
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: Icon(Icons.logout),
                        label: Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          profileController.logOut();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
