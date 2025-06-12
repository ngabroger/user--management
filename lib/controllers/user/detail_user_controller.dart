import 'package:get/get.dart';
import 'package:user_management/data/provider/api_provider.dart';

class DetailUserController extends GetxController {
  final ApiProvider api = ApiProvider();
  var user = {}.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchUserDetail(int userId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await api.get('users/$userId');
      if (res.statusCode == 200) {
        user.value = res.data['user'] ?? {};
      } else {
        errorMessage.value = res.data['error'] ?? 'Gagal memuat detail user.';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
    }
    isLoading.value = false;
  }
}
