import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';

class ProductDeleteDialog extends StatelessWidget {
  final void Function(bool val)? getAnswer;

  const ProductDeleteDialog({required final this.getAnswer, final Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) => SimpleDialog(
        children: [
          Center(
            child: Text(LocaleKeys.shared_are_you_sure_delete_product.tr),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SimpleDialogOption(
                child: Text(
                  LocaleKeys.shared_delete.tr,
                  style:
                      TextStyle(color: Theme.of(context).secondaryHeaderColor),
                ),
                onPressed: () {
                  getAnswer!.call(true);
                  Get.back(result: true);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  LocaleKeys.shared_cancel.tr,
                  style:
                      TextStyle(color: Theme.of(context).secondaryHeaderColor),
                ),
                onPressed: () {
                  getAnswer!.call(false);
                  Get.back(result: false);
                },
              ),
            ],
          )
        ],
      );
}
