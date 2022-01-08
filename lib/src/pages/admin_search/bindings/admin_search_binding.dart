import 'package:get/get.dart';

import '../controllers/admin_search_controller.dart';

class AdminSearchBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(AdminSearchController.new);
  }

}