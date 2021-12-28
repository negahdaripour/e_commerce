import 'package:get/get.dart';

import '../../shared/models/product_view_model.dart';
import '../repositories/admin_products_repository.dart';

class AdminProductsController extends GetxController {
  AdminProductsRepository adminProductsRepository = AdminProductsRepository();

  RxList<ProductViewModel> products = <ProductViewModel>[].obs;

  Future<void> getProducts() async {
    products.value = await adminProductsRepository.getProducts();
  }

  Future<void> deleteProduct(final ProductViewModel productViewModel) async {
    await adminProductsRepository.deleteUProduct(productViewModel.id);
    products.removeWhere((final product) => product.id == productViewModel.id);
  }

  void productDeleteDialogResult(
      {required final bool result,
      required final ProductViewModel productViewModel}) {
    if (result) {
      deleteProduct(productViewModel);
    }
  }

  @override
  void onInit() async {
    await getProducts();
    super.onInit();
  }
}
