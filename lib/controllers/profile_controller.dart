import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile; // tambahkan hide
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_management/data/provider/api_provider.dart';
import 'package:dio/dio.dart';

class ProfileController extends GetxController {
  final ApiProvider api = ApiProvider();
  var isLoading = false.obs;
  var userData = {}.obs;
  var errorMessage = ''.obs;
  var errorMessageUpdate = ''.obs;
  final box = GetStorage();
  @override
  void onInit() {
    fetchUserProfile();
    super.onInit();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    final res = await api.get('profile');
    if (res.statusCode == 200) {
      userData.value = res.data ?? {};
      errorMessage.value = '';
    } else {
      userData.value = {};
      errorMessage.value = res.data['error'] ?? 'Gagal memuat profil pengguna.';
      Get.snackbar('Error', errorMessage.value);
    }
    isLoading.value = false;
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    isLoading.value = true;
    errorMessageUpdate.value = '';
    try {
      final res = await api.put('profile', {'name': name, 'email': email});
      dynamic responseData = res.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }
      if (res.statusCode == 200) {
        userData.value = responseData['user'] ?? {};
        Get.snackbar('Success', 'Profil berhasil diperbarui');
      } else {
        errorMessage.value =
            responseData['error'] ?? 'Gagal memperbarui profil.';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessageUpdate.value = 'Terjadi kesalahan: $e';
      Get.snackbar('Error', errorMessage.value);
    }
    isLoading.value = false;
  }

  Future<void> updateAvatar(File avatar) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        ),
      });
      final res = await api.postMultipart('profile/avatar', formData);
      dynamic responseData = res.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }
      if (res.statusCode == 200) {
        userData.value = responseData['user'] ?? {};
        Get.snackbar('Success', 'Avatar berhasil diperbarui');
      } else {
        errorMessageUpdate.value =
            responseData['error'] ?? 'Gagal memperbarui avatar.';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessageUpdate.value = 'Terjadi kesalahan: $e';

      Get.snackbar('Error', errorMessage.value);
    }
    isLoading.value = false;
  }

  Future<File?> pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      // Crop image
      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Avatar',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
          ),
          IOSUiSettings(title: 'Crop Avatar'),
        ],
      );
      if (cropped != null) {
        return File(cropped.path);
      }
    }
    return null;
  }

  Future<void> logOut() async {
    final res = await api.post('logout', {});
    if (res.statusCode == 200) {
      box.remove('token'); // Hapus token dari storage
      Get.offAllNamed('/login');
    } else {
      Get.snackbar('Error', 'Gagal logout, silakan coba lagi.');
    }
  }
}
