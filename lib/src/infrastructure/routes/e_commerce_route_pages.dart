import 'package:e_commerce/src/pages/search/bindings/search_binding.dart';
import 'package:get/get.dart';

import '../../pages/add_or_edit_product/bindings/add_product_binding.dart';
import '../../pages/add_or_edit_product/bindings/edit_product_binding.dart';
import '../../pages/add_or_edit_product/controllers/add_product_controller.dart';
import '../../pages/add_or_edit_product/controllers/edit_product_controller.dart';
import '../../pages/add_or_edit_product/views/add_or_edit_page.dart';
import '../../pages/admin_products/bindings/admin_products_binding.dart';
import '../../pages/admin_products/views/admin_products_page.dart';
import '../../pages/login/bindings/login_page_binding.dart';
import '../../pages/login/views/login_page.dart';
import '../../pages/product_details/bindings/product_detail_binding.dart';
import '../../pages/product_details/views/product_details_page.dart';
import '../../pages/search/views/search_page.dart';
import '../../pages/signup/bindings/signup_binding.dart';
import '../../pages/signup/views/signup_page.dart';
import '../../pages/splash/bindings/splash_page_binding.dart';
import '../../pages/splash/views/splash_page.dart';
import '../../pages/user_cart/bindings/user_cart_binding.dart';
import '../../pages/user_cart/views/user_cart_page.dart';
import '../../pages/user_products/bindings/user_products_binding.dart';
import '../../pages/user_products/views/user_products_page.dart';
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
    ),
    GetPage(
      name: ECommerceRouteNames.addProductPage,
      page: () => const AddOrEditPage<AddProductController>(),
      binding: AddProductBinding(),
    ),
    GetPage(
      name: ECommerceRouteNames.editProductPage,
      page: () => const AddOrEditPage<EditProductController>(),
      binding: EditProductBinding(),
    ),
    GetPage(
      name: ECommerceRouteNames.signupPage,
      page: () => const SignupPage(),
      binding: SignupPageBinding(),
    ),
    GetPage(
      name: ECommerceRouteNames.userProductsPage,
      page: () => const UserProductsPage(),
      binding: UserProductsBinding(),
    ),
    GetPage(
      name: ECommerceRouteNames.productDetailPage,
      page: () => const ProductDetailsPage(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: ECommerceRouteNames.userCartPage,
      page: () => const UserCartPage(),
      binding: UserCartBinding(),
    ),
    GetPage(
      name: ECommerceRouteNames.searchPage,
      page: () => const SearchPage(),
      binding: SearchBinding(),
    ),
  ];
}
