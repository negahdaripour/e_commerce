import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../shared/models/user_view_model.dart';
import '../repositories/login_repository.dart';

class LoginPageController extends GetxController {
  LoginRepository loginRepository = LoginRepository();

  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<UserViewModel> users = [];
  String? usernameValidation;
  String? passwordValidation;

  UserViewModel? currentUser;

  Future<void> getUsers() async {
    users = await loginRepository.getUsers();
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

  @override
  void onInit() async {
    super.onInit();
    await getUsers();
  }
}
