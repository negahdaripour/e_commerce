import 'package:get/get.dart';

import '../../pages/login/views/login_page.dart';
import 'e_commerce_route_names.dart';

class ECommerceRoutePage {
  bool forDisableWarning() => true;
  static List<GetPage> routes = [
    GetPage(
      name: ECommerceRouteNames.loginPage,
      page: () => const LoginPage(),
    ),
  ];
}
