import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_page_controller.dart';

class SplashPage extends StatelessWidget {
  SplashPage({final Key? key}) : super(key: key);

  SplashPageController controller = Get.find();
  @override
  Widget build(final BuildContext context) => const Scaffold(
        body: Center(
          child: Icon(
            Icons.favorite,
            color: Colors.black,
            size: 50.0,
          ),
        ),
      );
}
