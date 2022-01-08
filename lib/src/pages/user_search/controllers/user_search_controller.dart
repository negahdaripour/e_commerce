import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../infrastructure/routes/e_commerce_route_names.dart';
import '../../shared/models/cart_item_view_model.dart';
import '../../shared/models/product_view_model.dart';
import '../../shared/models/user_dto.dart';
import '../../shared/models/user_view_model.dart';
import '../repository/search_product_repository.dart';
import '../repository/search_user_repository.dart';

class UserSearchController extends GetxController {
  final int userId;

  SearchProductRepository searchProductRepository = SearchProductRepository();
  SearchUserRepository searchUserRepository = SearchUserRepository();

  final TextEditingController searchTextController = TextEditingController();

  RxBool loading = true.obs;
  Rxn<UserViewModel> currentUser = Rxn();
  RxList<ProductViewModel> products = <ProductViewModel>[].obs;
  RxMap<int, bool> productFavoriteStatus = <int, bool>{}.obs;
  RxMap<int, int> productNumberPickerInitialValues = <int, int>{}.obs;

  UserSearchController({required final this.userId});

  Uint8List stringToImage(final String base64String) =>
      base64Decode(base64String);

  void fillProductNumberInCart() {
    for (final product in products) {
      final CartItemViewModel cartItem = currentUser.value!.cart.firstWhere(
          (final element) => element.productId == product.id,
          orElse: () => CartItemViewModel(productId: 0, count: 0));
      (cartItem.productId == 0)
          ? productNumberPickerInitialValues[product.id] = 0
          : productNumberPickerInitialValues[product.id] = cartItem.count;
    }
  }

  void fillProductFavoriteMap() {
    for (final product in products) {
      if (currentUser.value!.favourites.contains(product.id)) {
        productFavoriteStatus[product.id] = true;
      } else {
        productFavoriteStatus[product.id] = false;
      }
    }
  }

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

    if (user == null) {
      await searchUserRepository.editUser(userId, userDto);
    } else {
      await searchUserRepository.editUser(userId, user);
    }
  }

  void onSearchFieldSubmitted(final String searchString) async {
    loading.value = true;
    await getUser(userId);
    final List<ProductViewModel> _products =
        await searchProductRepository.searchProducts(searchString);
    products.clear();
    for (final product in _products) {
      if (product.isActive) {
        products.add(product);
      }
    }

    fillProductNumberInCart();
    fillProductFavoriteMap();

    loading.value = false;
  }

  void onProductPressed(final int id) async {
    final result = await Get.toNamed(ECommerceRouteNames.productDetailPage,
        parameters: {'productId': '$id', 'userId': '$userId'});
    if (result == null) {
      loading.value = true;
      onSearchFieldSubmitted(searchTextController.text);
    }
  }

  Future<void> getUser(final int id) async {
    currentUser.value = await searchUserRepository.getUser(id);
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    await getUser(userId);
    loading.value = false;
  }
}
