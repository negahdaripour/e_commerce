import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/routes/e_commerce_route_names.dart';
import '../../shared/widgets/filter_dialog.dart';
import '../models/cart_item_view_model.dart';
import '../models/product_view_model.dart';
import '../models/user_dto.dart';
import '../models/user_view_model.dart';
import '../repositories/current_user_repository.dart';
import '../repositories/user_products_repository.dart';

class UserProductsController extends GetxController {
  final int userId;
  RxBool isFavorite = false.obs;
  RxBool loading = true.obs;
  RxInt numberOfItemsInCart = 0.obs;
  RxMap<int, int> productNumberPickerInitialValues = <int, int>{}.obs;
  Rxn<RangeValues> priceRange = Rxn();
  Rxn<double> priceMin = Rxn();
  Rxn<double> priceMax = Rxn();
  RxBool inStockFilter = true.obs;

  UserProductsController({required final this.userId});

  UserProductsRepository userProductsRepository = UserProductsRepository();
  CurrentUserRepository currentUserRepository = CurrentUserRepository();

  RxList<ProductViewModel> filteredProducts = <ProductViewModel>[].obs;
  RxList<ProductViewModel> products = <ProductViewModel>[].obs;
  Rxn<UserViewModel> currentUser = Rxn();
  RxMap<int, bool> productFavoriteStatus = <int, bool>{}.obs;
  RxList<CartItemViewModel> productCartStatus = <CartItemViewModel>[].obs;

  Future<void> initialize() async {
    final _products = await userProductsRepository.getProducts();

    for (final product in _products) {
      if (product.isActive) {
        products.add(product);
      }
    }

    if (filteredProducts.isEmpty) {
      filteredProducts.addAll(products);
    }
    currentUser.value = await currentUserRepository.getUser(userId);

    productCartStatus.value = currentUser.value!.cart;

    fillProductNumberInCart();
    fillProductFavoriteMap();
    setNumberOfItemsInCart();

    priceMin.value = getMinPrice();
    priceMax.value = getMaxPrice();
    priceRange.value = RangeValues(priceMin.value!, priceMax.value!);

    loading.value = false;
  }

  double getMinPrice() {
    double _min = double.infinity;
    for (final product in products) {
      if (product.price < _min) {
        _min = product.price.toDouble();
      }
    }
    return _min;
  }

  double getMaxPrice() {
    int _max = 0;
    for (final product in products) {
      if (product.price > _max) {
        _max = product.price;
      }
    }
    return _max.toDouble();
  }

  void fillProductNumberInCart() {
    for (final product in filteredProducts) {
      final CartItemViewModel cartItem = currentUser.value!.cart.firstWhere(
          (final element) => element.productId == product.id,
          orElse: () => CartItemViewModel(productId: 0, count: 0));
      if (product.inStock) {
        productNumberPickerInitialValues[product.id] =
            (cartItem.productId == 0) ? 0 : cartItem.count;
      } else {
        productNumberPickerInitialValues[product.id] = 0;
      }
    }
  }

  void fillProductFavoriteMap() {
    for (final product in filteredProducts) {
      if (currentUser.value!.favourites.contains(product.id)) {
        productFavoriteStatus[product.id] = true;
      } else {
        productFavoriteStatus[product.id] = false;
      }
    }
  }

  void setNumberOfItemsInCart() {
    numberOfItemsInCart.value = 0;
    for (final element in currentUser.value!.cart) {
      numberOfItemsInCart.value += element.count;
    }
  }

  Uint8List stringToImage(final String base64String) =>
      base64Decode(base64String);

  void onProductFavoritePressed(final int id) async {
    productFavoriteStatus[id] = !productFavoriteStatus[id]!;
    final List<int> favoriteProducts = [];
    productFavoriteStatus.forEach((final key, final value) {
      if (value) {
        favoriteProducts.add(key);
      }
    });

    final UserDto userDto = UserDto(
        picture: currentUser.value!.picture,
        firstname: currentUser.value!.firstname,
        lastname: currentUser.value!.lastname,
        username: currentUser.value!.username,
        password: currentUser.value!.password,
        address: currentUser.value!.address,
        isAdmin: currentUser.value!.isAdmin,
        favourites: favoriteProducts,
        cart: currentUser.value!.cart);

    await editUser(user: userDto);
  }

  void editUserCart(final ProductViewModel product, final int newValue) async {
    productNumberPickerInitialValues[product.id] = newValue;
    final CartItemViewModel cartItem = currentUser.value!.cart.firstWhere(
        (final element) => element.productId == product.id,
        orElse: () => CartItemViewModel(productId: 0, count: 0));
    if (newValue == 0) {
      currentUser.value!.cart.remove(cartItem);
    } else if (newValue > 0 && newValue <= product.count) {
      if (cartItem.productId != 0) {
        currentUser.value!.cart
          ..remove(cartItem)
          ..add(CartItemViewModel(productId: product.id, count: newValue));
      } else {
        currentUser.value!.cart
            .add(CartItemViewModel(productId: product.id, count: newValue));
      }
    }

    currentUser.refresh();
    await editUser();
  }

  Future<void> editUser({final UserDto? user}) async {
    final UserDto userDto = UserDto(
        picture: currentUser.value!.picture,
        firstname: currentUser.value!.firstname,
        lastname: currentUser.value!.lastname,
        username: currentUser.value!.username,
        password: currentUser.value!.password,
        address: currentUser.value!.address,
        isAdmin: currentUser.value!.isAdmin,
        favourites: currentUser.value!.favourites,
        cart: currentUser.value!.cart);

    setNumberOfItemsInCart();
    if (user == null) {
      await currentUserRepository.editUser(userId, userDto);
    } else {
      await currentUserRepository.editUser(userId, user);
    }
  }

  void onProductPressed(final int id) async {
    final result = await Get.toNamed(ECommerceRouteNames.productDetailPage,
        parameters: {'productId': '$id', 'userId': '$userId'});
    if (result == null) {
      loading.value = true;
      await initialize();
    }
  }

  void onShoppingCartPressed() async {
    final result = await Get.toNamed(ECommerceRouteNames.userCartPage,
        parameters: {'id': '$userId'});
    if (result == null) {
      loading.value = true;
      await initialize();
    }
  }

  void onSearchIconPressed() async {
    final result = await Get.toNamed(ECommerceRouteNames.userSearchPage,
        parameters: {'id': '$userId'});
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
            min: priceMin.value!,
            rangeValues: priceRange.value!,
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
    super.onInit();
    await initialize();
  }
}
