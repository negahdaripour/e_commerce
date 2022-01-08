import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../infrastructure/routes/e_commerce_route_names.dart';
import '../../shared/models/cart_item_view_model.dart';
import '../../shared/models/product_view_model.dart';
import '../../shared/models/user_dto.dart';
import '../../shared/models/user_view_model.dart';
import '../repositories/products_cart_repository.dart';
import '../repositories/user_cart_repository.dart';

class UserCartController extends GetxController {
  final int userId;
  RxBool loading = true.obs;
  RxInt numberOfItemsInCart = 0.obs;

  UserCartController({required final this.userId});

  RxMap<ProductViewModel, int> cartProductsAndCount =
      <ProductViewModel, int>{}.obs;
  RxList<ProductViewModel> productInCart = <ProductViewModel>[].obs;
  late UserViewModel user;

  ProductCartRepository productCartRepository = ProductCartRepository();
  UserCartRepository userCartRepository = UserCartRepository();

  Uint8List stringToImage(final String base64String) =>
      base64Decode(base64String);

  Future<void> initialize() async {
    user = await userCartRepository.getUser(userId);
    final List<ProductViewModel> _allProducts =
        await productCartRepository.getProducts();

    productInCart.clear();
    cartProductsAndCount.clear();
    for (final product in _allProducts) {
      for (final item in user.cart) {
        if (item.productId == product.id) {
          cartProductsAndCount[product] = item.count;
          productInCart.add(product);
        }
      }
    }

    setNumberOfItemsInCart();
    loading.value = false;
  }

  void setNumberOfItemsInCart() {
    numberOfItemsInCart.value = 0;
    for (final element in user.cart) {
      numberOfItemsInCart.value += element.count;
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

  int calculateProductTotalPrice(final ProductViewModel productViewModel) =>
      productViewModel.price * cartProductsAndCount[productViewModel]!;

  void editUserCart(
      final ProductViewModel productViewModel, final int newValue) async {
    final CartItemViewModel cartItem = user.cart.firstWhere(
        (final element) => element.productId == productViewModel.id,
        orElse: () => CartItemViewModel(productId: 0, count: 0));
    if (newValue == 0) {
      user.cart.remove(cartItem);
      cartProductsAndCount[productViewModel] = newValue;
    } else if (newValue > 0 && newValue <= productViewModel.count) {
      if (cartItem.productId != 0) {
        user.cart
          ..remove(cartItem)
          ..add(CartItemViewModel(
              productId: productViewModel.id, count: newValue));
        cartProductsAndCount[productViewModel] = newValue;
      } else {
        user.cart.add(
            CartItemViewModel(productId: productViewModel.id, count: newValue));
        cartProductsAndCount[productViewModel] = newValue;
      }
    }

    final UserDto userDto = UserDto(
        picture: user.picture,
        firstname: user.firstname,
        lastname: user.lastname,
        username: user.username,
        password: user.password,
        address: user.address,
        isAdmin: user.isAdmin,
        favourites: user.favourites,
        cart: user.cart);

    setNumberOfItemsInCart();
    await userCartRepository.editUser(userId, userDto);
  }

  int getProductsCountInCart() {
    int _totalCount = 0;
    for (final item in user.cart) {
      _totalCount += item.count;
    }
    return _totalCount;
  }

  int getProductsTotalPriceInCart() {
    int _totalPrice = 0;
    for (final pair in cartProductsAndCount.entries) {
      _totalPrice += pair.key.price * pair.value;
    }
    return _totalPrice;
  }

  @override
  void onInit() async {
    super.onInit();
    await initialize();
  }
}
