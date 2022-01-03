import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_picker/number_picker.dart';

import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/e_commerce_utils.dart';
import '../../shared/widgets/tags.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailsPage extends GetView<ProductDetailController> {
  const ProductDetailsPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: <Widget>[_shoppingCartIcon(context)],
          title: Text(LocaleKeys.shared_product_detail.tr),
        ),
        body: Obx(
          () =>
              controller.loading.value ? _loading() : _productDetails(context),
        ),
      );

  Widget _shoppingCartIcon(final BuildContext context) => Obx(() => Stack(
        alignment: const Alignment(0.6, -0.6),
        children: <Widget>[
          IconButton(
            onPressed: () {
              controller.onShoppingCartPressed();
            },
            icon: const Icon(Icons.shopping_cart_rounded),
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

  Widget _loading() => const Center(child: CircularProgressIndicator());

  Widget _productDetails(final BuildContext context) => Obx(() => ListView(
        children: <Widget>[_productImage(), _productBody(context)],
      ));

  Widget _productImage() =>
      Image.memory(controller.stringToImage(controller.product.value!.picture));

  Widget _productBody(final BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.all(
          ECommerceUtils.bodyHorizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _productTitleAndFavorite(context),
            _productPrice(context),
            if (controller.product.value!.tags.isNotEmpty) _productTags(),
            _productDescription(context),
            _numberPickerAndStock(context),
          ],
        ),
      );

  Widget _productTitleAndFavorite(final BuildContext context) => Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _productTitle(context),
              _productFavorite(context),
            ],
          ),
        ],
      );

  Widget _productTitle(final BuildContext context) => Expanded(
        flex: 10,
        child: Padding(
          padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
          child: Text(
            controller.product.value!.title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );

  Widget _productFavorite(final BuildContext context) => Obx(
        () => Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              controller.onProductFavoritePressed(controller.productId);
            },
            child: controller.isFavorite.value
                ? Icon(
                    Icons.favorite_border_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : const Icon(Icons.favorite_border_rounded),
          ),
        ),
      );

  Widget _productPrice(final BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: ECommerceUtils.bodyVerticalPadding),
        child: Text(
          '${controller.product.value!.price} ${LocaleKeys.shared_toomaan.tr} ',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      );

  Widget _productTags() => Tags(
        tags: controller.product.value!.tags,
      );

  Widget _productDescription(final BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
        child: Text(
          controller.product.value!.description,
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );

  Widget _numberPickerAndStock(final BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _productStock(context),
          Obx(() => NumberPicker(
                getValue: (final newValue) {
                  controller.editUserCart(newValue);
                },
                initialValue: controller.cartItemCount.value!,
              )),
        ],
      );

  Widget _productStock(final BuildContext context) {
    if (controller.product.value!.count == 0) {
      return Row(
        children: [
          const Icon(Icons.close),
          Text(LocaleKeys.shared_not_in_stock.tr)
        ],
      );
    } else {
      return Row(
        children: [
          const Icon(Icons.check),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ECommerceUtils.mediumPadding),
            child: Text(
              '${controller.product.value!.count}',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          Text(LocaleKeys.shared_items.tr),
          Text(LocaleKeys.shared_in_stock.tr),
        ],
      );
    }
  }
}
