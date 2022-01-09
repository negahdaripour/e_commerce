import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../infrastructure/routes/e_commerce_route_names.dart';
import '../models/user_view_model.dart';
import '../repositories/login_repository.dart';

class LoginPageController extends GetxController {
  RxBool loading = true.obs;
  RxBool showPassword = false.obs;
  RxString language = 'english'.obs;
  LoginRepository loginRepository = LoginRepository();

  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<UserViewModel> users = [];
  String? usernameValidation;
  String? passwordValidation;

  UserViewModel? currentUser;

  Future<void> getUsers() async {
    users.clear();
    final result = await loginRepository.getUsers();
    result.fold((final left) => left, (final right) => users = right);
    loading.value = false;
  }

  String? checkEmptyField(final String? text) {
    if (text == null || text.isEmpty) {
      return LocaleKeys.shared_do_not_leave_field_empty.tr;
    }
    return null;
  }

  String? checkUsernameInDB(final String? text) {
    try {
      currentUser = users.firstWhere((final user) => user.username == text);
    } catch (e) {
      currentUser = null;
    }
    return (currentUser != null)
        ? null
        : LocaleKeys.shared_username_not_found.tr;
  }

  String? checkPasswordValidation(final String? text) {
    if (currentUser == null) {
      return LocaleKeys.shared_password_not_found.tr;
    }
    return (currentUser!.password == text)
        ? null
        : LocaleKeys.shared_password_does_not_match_username.tr;
  }

  void validateUsername(final String? value) {
    usernameValidation = checkEmptyField(value);
    usernameValidation ??= checkUsernameInDB(value);
  }

  void validatePassword(final String? value) {
    passwordValidation = checkEmptyField(value);
    passwordValidation ??= checkPasswordValidation(value);
  }

  void onSignupPressed() async {
    final result = await Get.toNamed(ECommerceRouteNames.signupPage);
    if (result != null && result) {
      await getUsers();
    }
  }

  void onLoginPressed() async {
    if (currentUser!.isAdmin) {
      await Get.offNamed(ECommerceRouteNames.adminProductsPage);
    } else {
      await Get.offNamed(ECommerceRouteNames.userProductsPage,
          parameters: {'id': '${currentUser!.id}'});
    }
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  @override
  void onClose() {
    usernameTextController.dispose();
    passwordTextController.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    await getUsers();
  }
}
