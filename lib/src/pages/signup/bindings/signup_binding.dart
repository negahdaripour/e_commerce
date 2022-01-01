import 'package:get/get.dart';

import '../controllers/signup_controller.dart';

class SignupPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(SignupPageController.new);
  }
}
