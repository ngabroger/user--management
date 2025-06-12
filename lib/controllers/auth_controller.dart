import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/provider/api_provider.dart';

class AuthController extends GetxController {
  final ApiProvider api = ApiProvider();
  final box = GetStorage();

  var isLoading = false.obs;
  var showPassword = false.obs;
  var showPasswordConfirm = false.obs;
  var dataToken = ''.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    final res = await api.post('login', {'email': email, 'password': password});
    isLoading.value = false;
    if (res.statusCode == 200) {
      box.write('token', res.data['token']);

      Get.offAllNamed('/home');
    } else {
      final errorMsg =
          res.data['error'] ?? res.data['message'] ?? 'Login gagal!';
      Get.snackbar('Error', errorMsg.toString());
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String retypePassword,
  ) async {
    isLoading.value = true;
    final res = await api.post('register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': retypePassword,
    });
    isLoading.value = false;
    if (res.statusCode == 201) {
      Get.snackbar('Sukses', 'Registrasi berhasil, silakan login.');
      Get.offAllNamed('/login');
    } else {
      final errorMsg =
          res.data['error'] ?? res.data['message'] ?? 'Register gagal!';
      Get.snackbar('Error', errorMsg.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    isLoading.value = true;
    final res = await api.post('forgot-password', {'email': email});
    isLoading.value = false;
    if (res.statusCode == 200) {
      Get.snackbar(
        'Sukses',
        res.data['message'] ?? 'Link reset password telah dikirim ke email.',
      );
      Get.back(); // Kembali ke halaman login
    } else {
      final errorMsg =
          res.data['error'] ??
          res.data['message'] ??
          'Gagal mengirim email reset password!';
      Get.snackbar('Error', errorMsg.toString());
    }
  }
}
