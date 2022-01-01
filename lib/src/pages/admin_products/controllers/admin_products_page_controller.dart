import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../infrastructure/routes/e_commerce_route_names.dart';
import '../../shared/models/product_view_model.dart';
import '../repositories/admin_products_repository.dart';

class AdminProductsController extends GetxController {
  RxBool loading = true.obs;
  AdminProductsRepository adminProductsRepository = AdminProductsRepository();

  RxList<ProductViewModel> products = <ProductViewModel>[].obs;

  Future<void> getProducts() async {
    final _products = await adminProductsRepository.getProducts();
    loading.value = false;
    products.addAll(_products);
  }

  Future<void> deleteProduct(final ProductViewModel productViewModel) async {
    await adminProductsRepository.deleteUProduct(productViewModel.id);
    products.removeWhere((final product) => product.id == productViewModel.id);
    products.refresh();
  }

  Future<void> refreshProduct() async {
    clearProducts();
    loading.value = true;
    await getProducts();
  }

  void clearProducts() {
    products.clear();
  }

  void productDeleteDialogResult(
      {required final bool result,
      required final ProductViewModel productViewModel}) {
    if (result) {
      deleteProduct(productViewModel);
    }
  }

  void onAddPressed() async {
    final result = await Get.toNamed(ECommerceRouteNames.addProductPage);
    if (result != null && result) {
      await getProducts();
    }
  }

  void onProductPressed(final ProductViewModel productViewModel) async {
    final result = await Get.toNamed(ECommerceRouteNames.editProductPage,
        parameters: {'id': '${productViewModel.id}'});
    if (result != null && result) {
      await getProducts();
    }
  }

  Uint8List stringToImage(final String base64String) =>
      base64Decode(base64String);

  @override
  void onInit() async {
    await getProducts();
    super.onInit();
  }
}
