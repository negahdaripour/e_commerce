import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_picker/number_picker.dart';

import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/e_commerce_utils.dart';
import '../../shared/models/product_view_model.dart';
import '../../shared/widgets/tags.dart';
import '../controllers/user_search_controller.dart';

class UserSearchPage extends GetView<UserSearchController> {
  const UserSearchPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.infinity,
            height: 40.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight)),
                  iconColor: const Color(0xff442C2E),
                  prefixIcon: IconButton(
                    onPressed: () {
                      controller.onSearchFieldSubmitted(
                          controller.searchTextController.text);
                    },
                    icon: const Icon(Icons.search_rounded,
                        color: Color(0xff442C2E)),
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
            ),
          ),
        ),
        body: Obx(
            () => controller.loading.value ? _loading() : _products(context)),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _productImage(productViewModel),
                _productBody(context, productViewModel),
              ],
            ),
          ),
        ),
      );

  Widget _productImage(final ProductViewModel productViewModel) => Image.memory(
        controller.stringToImage(productViewModel.picture),
        height: 250.0,
        fit: BoxFit.fill,
      );

  Widget _productBody(final BuildContext context,
          final ProductViewModel productViewModel) =>
      Padding(
        padding: EdgeInsetsDirectional.all(
          ECommerceUtils.extraLargePadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _productTitleAndFavorite(productViewModel, context),
            _productPrice(productViewModel, context),
            if (productViewModel.tags.isNotEmpty)
              _productTags(productViewModel),
            _productDescription(productViewModel, context),
            _numberPickerAndStock(productViewModel, context),
          ],
        ),
      );

  Widget _productTitleAndFavorite(final ProductViewModel productViewModel,
          final BuildContext context) =>
      SizedBox(
        height: 40.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _productTitle(productViewModel, context),
            _productFavorite(productViewModel, context),
          ],
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

  Widget _productFavorite(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Obx(
        () => InkWell(
          onTap: () {
            controller.onProductFavoritePressed(productViewModel.id);
          },
          child: controller.productFavoriteStatus[productViewModel.id]!
              ? Icon(
                  Icons.favorite_border_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )
              : const Icon(Icons.favorite_border_rounded),
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

  Widget _numberPickerAndStock(final ProductViewModel productViewModel,
          final BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _productStock(productViewModel, context),
          Obx(
            () => NumberPicker(
              minValue: 0,
              maxValue: productViewModel.count,
              getValue: (final newValue) {
                controller.editUserCart(productViewModel, newValue);
              },
              initialValue: controller
                  .productNumberPickerInitialValues[productViewModel.id]!,
            ),
          ),
        ],
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
}
