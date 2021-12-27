import 'package:e_commerce/e_commerce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({final Key? key}) : super(key: key);

  //TODO: setInitialUrlDate function implementation
  @override
  Widget build(final BuildContext context) => GetMaterialApp(
        title: 'eCommerce App',
        theme: CustomMaterialTheme(fontFamily: 'IranSans').themeData,
        debugShowCheckedModeBanner: false,
        getPages: [...ECommerceRoutePage.routes],
        locale: const Locale('fa', 'IR'),
        //TODO translations: localizationService()
        initialRoute: ECommerceRouteNames.loginPage,
      );
}
