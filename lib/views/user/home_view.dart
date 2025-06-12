import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/user/user_controller.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final UserController userController = Get.put(UserController());

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !userController.isMoreLoading.value &&
          userController.currentPage.value < userController.lastPage.value) {
        userController.loadMoreUsers();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Get.toNamed('/profile'),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari user...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    userController.fetchUsers(); // Reset ke semua user
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  userController.fetchUsersWithQuery({'search': value.trim()});
                } else {
                  userController.fetchUsers();
                }
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (userController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (userController.users.isEmpty) {
                return Center(child: Text('Tidak ada data user.'));
              }
              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount:
                    userController.users.length +
                    (userController.currentPage.value <
                            userController.lastPage.value
                        ? 1
                        : 0),
                itemBuilder: (context, index) {
                  if (index < userController.users.length) {
                    final user = userController.users[index];
                    final imageUrl = user['avatar'];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading:
                            (imageUrl != null && imageUrl.toString().isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                  imageUrl.toString().startsWith('http')
                                      ? imageUrl
                                      : 'http://10.0.2.2:8000/storage/$imageUrl',
                                ),
                              )
                            : CircleAvatar(
                                child: Text(
                                  user['name'] != null &&
                                          user['name'].isNotEmpty
                                      ? user['name'][0].toUpperCase()
                                      : '?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                        title: Text(user['name']),
                        subtitle: Text(user['email']),
                        onTap: () =>
                            Get.toNamed('/user-detail', arguments: user),
                      ),
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
