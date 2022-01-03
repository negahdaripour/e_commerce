import 'dart:convert';
import 'dart:typed_data';

import 'package:e_commerce/e_commerce.dart';
import 'package:get/get.dart';

import '../../shared/models/cart_item_view_model.dart';
import '../../shared/models/product_view_model.dart';
import '../../shared/models/user_dto.dart';
import '../../shared/models/user_view_model.dart';
import '../repositories/product_detail_repository.dart';
import '../repositories/user_detail_repository.dart';

class ProductDetailController extends GetxController {
  final int productId;
  final int userId;
  RxBool loading = true.obs;
  RxBool isFavorite = false.obs;
  RxnInt cartItemCount = RxnInt();
  RxInt numberOfItemsInCart = 0.obs;
  ProductDetailRepository productDetailRepository = ProductDetailRepository();
  UserDetailRepository userDetailRepository = UserDetailRepository();

  ProductDetailController(
      {required final this.productId, required final this.userId});

  Rxn<ProductViewModel> product = Rxn();
  Rxn<UserViewModel> user = Rxn();

  Uint8List stringToImage(final String base64String) =>
      base64Decode(base64String);

  void setNumberOfItemsInCart() {
    numberOfItemsInCart.value = 0;
    for (final element in user.value!.cart) {
      numberOfItemsInCart.value += element.count;
    }
  }

  Future<void> initialize() async {
    product.value = await productDetailRepository.getProduct(productId);
    user.value = await userDetailRepository.getUser(userId);
    isFavorite.value = getProductFavoriteStatus(productId);
    getProductCountInCart();
    setNumberOfItemsInCart();
    loading.value = false;
  }

  bool getProductFavoriteStatus(final int id) =>
      user.value!.favourites.any((final element) => element == id);

  void onProductFavoritePressed(final int id) async {
    isFavorite.value = !isFavorite.value;
    if (user.value!.favourites.contains(id)) {
      user.value!.favourites.remove(id);
    } else {
      user.value!.favourites.add(id);
    }

    final UserDto userDto = UserDto(
        picture: user.value!.picture,
        firstname: user.value!.firstname,
        lastname: user.value!.lastname,
        username: user.value!.username,
        password: user.value!.password,
        address: user.value!.address,
        isAdmin: user.value!.isAdmin,
        favourites: user.value!.favourites,
        cart: user.value!.cart);

    await userDetailRepository.editUser(userId, userDto);
  }

  void editUserCart(final int newValue) async {
    final CartItemViewModel cartItem = user.value!.cart.firstWhere(
        (final element) => element.productId == productId,
        orElse: () => CartItemViewModel(productId: 0, count: 0));
    if (newValue == 0) {
      user.value!.cart.remove(cartItem);
    } else if (newValue > 0 && newValue <= product.value!.count) {
      if (cartItem.productId != 0) {
        user.value!.cart
          ..remove(cartItem)
          ..add(CartItemViewModel(productId: productId, count: newValue));
      } else {
        user.value!.cart
            .add(CartItemViewModel(productId: productId, count: newValue));
      }
    }

    getProductCountInCart();
    setNumberOfItemsInCart();

    final UserDto userDto = UserDto(
        picture: user.value!.picture,
        firstname: user.value!.firstname,
        lastname: user.value!.lastname,
        username: user.value!.username,
        password: user.value!.password,
        address: user.value!.address,
        isAdmin: user.value!.isAdmin,
        favourites: user.value!.favourites,
        cart: user.value!.cart);

    await userDetailRepository.editUser(userId, userDto);
  }

  void getProductCountInCart() {
    final CartItemViewModel cartItem = user.value!.cart.firstWhere(
        (final element) => element.productId == productId,
        orElse: () => CartItemViewModel(productId: 0, count: 0));
    cartItemCount.value = (cartItem.productId == 0) ? 0 : cartItem.count;
  }

  void onShoppingCartPressed() async {
    final result = await Get.toNamed(ECommerceRouteNames.userCartPage,
        parameters: {'id': '$userId'});
    if (result == null) {
      loading.value = true;
      await initialize();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await initialize();
  }
}
