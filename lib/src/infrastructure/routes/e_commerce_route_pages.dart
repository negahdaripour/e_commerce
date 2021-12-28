import 'package:get/get.dart';

import '../../pages/admin_products/bindings/admin_products_binding.dart';
import '../../pages/admin_products/views/admin_products_page.dart';
import '../../pages/login/bindings/login_page_binding.dart';
import '../../pages/login/views/login_page.dart';
import '../../pages/splash/bindings/splash_page_binding.dart';
import '../../pages/splash/views/splash_page.dart';
import 'e_commerce_route_names.dart';

class ECommerceRoutePage {
  bool forDisableWarning() => true;
  static List<GetPage> routes = [
    GetPage(
      name: ECommerceRouteNames.splashPage,
      page: SplashPage.new,
      binding: SplashPageBinding(),
    ),
    GetPage(
      name: ECommerceRouteNames.loginPage,
      page: () => const LoginPage(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: ECommerceRouteNames.adminProductsPage,
      page: () => const AdminProductsPage(),
      binding: AdminProductsBinding(),
    )
  ];
}
