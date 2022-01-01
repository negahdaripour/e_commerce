import 'package:get/get.dart';

import '../../../infrastructure/routes/e_commerce_route_names.dart';
import '../../shared/models/user_dto.dart';
import '../../shared/models/user_view_model.dart';
import '../repositories/splash_page_repository.dart';

class SplashPageController extends GetxController {
  SplashRepository splashRepository = SplashRepository();
  UserDto? currentUser;
  List<UserViewModel> users = [];

  Future<void> getUsers() async {
    users = await splashRepository.getUsers();
  }

  bool checkUserRole() {
    if (currentUser != null) {
      if (currentUser!.isAdmin) {
        //TODO go to login page OR the admin products page
        return true;
      }
      return false;
    }
    return false;
  }

  UserDto createFirstAdmin() => UserDto(
      picture: '',
      firstname: '',
      lastname: '',
      username: 'admin',
      password: '123456',
      address: '',
      isAdmin: true,
      favourites: [],
      cart: []);

  @override
  void onInit() async {
    await Future.delayed(const Duration(seconds: 1));
    super.onInit();
    await getUsers();
    if (users.isEmpty) {
      currentUser = createFirstAdmin();
      await splashRepository.addUser(currentUser!);
    }
    await Get.offNamed(ECommerceRouteNames.loginPage);
  }
}
