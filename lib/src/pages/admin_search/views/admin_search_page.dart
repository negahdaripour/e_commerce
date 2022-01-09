import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/e_commerce_utils.dart';
import '../../admin_products/widgets/product_delete_dialog.dart';
import '../../shared/widgets/tags.dart';
import '../controllers/admin_search_controller.dart';
import '../models/product_view_model.dart';

class AdminSearchPage extends GetView<AdminSearchController> {
  const AdminSearchPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: _searchBar(context),
        ),
        body: Obx(
            () => controller.loading.value ? _loading() : _products(context)),
      );

  Widget _searchBar(final BuildContext context) => Container(
        width: double.infinity,
        height: ECommerceUtils.searchBarInputHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius:
              BorderRadius.circular(ECommerceUtils.searchBarBorderRadius),
        ),
        child: _searchInputField(context),
      );

  Widget _searchInputField(final BuildContext context) => Center(
        child: TextFormField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColorLight)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColorLight)),
            iconColor: const Color(0xff442C2E),
            prefixIcon: IconButton(
              onPressed: () {
                controller.onSearchFieldSubmitted(
                    controller.searchTextController.text);
              },
              icon: const Icon(Icons.search_rounded),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                controller.searchTextController.clear();
              },
            ),
            hintText: LocaleKeys.shared_search_hint.tr,
          ),
          controller: controller.searchTextController,
          onFieldSubmitted: (final searchString) {
            controller.onSearchFieldSubmitted(searchString);
          },
        ),
      );

  Widget _loading() => const Center(child: CircularProgressIndicator());

  Widget _products(final BuildContext context) => controller.products.isEmpty
      ? Center(
          child: Text(
          LocaleKeys.shared_no_results_found.tr,
          style: Theme.of(context).textTheme.bodyText1,
        ))
      : Padding(
          padding: EdgeInsets.only(top: ECommerceUtils.bodyVerticalPadding),
          child: ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (final context, final index) => _listTile(
                context: context, productViewModel: controller.products[index]),
          ),
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
            controller.onProductPressed(productViewModel.id);
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
}
