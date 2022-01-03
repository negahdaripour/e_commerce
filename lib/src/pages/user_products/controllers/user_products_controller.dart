import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../infrastructure/routes/e_commerce_route_names.dart';
import '../../shared/models/cart_item_view_model.dart';
import '../../shared/models/product_view_model.dart';
import '../../shared/models/user_dto.dart';
import '../../shared/models/user_view_model.dart';
import '../repositories/current_user_repository.dart';
import '../repositories/user_products_repository.dart';

class UserProductsController extends GetxController {
  final int userId;
  RxBool isFavorite = false.obs;
  RxBool loading = true.obs;
  RxInt numberOfItemsInCart = 0.obs;

  UserProductsController({required final this.userId});

  UserProductsRepository userProductsRepository = UserProductsRepository();
  CurrentUserRepository currentUserRepository = CurrentUserRepository();

  RxList<ProductViewModel> products = <ProductViewModel>[].obs;
  late UserViewModel currentUser;
  RxMap<int, bool> productFavoriteStatus = <int, bool>{}.obs;
  RxList<CartItemViewModel> productCartStatus = <CartItemViewModel>[].obs;

  Future<void> initialize() async {
    final _products = await userProductsRepository.getProducts();
    products.clear();
    for (final product in _products) {
      if (product.isActive) {
        products.add(product);
      }
    }
    currentUser = await currentUserRepository.getUser(userId);

    productCartStatus.value = currentUser.cart;
    fillProductFavoriteMap();

    setNumberOfItemsInCart();

    loading.value = false;
  }

  void setNumberOfItemsInCart() {
    numberOfItemsInCart.value = 0;
    for (final element in productCartStatus) {
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
        picture: currentUser.picture,
        firstname: currentUser.firstname,
        lastname: currentUser.lastname,
        username: currentUser.username,
        password: currentUser.password,
        address: currentUser.address,
        isAdmin: currentUser.isAdmin,
        favourites: favoriteProducts,
        cart: currentUser.cart);
    await currentUserRepository.editUser(userId, userDto);
  }

  void editUserCart(final ProductViewModel product, final int newValue) async {
    final CartItemViewModel cartItem = productCartStatus.firstWhere(
        (final element) => element.productId == product.id,
        orElse: () => CartItemViewModel(productId: 0, count: 0));
    if (newValue == 0) {
      productCartStatus.remove(cartItem);
    } else if (newValue > 0 && newValue <= product.count) {
      if (cartItem.productId != 0) {
        productCartStatus
          ..remove(cartItem)
          ..add(CartItemViewModel(productId: product.id, count: newValue));
      } else {
        productCartStatus
            .add(CartItemViewModel(productId: product.id, count: newValue));
      }
    }

    final UserDto userDto = UserDto(
        picture: currentUser.picture,
        firstname: currentUser.firstname,
        lastname: currentUser.lastname,
        username: currentUser.username,
        password: currentUser.password,
        address: currentUser.address,
        isAdmin: currentUser.isAdmin,
        favourites: currentUser.favourites,
        cart: productCartStatus);

    setNumberOfItemsInCart();
    await currentUserRepository.editUser(userId, userDto);
  }

  void fillProductFavoriteMap() {
    for (final product in products) {
      if (currentUser.favourites.contains(product.id)) {
        productFavoriteStatus[product.id] = true;
      } else {
        productFavoriteStatus[product.id] = false;
      }
    }
  }

  int getProductCountInCart(final int id) {
    final CartItemViewModel cartItem = productCartStatus.firstWhere(
        (final element) => element.productId == id,
        orElse: () => CartItemViewModel(productId: 0, count: 0));
    return (cartItem.productId == 0) ? 0 : cartItem.count;
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

  @override
  void onInit() async {
    super.onInit();
    await initialize();
  }
}
