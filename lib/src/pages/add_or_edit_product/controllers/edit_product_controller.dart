import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../models/product_dto.dart';
import '../models/product_view_model.dart';
import 'base_controller.dart';

class EditProductController extends BaseController {
  final int userId;

  EditProductController(this.userId);

  late String productPicture;

  @override
  Future<void> modify() async {
    await editProduct();
  }

  @override
  String get title => LocaleKeys.shared_edit_product.tr;

  @override
  String get pictureManipulationTitle => LocaleKeys.shared_edit_product.tr;

  Future<void> getProduct() async {
    loading.value = true;
    final ProductViewModel product =
        await addOrEditRepository.getProduct(userId);
    imageBytes.value = stringToImage(product.picture);
    titleTextController.text = product.title;
    countTextController.text = '${product.count}';
    productTags.value = product.tags;
    descriptionTextController.text = product.description;
    priceTextController.text = '${product.price}';
    inStock.value = product.inStock;
    isActive.value = product.isActive;
    (product.inStock)
        ? stock.value = LocaleKeys.shared_in_stock.tr
        : stock.value = LocaleKeys.shared_not_in_stock.tr;
    (product.isActive)
        ? active.value = LocaleKeys.shared_active.tr
        : active.value = LocaleKeys.shared_inactive.tr;

    productPicture = product.picture;
    loading.value = false;
  }

  Future<void> editProduct() async {
    String? picture;
    if (imageResult != null) {
      picture = imageToString(imageResult!);
    }
    final String title = titleTextController.text;
    final List<String> tags = productTags;
    final String description = descriptionTextController.text;
    final int? price = int.tryParse(priceTextController.text);
    final bool inStock = this.inStock.value;
    final bool isActive = this.isActive.value;
    final int? count = inStock ? int.tryParse(countTextController.text) : 0;

    final ProductDto productDto = ProductDto(
        picture: picture ?? productPicture,
        title: title,
        count: count ?? 0,
        tags: tags,
        description: description,
        price: price ?? 0,
        inStock: inStock,
        isActive: isActive);

    await addOrEditRepository.editProduct(userId, productDto);
  }

  Uint8List stringToImage(final String base64String) =>
      base64Decode(base64String);

  @override
  void onInit() async {
    super.onInit();
    await getProduct();
  }
}
