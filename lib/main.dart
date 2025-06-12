import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();
  final hasToken = box.hasData('token') && box.read('token') != null;
  runApp(MyApp(initialRoute: hasToken ? Routes.home : Routes.login));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(initialRoute: initialRoute, getPages: appPages);
  }
}
