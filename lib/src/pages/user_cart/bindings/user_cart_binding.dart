import 'package:get/get.dart';

import '../controllers/user_cart_controller.dart';

class UserCartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserCartController(
        userId: int.tryParse(Get.parameters['id'] ?? '') ?? 0));
  }
}
