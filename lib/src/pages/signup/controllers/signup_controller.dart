import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../generated/locales.g.dart';
import '../models/user_dto.dart';
import '../models/user_view_model.dart';
import '../repositories/signup_repository.dart';

class SignupPageController extends GetxController {
  RxBool showPassword = false.obs;
  RxBool showPasswordRepeat = false.obs;
  RxBool loading = true.obs;
  SignupRepository signupRepository = SignupRepository();

  File? imageResult;
  Rxn<Uint8List> imageBytes = Rxn();
  late ImagePicker imagePicker;

  void getImageResult(final ImageSource source) async {
    final XFile? image = await imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      imageResult = File(image.path);
      imageBytes.value = imageResult!.readAsBytesSync();
      Get.back();
    }
  }

  String imageToString(final File image) {
    final List<int> imageBytes = image.readAsBytesSync();
    return base64.encode(imageBytes);
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();

  List<UserViewModel> users = [];
  String? usernameValidation;
  String? passwordValidation;
  String? repeatPasswordValidation;
  String? password;

  Future<void> getUsers() async {
    users = await signupRepository.getUsers();
    loading.value = false;
  }

  String? checkEmptyField(final String? text) {
    if (text == null || text.isEmpty) {
      return LocaleKeys.shared_do_not_leave_field_empty.tr;
    }
    return null;
  }

  String? checkUsernameNotInDB(final String? value) {
    bool isInDB = false;
    for (final element in users) {
      if (element.username == value) {
        isInDB = true;
      }
    }
    return isInDB ? LocaleKeys.shared_username_already_exists.tr : null;
  }

  String? checkPasswordQuality(final String value) {
    if (value.length < 6) {
      return LocaleKeys.shared_password_length_atLeast_6.tr;
    }
  }

  String? validateUsername(final String? value) {
    usernameValidation = checkEmptyField(value);
    usernameValidation ??= checkUsernameNotInDB(value);
    return usernameValidation;
  }

  String? validatePassword(final String? value) {
    passwordValidation = checkEmptyField(value);
    passwordValidation ??= checkPasswordQuality(value!);
    if (passwordValidation == null) {
      password = value;
    }
    return passwordValidation;
  }

  String? validateRepeatedPassword(final String? value) {
    repeatPasswordValidation = checkEmptyField(value);
    if (passwordController.text.isEmpty) {
      repeatPasswordValidation ??= LocaleKeys.shared_enter_password.tr;
    }
    if (repeatPasswordValidation == null) {
      if (value != password) {
        repeatPasswordValidation ??=
            LocaleKeys.shared_password_does_not_match_username.tr;
      }
    }
    return repeatPasswordValidation;
  }

  Future<void> addUser() async {
    final String firstname = firstnameController.text;
    final String lastname = lastnameController.text;
    final String username = usernameController.text;
    final String address = addressController.text;

    final UserDto userDto = UserDto(
        picture: imageToString(imageResult!),
        firstname: firstname,
        lastname: lastname,
        username: username,
        password: password!,
        address: address,
        isAdmin: false,
        favourites: [],
        cart: []);

    await signupRepository.addUser(userDto);
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void togglePasswordRepeatVisibility() {
    showPasswordRepeat.value = !showPasswordRepeat.value;
  }

  @override
  void onClose() {
    firstnameController.dispose();
    lastnameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    addressController.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    imagePicker = ImagePicker();
    await getUsers();
  }
}
