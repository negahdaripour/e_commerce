import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController(
        userId: int.tryParse(Get.parameters['id'] ?? '') ?? 0));
  }
}
