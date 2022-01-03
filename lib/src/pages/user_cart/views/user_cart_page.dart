import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_picker/number_picker.dart';

import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/e_commerce_utils.dart';
import '../../shared/models/product_view_model.dart';
import '../controllers/user_cart_controller.dart';

class UserCartPage extends GetView<UserCartController> {
  const UserCartPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: <Widget>[_shoppingCartIcon(context)],
          title: Text(LocaleKeys.shared_cart.tr),
        ),
        body: Obx(
          () => controller.loading.value ? _loading() : _shoppingCart(context),
        ),
      );

  Widget _loading() => const Center(child: CircularProgressIndicator());

  Widget _shoppingCartIcon(final BuildContext context) => Obx(() => Stack(
        alignment: const Alignment(1.8, -0.6),
        children: <Widget>[
          Padding(
            padding:
                EdgeInsetsDirectional.only(end: ECommerceUtils.largePadding),
            child: const Center(
              child: Icon(Icons.shopping_cart_rounded),
            ),
          ),
          if (controller.numberOfItemsInCart.value != 0 &&
              !controller.loading.value)
            _numberOfItemsInCart(context),
        ],
      ));

  Widget _numberOfItemsInCart(final BuildContext context) => Container(
        width: 17.0,
        height: 17.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '${controller.numberOfItemsInCart.value}',
          style: const TextStyle(color: Colors.white),
        ),
      );

  Widget _shoppingCart(final BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ECommerceUtils.bodyHorizontalPadding),
        child: ListView(
          children: [
            Obx(() => _products(context)),
            _itemsCount(),
            const Divider(),
            _itemsTotalPrice(),
            _checkOut(),
          ],
        ),
      );

  Widget _products(final BuildContext context) {
    if (controller.productInCart.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: ECommerceUtils.bodyVerticalPadding),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.cartProductsAndCount.length,
          itemBuilder: (final context, final index) => _listTile(
              context: context,
              productViewModel: controller.productInCart[index]),
        ),
      );
    } else {
      return Center(
          child: Padding(
        padding: EdgeInsets.all(ECommerceUtils.bodyVerticalPadding),
        child: Text(
          'سبد خرید شما خالی است',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ));
    }
  }

  Widget _listTile(
          {required final BuildContext context,
          required final ProductViewModel productViewModel}) =>
      Card(
        child: SizedBox(
          height: ECommerceUtils.imageHolderHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _productImage(productViewModel),
              _productBody(productViewModel, context),
            ],
          ),
        ),
      );

  Widget _productImage(final ProductViewModel productViewModel) => Image.memory(
        controller.stringToImage(productViewModel.picture),
        width: ECommerceUtils.imageHolderHeight,
        fit: BoxFit.fill,
      );

  Widget _productBody(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Padding(
        padding: EdgeInsets.all(ECommerceUtils.largePadding),
        child: SizedBox(
          width: 180.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _productTitle(productViewModel, context),
              _productPrice(productViewModel, context),
              SizedBox(
                height: 10.0,
                width: 180.0,
                child: Center(
                  child: Container(
                    margin:
                        const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                    height: 1.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              _productTotalPriceAndNumberPicker(productViewModel, context),
            ],
          ),
        ),
      );

  Widget _productTitle(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
          child: Text(
            productViewModel.title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );

  Widget _productPrice(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Padding(
        padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
        child: Text(
          '${productViewModel.price} ${LocaleKeys.shared_toomaan.tr} ',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );

  Widget _productTotalPriceAndNumberPicker(
          final ProductViewModel productViewModel,
          final BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _productTotalPrice(productViewModel, context),
          Obx(() => NumberPicker(
              getValue: (final newValue) {
                controller.editUserCart(productViewModel, newValue);
              },
              initialValue:
                  controller.cartProductsAndCount[productViewModel]!)),
        ],
      );

  Widget _productTotalPrice(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Padding(
        padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
        child: Text(
          '${controller.calculateProductTotalPrice(productViewModel)}'
          ' ${LocaleKeys.shared_toomaan.tr}',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );

  Widget _itemsCount() => Padding(
        padding:
            EdgeInsets.symmetric(vertical: ECommerceUtils.extraLargePadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocaleKeys.shared_item_count.tr),
            Text('${controller.getProductsCountInCart()}'),
          ],
        ),
      );

  Widget _itemsTotalPrice() => Padding(
        padding:
            EdgeInsets.symmetric(vertical: ECommerceUtils.extraLargePadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocaleKeys.shared_total_price.tr),
            Text('${controller.getProductsTotalPriceInCart()}'),
          ],
        ),
      );

  Widget _checkOut() => Align(
        child: ElevatedButton(
            onPressed: () {
              //TODO
            },
            child: Text(LocaleKeys.shared_check_out.tr)),
      );
}
