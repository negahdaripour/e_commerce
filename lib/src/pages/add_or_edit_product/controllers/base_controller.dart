import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../generated/locales.g.dart';
import '../../shared/models/product_view_model.dart';
import '../repositories/add_or_edit_repository.dart';

abstract class BaseController extends GetxController {
  String get title;
  String get pictureManipulationTitle;

  File? imageResult;
  Rxn<Uint8List> imageBytes = Rxn();
  late ImagePicker imagePicker;

  final RxBool loading = false.obs;

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

  final titleAndCountFormKey = GlobalKey<FormState>();
  final descriptionAndPriceFormKey = GlobalKey<FormState>();
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController countTextController = TextEditingController();
  final TextEditingController descriptionTextController =
      TextEditingController();
  final TextEditingController priceTextController = TextEditingController();
  late TextEditingController tagsTextController;

  final AddOrEditRepository addOrEditRepository = AddOrEditRepository();

  RxBool inStock = false.obs;
  RxBool isActive = true.obs;

  RxString stock = LocaleKeys.shared_not_in_stock.tr.obs;
  RxString active = LocaleKeys.shared_active.tr.obs;

  List<String> allTags = [];

  RxList<String> productTags = <String>[].obs;

  String? checkEmptyField(final String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.shared_do_not_leave_field_empty.tr;
    }
    return null;
  }

  String? checkInputContainsNumber(final String value) {
    if (int.tryParse(value) == null) {
      return LocaleKeys.shared_only_numbers_between_zero_and_nine.tr;
    }
    return null;
  }

  String? validateProductInfo(final String? value) {
    final result = checkEmptyField(value);
    if (result == null) {
      return checkInputContainsNumber(value!);
    }
    return result;
  }

  Future<void> getProducts() async {
    final List<ProductViewModel> products =
        await addOrEditRepository.getProducts();
    for (final e in products) {
      for (final tag in e.tags) {
        if (!allTags.contains(tag)) {
          allTags.add(tag);
        }
      }
    }
  }

  void autoCompleteOnSubmitted(final String value) {
    if (!productTags.contains(value)) {
      productTags.add(value);
    }
    tagsTextController.clear();
  }

  Future<void> modify();

  @override
  void onClose() {
    titleTextController.dispose();
    countTextController.dispose();
    descriptionTextController.dispose();
    priceTextController.dispose();
    tagsTextController.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    imagePicker = ImagePicker();
    await getProducts();
  }
}
