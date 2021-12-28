import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/e_commerce_utils.dart';
import '../../shared/models/product_view_model.dart';
import '../controllers/admin_products_page_controller.dart';
import '../widgets/product_delete_dialog.dart';
import '../widgets/tags.dart';

class AdminProductsPage extends GetView<AdminProductsController> {
  const AdminProductsPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.shared_products.tr),
        ),
        body: _products(),
        floatingActionButton: _floatingActionButton(),
      );

  Widget _products() => Padding(
        padding: EdgeInsets.only(top: ECommerceUtils.bodyVerticalPadding),
        child: Obx(() => ListView.builder(
              itemBuilder: (final context, final index) => _listTile(
                  context: context,
                  productViewModel: controller.products[index]),
              itemCount: controller.products.length,
            )),
      );

  Widget _listTile(
          {required final BuildContext context,
          required final ProductViewModel productViewModel}) =>
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ECommerceUtils.bodyHorizontalPadding),
        child: InkWell(
          splashColor: Theme.of(context).primaryColor.withAlpha(30),
          onTap: () {
            //TODO goto edit page
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _productImage(),
                _productBody(productViewModel, context),
                _productDelete(productViewModel),
              ],
            ),
          ),
        ),
      );

  Widget _productImage() => Image.asset(
        './lib/assets/images/Image.png', //TODO get image from json
        package: 'e_commerce',
      ); //TODO implement list tiles for admin products

  Widget _productBody(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Padding(
        padding: EdgeInsetsDirectional.only(
            top: ECommerceUtils.cardBodyPadding,
            start: ECommerceUtils.cardBodyPadding,
            end: ECommerceUtils.cardBodyPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _productTitle(productViewModel, context),
            _productPrice(productViewModel, context),
            _productTags(productViewModel),
            _productDescription(productViewModel, context),
            _productStock(productViewModel, context),
          ],
        ),
      );

  Widget _productStock(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Row(
        children: [
          const Icon(Icons.check),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ECommerceUtils.mediumPadding),
            child: Text(
              '${productViewModel.count}',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          Text(LocaleKeys.shared_in_stock.tr),
        ],
      );

  Widget _productDescription(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Padding(
        padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
        child: Text(
          productViewModel.description,
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );

  Widget _productTags(final ProductViewModel productViewModel) => Tags(
        tags: productViewModel.tags,
      );

  Widget _productPrice(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Padding(
        padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
        child: Text(
          '${productViewModel.price} ${LocaleKeys.shared_toomaan.tr} ',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      );

  Widget _productTitle(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Padding(
        padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
        child: Text(
          productViewModel.title,
          style: Theme.of(context).textTheme.headline5,
        ),
      );

  Widget _productDelete(final ProductViewModel productViewModel) => Padding(
        padding: EdgeInsetsDirectional.only(
            bottom: ECommerceUtils.mediumPadding,
            end: ECommerceUtils.cardBodyPadding),
        child: TextButton(
            onPressed: () {
              Get.dialog(ProductDeleteDialog(
                getAnswer: (final newResult) {
                  controller.productDeleteDialogResult(
                      result: newResult, productViewModel: productViewModel);
                },
              ));
            },
            child: Text(LocaleKeys.shared_delete.tr)),
      );

  Widget _floatingActionButton() => FloatingActionButton(
        onPressed: () {
          //TODO go to add products for admin page
        },
        child: const Icon(Icons.add),
      );
}
