import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../infrastructure/routes/e_commerce_route_names.dart';
import '../../shared/models/product_view_model.dart';
import '../repositories/search_product_repository.dart';

class AdminSearchController extends GetxController {
  SearchProductRepository searchProductRepository = SearchProductRepository();

  final TextEditingController searchTextController = TextEditingController();

  RxBool loading = true.obs;
  RxList<ProductViewModel> products = <ProductViewModel>[].obs;

  Uint8List stringToImage(final String base64String) =>
      base64Decode(base64String);

  Future<void> onSearchFieldSubmitted(final String searchString) async {
    loading.value = true;
    products.clear();

    final List<ProductViewModel> _products =
        await searchProductRepository.searchProducts(searchString);

    products.addAll(_products);

    loading.value = false;
  }

  void onProductPressed(final int id) async {
    final result = await Get.toNamed(ECommerceRouteNames.editProductPage,
        parameters: {'id': '$id'});
    if (result != null && result) {
      await onSearchFieldSubmitted(searchTextController.text);
    }
  }

  void productDeleteDialogResult(
      {required final bool result,
      required final ProductViewModel productViewModel}) {
    if (result) {
      deleteProduct(productViewModel);
    }
  }

  Future<void> deleteProduct(final ProductViewModel productViewModel) async {
    await searchProductRepository.deleteUProduct(productViewModel.id);
    products
      ..removeWhere((final product) => product.id == productViewModel.id)
      ..refresh();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    loading.value = false;
  }
}
