import 'package:flutter/material.dart';

import '../../../infrastructure/utils/e_commerce_utils.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: Center(
            child: Icon(
          Icons.shopping_cart_outlined,
          size: ECommerceUtils.splashIconSize,
          color: Colors.black,
        )),
      );
}
