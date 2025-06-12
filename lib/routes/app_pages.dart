import 'package:get/get.dart';
import '../views/auth/forgot_password.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/user/home_view.dart';
import '../views/profile/profile_view.dart';
import '../views/user/user_detail_view.dart';
import 'app_routes.dart';

final appPages = [
  GetPage(name: Routes.login, page: () => LoginView()),
  GetPage(name: Routes.register, page: () => RegisterView()),
  GetPage(
    name: Routes.forgotPassword,
    page: () => ForgotPasswordView(),
  ),
  GetPage(name: Routes.home, page: () => HomeView()),
  GetPage(name: Routes.profile, page: () => ProfileView()),
  GetPage(
    name: Routes.userDetail,
    page: () => UserDetailView(user: Get.arguments),
  ),
];
