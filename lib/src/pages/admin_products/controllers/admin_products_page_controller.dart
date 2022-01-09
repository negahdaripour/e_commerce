import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/routes/e_commerce_route_names.dart';
import '../../shared/widgets/filter_dialog.dart';
import '../models/product_view_model.dart';
import '../repositories/admin_products_repository.dart';

class AdminProductsController extends GetxController {
  RxBool loading = true.obs;

  Rxn<RangeValues> priceRange = Rxn();
  Rxn<double> priceMin = Rxn();
  Rxn<double> priceMax = Rxn();
  RxBool inStockFilter = true.obs;

  AdminProductsRepository adminProductsRepository = AdminProductsRepository();

  RxList<ProductViewModel> products = <ProductViewModel>[].obs;
  RxList<ProductViewModel> filteredProducts = <ProductViewModel>[].obs;

  Future<void> initialize() async {
    products.clear();
    filteredProducts.clear();

    final _products = await adminProductsRepository.getProducts();

    products.addAll(_products);
    filteredProducts.addAll(_products);

    priceMin.value = getMinPrice();
    priceMax.value = getMaxPrice();
    priceRange.value = RangeValues(priceMin.value!, priceMax.value!);

    loading.value = false;
  }

  double getMinPrice() {
    double _min = double.infinity;
    for (final product in filteredProducts) {
      if (product.price < _min) {
        _min = product.price.toDouble();
      }
    }
    return _min;
  }

  double getMaxPrice() {
    int _max = 0;
    for (final product in filteredProducts) {
      if (product.price > _max) {
        _max = product.price;
      }
    }
    return _max.toDouble();
  }

  Future<void> deleteProduct(final ProductViewModel productViewModel) async {
    await adminProductsRepository.deleteUProduct(productViewModel.id);
    filteredProducts
      ..removeWhere((final product) => product.id == productViewModel.id)
      ..refresh();
  }

  Future<void> refreshProduct() async {
    clearProducts();
    loading.value = true;
    await initialize();
  }

  void clearProducts() {
    filteredProducts.clear();
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
      await initialize();
    }
  }

  void onProductPressed(final ProductViewModel productViewModel) async {
    final result = await Get.toNamed(ECommerceRouteNames.editProductPage,
        parameters: {'id': '${productViewModel.id}'});
    if (result != null && result) {
      await initialize();
    }
  }

  Uint8List stringToImage(final String base64String) =>
      base64Decode(base64String);

  void onSearchIconPressed() async {
    final result = await Get.toNamed(ECommerceRouteNames.adminSearchPage);
    if (result == null) {
      loading.value = true;
      await initialize();
    }
  }

  void onFilterIconPressed() async {
    final result = await Get.dialog(
      Obx(
        () => FilterDialog(
            initialValue: inStockFilter.value,
            getValue: (final newValue) {
              inStockFilter.value = newValue;
            },
            getRangeValues: (final newRangeValues) {
              priceRange.value = newRangeValues;
            },
            rangeValues: priceRange.value!,
            min: priceMin.value!,
            max: priceMax.value!),
      ),
    );

    if (result != null && result) {
      loading.value = true;
      applyFilters();
    }
  }

  void applyFilters() {
    filteredProducts
      ..clear()
      ..addAll(products);

    applyPriceFilter();
    applyStockFilter();
    loading.value = false;
  }

  void applyPriceFilter() {
    for (final product in products) {
      if (product.price < priceRange.value!.start ||
          product.price > priceRange.value!.end) {
        filteredProducts.remove(product);
      }
    }
  }

  void applyStockFilter() {
    if (inStockFilter.value) {
      for (final product in products) {
        if (filteredProducts.contains(product) && !product.inStock) {
          filteredProducts.remove(product);
        }
      }
    }
  }

  @override
  void onInit() async {
    await initialize();
    super.onInit();
  }
}
