import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../models/product_dto.dart';
import 'base_controller.dart';

class AddProductController extends BaseController {
  @override
  Future<void> modify() async {
    await addProduct();
  }

  Future<void> addProduct() async {
    final String picture = imageToString(imageResult!);
    final String title = titleTextController.text;
    final List<String> tags = productTags;
    final String description = descriptionTextController.text;
    final int? price = int.tryParse(priceTextController.text);
    final bool inStock = this.inStock.value;
    final bool isActive = this.isActive.value;
    final int? count = inStock ? int.tryParse(countTextController.text) : 0;

    final ProductDto productDto = ProductDto(
        picture: picture,
        title: title,
        count: count ?? 0,
        tags: tags,
        description: description,
        price: price ?? 0,
        inStock: inStock,
        isActive: isActive);

    await addOrEditRepository.addProduct(productDto);
  }

  @override
  String get title => LocaleKeys.shared_add_product.tr;

  @override
  String get pictureManipulationTitle =>
      LocaleKeys.shared_add_product_picture.tr;
}
