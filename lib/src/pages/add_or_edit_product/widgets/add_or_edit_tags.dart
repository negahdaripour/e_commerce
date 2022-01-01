import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/utils/e_commerce_utils.dart';
import '../controllers/base_controller.dart';

class AddOrEditTags<T extends BaseController> extends StatelessWidget {
  final controller = Get.find<T>();

  AddOrEditTags({final Key? key}) : super(key: key);

  Widget _itemBuilder(final int index) => Padding(
        padding: EdgeInsetsDirectional.only(end: ECommerceUtils.largePadding),
        child: Chip(
          label: Text(controller.productTags[index]),
          onDeleted: () {
            controller.productTags.remove(controller.productTags[index]);
          },
        ),
      );

  @override
  Widget build(final BuildContext context) => SizedBox(
      height: ECommerceUtils.tagsHeight,
      child: Obx(() => ListView(
            scrollDirection: Axis.horizontal,
            children:
                List.generate(controller.productTags.length, _itemBuilder),
          )));
}
