import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/e_commerce_utils.dart';
import '../controllers/base_controller.dart';
import '../widgets/add_or_edit_tags.dart';
import '../widgets/product_input_line.dart';

class AddOrEditPage<T extends BaseController> extends GetView<T> {
  const AddOrEditPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
        ),
        body: Obx(() =>
            controller.loading.value ? _loading(context) : _body(context)),
      );

  Widget _loading(final BuildContext context) =>
      const Center(child: CircularProgressIndicator());

  Widget _body(final BuildContext context) => Padding(
        padding: EdgeInsets.all(ECommerceUtils.bodyHorizontalPadding),
        child: ListView(
          shrinkWrap: true,
          children: [
            _productPicture(context),
            _addProductPicture(context),
            _titleAndCount(),
            _tagsField(),
            if (controller.productTags.isNotEmpty) AddOrEditTags<T>(),
            _descriptionAndPrice(),
            _inStock(),
            const Divider(),
            _isActive(),
            _submit(context)
          ],
        ),
      );

  Widget _productPicture(final BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
        child: Align(
          child: Container(
            width: ECommerceUtils.imageHolderWidth,
            height: ECommerceUtils.imageHolderHeight,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: controller.imageBytes.value != null
                ? Image.memory(
                    controller.imageBytes.value!,
                    width: ECommerceUtils.imageHolderWidth,
                    height: ECommerceUtils.imageHolderHeight,
                    fit: BoxFit.fitHeight,
                  )
                : SizedBox(
                    width: ECommerceUtils.imageHolderWidth,
                    height: ECommerceUtils.imageHolderHeight,
                    child: Image.asset(
                      './lib/assets/images/image2.png',
                      package: 'e_commerce',
                    ),
                  ),
          ),
        ),
      );

  Widget _addProductPicture(final BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
        child: Align(
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (final context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _gallery(context),
                    _camera(context),
                  ],
                ),
              );
            },
            child: Text(
              controller.pictureManipulationTitle,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      );

  Widget _gallery(final BuildContext context) => Padding(
        padding: EdgeInsets.all(ECommerceUtils.bottomSheetPadding),
        child: GestureDetector(
          child: Text(
            LocaleKeys.shared_gallery.tr,
            style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          ),
          onTap: () {
            controller.getImageResult(ImageSource.gallery);
          },
        ),
      );

  Widget _camera(final BuildContext context) => Padding(
        padding: EdgeInsets.all(ECommerceUtils.bottomSheetPadding),
        child: GestureDetector(
          onTap: () {
            controller.getImageResult(ImageSource.camera);
          },
          child: Text(
            LocaleKeys.shared_camera.tr,
            style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          ),
        ),
      );

  Widget _titleAndCount() => Form(
        key: controller.titleAndCountFormKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ECommerceUtils.extraLargePadding),
              child: TextFormField(
                controller: controller.titleTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(LocaleKeys.shared_name.tr),
                ),
                validator: (final value) => controller.checkEmptyField(value),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ECommerceUtils.extraLargePadding),
              child: TextFormField(
                controller: controller.countTextController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(LocaleKeys.shared_count.tr)),
                validator: (final value) =>
                    controller.validateProductInfo(value),
              ),
            ),
          ],
        ),
      );

  Widget _tagsField() => Padding(
        padding: EdgeInsets.symmetric(vertical: ECommerceUtils.largePadding),
        child: Autocomplete<String>(
          optionsBuilder: (final textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return controller.allTags.where((final element) =>
                element.contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (final selected) {
            if (!controller.productTags.contains(selected)) {
              controller.productTags.add(selected);
            }
            controller.tagsTextController.clear();
          },
          fieldViewBuilder: (final context, final textController,
              final fieldFocusNode, final onFieldSubmitted) {
            controller.tagsTextController = textController;
            return TextFormField(
              controller: textController,
              focusNode: fieldFocusNode,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(LocaleKeys.shared_tags.tr),
              ),
              onFieldSubmitted: (final value) {
                controller.autoCompleteOnSubmitted(value);
              },
            );
          },
          optionsViewBuilder:
              (final context, final onSelected, final options) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: SizedBox(
                width: 350,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (final context, final index) {
                    final String option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

  Widget _descriptionAndPrice() => Form(
        key: controller.descriptionAndPriceFormKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ECommerceUtils.extraLargePadding),
              child: TextFormField(
                controller: controller.descriptionTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(LocaleKeys.shared_description.tr),
                ),
                validator: (final value) => controller.checkEmptyField(value),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ECommerceUtils.extraLargePadding),
              child: TextFormField(
                controller: controller.priceTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(LocaleKeys.shared_price.tr),
                ),
                validator: (final value) =>
                    controller.validateProductInfo(value),
              ),
            )
          ],
        ),
      );

  Widget _inStock() => ProductInputLine(
        label: controller.stock.value,
        child: Checkbox(
          value: controller.inStock.value,
          onChanged: (final value) {
            if (value != null) {
              controller.inStock.value = value;
              value
                  ? controller.stock.value = LocaleKeys.shared_in_stock.tr
                  : controller.stock.value = LocaleKeys.shared_not_in_stock.tr;
            }
          },
        ),
      );

  Widget _isActive() => ProductInputLine(
        label: controller.active.value,
        child: Switch(
          value: controller.isActive.value,
          onChanged: (final value) {
            controller.isActive.value = value;
            value
                ? controller.active.value = LocaleKeys.shared_active.tr
                : controller.active.value = LocaleKeys.shared_inactive.tr;
          },
        ),
      );

  Widget _submit(final BuildContext context) => Align(
        child: ElevatedButton(
          onPressed: () async {
            bool result =
                controller.titleAndCountFormKey.currentState!.validate();
            result =
                controller.descriptionAndPriceFormKey.currentState!.validate();
            if (result) {
              if (controller.imageBytes.value != null) {
                await controller.modify();
                Get.back(result: true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(LocaleKeys.shared_no_picture_added.tr),
                  ),
                );
              }
            }
          },
          child: Text(LocaleKeys.shared_submit.tr),
        ),
      );
}
