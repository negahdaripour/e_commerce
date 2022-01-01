import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../generated/locales.g.dart';
import '../../shared/models/user_dto.dart';
import '../../shared/models/user_view_model.dart';
import '../repositories/signup_repository.dart';

class SignupPageController extends GetxController {
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
    return isInDB ? 'نام کاربری تکراری است' : null;
  }

  String? checkPasswordQuality(final String value) {
    if (value.length < 6) {
      return 'رمزعبور با حداقل طول 6';
    }
    //TODO add more requirements
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
      repeatPasswordValidation ??= 'اول رمزعبور را وارد کنید';
    }
    if (repeatPasswordValidation == null) {
      if (value != password) {
        repeatPasswordValidation ??= 'رمزعبور مطابقت ندارد';
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

  @override
  void onInit() async {
    super.onInit();
    imagePicker = ImagePicker();
    await getUsers();
  }
}
