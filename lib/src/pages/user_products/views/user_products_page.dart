import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';

class UserProductsPage extends StatelessWidget {
  const UserProductsPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.shared_products.tr),
        ),
        body: const Center(),
      );
}
