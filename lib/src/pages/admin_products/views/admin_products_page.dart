import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/e_commerce_utils.dart';
import '../../shared/models/product_view_model.dart';
import '../../shared/widgets/tags.dart';
import '../controllers/admin_products_page_controller.dart';
import '../widgets/product_delete_dialog.dart';

class AdminProductsPage extends GetView<AdminProductsController> {
  const AdminProductsPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            _filter(),
            _search(),
          ],
          title: Text(LocaleKeys.shared_products.tr),
        ),
        body: Obx(() => controller.loading.value ? _loading() : _products()),
        floatingActionButton: _floatingActionButton(),
      );

  Widget _filter() => IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          controller.onFilterIconPressed();
        },
        icon: const Icon(Icons.filter_list_rounded),
      );

  Widget _search() => IconButton(
        padding: EdgeInsetsDirectional.only(
            end: ECommerceUtils.largePadding,
            start: ECommerceUtils.largePadding),
        constraints: const BoxConstraints(),
        onPressed: () {
          controller.onSearchIconPressed();
        },
        icon: const Icon(Icons.search_rounded),
      );

  Widget _loading() => const Center(child: CircularProgressIndicator());

  Widget _products() => Padding(
        padding: EdgeInsets.only(top: ECommerceUtils.bodyVerticalPadding),
        child: ListView.builder(
          itemBuilder: (final context, final index) =>
              _listTile(context, controller.filteredProducts[index]),
          itemCount: controller.filteredProducts.length,
        ),
      );

  Widget _listTile(final BuildContext context,
          final ProductViewModel productViewModel) =>
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ECommerceUtils.bodyHorizontalPadding),
        child: InkWell(
          splashColor: Theme.of(context).primaryColor.withAlpha(30),
          onTap: () {
            controller.onProductPressed(productViewModel);
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _productImage(productViewModel),
                _productBody(productViewModel, context),
                _productDelete(productViewModel),
              ],
            ),
          ),
        ),
      );

  Widget _productImage(final ProductViewModel productViewModel) => Opacity(
        opacity: productViewModel.isActive ? 1.0 : 0.3,
        child: Image.memory(
          controller.stringToImage(productViewModel.picture),
        ),
      );

  Widget _productBody(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Opacity(
        opacity: productViewModel.isActive ? 1.0 : 0.3,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
              top: ECommerceUtils.extraLargePadding,
              start: ECommerceUtils.extraLargePadding,
              end: ECommerceUtils.extraLargePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _productTitle(productViewModel, context),
              _productPrice(productViewModel, context),
              if (productViewModel.tags.isNotEmpty)
                _productTags(productViewModel),
              _productDescription(productViewModel, context),
              _productStock(productViewModel, context),
            ],
          ),
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

  Widget _productPrice(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Padding(
        padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
        child: Text(
          '${productViewModel.price} ${LocaleKeys.shared_toomaan.tr} ',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      );

  Widget _productTags(final ProductViewModel productViewModel) => Tags(
        tags: productViewModel.tags,
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

  Widget _productStock(
      final ProductViewModel productViewModel, final BuildContext context) {
    if (productViewModel.count == 0) {
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
              '${productViewModel.count}',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          Text(LocaleKeys.shared_items.tr),
          Text(LocaleKeys.shared_in_stock.tr),
        ],
      );
    }
  }

  Widget _productDelete(final ProductViewModel productViewModel) => Padding(
        padding: EdgeInsetsDirectional.only(
            bottom: ECommerceUtils.mediumPadding,
            end: ECommerceUtils.extraLargePadding),
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
          controller.onAddPressed();
        },
        child: const Icon(Icons.add),
      );
}
