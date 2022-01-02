import 'package:get/get.dart';

import '../controllers/user_products_controller.dart';

class UserProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProductsController(
        userId: int.tryParse(Get.parameters['id'] ?? '') ?? 0));
  }
}
