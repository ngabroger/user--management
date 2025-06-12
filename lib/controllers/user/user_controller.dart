import 'package:get/get.dart';
import '../../data/provider/api_provider.dart';

class UserController extends GetxController {
  final ApiProvider api = ApiProvider();

  var users = <dynamic>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var perPage = 10.obs;
  var isMoreLoading = false.obs;
  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers({bool reset = false}) async {
    if (reset) {
      currentPage.value = 1;
      users.clear();
    }
    isLoading.value = reset;
    isMoreLoading.value = !reset;
    errorMessage.value = '';
    try {
      final res = await api.get(
        'users?page=${currentPage.value}&per_page=${perPage.value}',
      );
      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data'] ?? [];
        final int last = res.data['last_page'] ?? 1;
        if (reset) {
          users.value = data;
        } else {
          users.addAll(data);
        }
        lastPage.value = last;
        errorMessage.value = '';
      } else {
        if (reset) users.clear();
        errorMessage.value = res.data['error'] ?? 'Gagal memuat data pengguna.';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      Get.snackbar('Error', errorMessage.value);
    }
    isLoading.value = false;
    isMoreLoading.value = false;
  }

  Future<void> loadMoreUsers() async {
    if (currentPage.value < lastPage.value && !isMoreLoading.value) {
      isMoreLoading.value = true;
      currentPage.value += 1;
      await fetchUsers(reset: false);
      isMoreLoading.value = false;
    }
  }

  Future<void> refreshUsers() async {
    await fetchUsers(reset: true);
  }

  Future<void> fetchUsersWithQuery(Map<String, dynamic> query) async {
    isLoading.value = true;
    errorMessage.value = '';
    final res = await api.getWithQuery('users', query);

    if (res.statusCode == 200) {
      users.value = res.data['data'] ?? [];
      errorMessage.value = '';
    } else {
      users.value = [];
      errorMessage.value = res.data['error'] ?? 'Gagal memuat data pengguna.';
      Get.snackbar('Error', errorMessage.value);
    }
    isLoading.value = false;
  }
}
