import 'package:get/get.dart';
import '../../screens/main/main_screen.dart';
import '../../screens/login_screen.dart';

class AppPages {
  static const login = '/login';
  static const home = '/';

  static final routes = [
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: home, page: () => const MainScreen()),
  ];
}
