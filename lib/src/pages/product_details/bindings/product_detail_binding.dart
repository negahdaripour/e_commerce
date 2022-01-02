import 'package:get/get.dart';

import '../controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProductDetailController(
          productId: int.tryParse(Get.parameters['productId'] ?? '') ?? 0,
          userId: int.tryParse(Get.parameters['userId'] ?? '') ?? 0),
    );
  }
}
