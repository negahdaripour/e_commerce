import 'package:e_commerce/e_commerce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/utils/e_commerce_utils.dart';
import '../controllers/login_page_controller.dart';

class LoginPage extends GetView<LoginPageController> {
  const LoginPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
              '${LocaleKeys.shared_login.tr}/${LocaleKeys.shared_signup.tr}'),
        ),
        body: _login(context),
      );

  Widget _login(final BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.only(
            start: ECommerceUtils.bodyHorizontalPadding,
            end: ECommerceUtils.bodyHorizontalPadding),
        child: ListView(
          children: <Widget>[
            _loginForm(),
            _logIn(context),
            _signIn(),
          ],
        ),
      );

  Widget _loginForm() => Form(
        key: controller.formKey,
        child: Column(
          children: [
            _username(),
            _password(),
          ],
        ),
      );

  Widget _password() => Padding(
        padding: EdgeInsetsDirectional.only(
            bottom: ECommerceUtils.bodyVerticalPadding),
        child: TextFormField(
          controller: controller.passwordTextController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(LocaleKeys.shared_password.tr),
          ),
          validator: (final value) {
            controller.validatePassword(value);
            return controller.passwordValidation;
          },
          // prefixIcon: const Icon(Icons.remove_red_eye)), //TODO add remove_red_eye icon
        ),
      );

  Widget _username() => Padding(
        padding: EdgeInsetsDirectional.only(
            top: ECommerceUtils.bodyVerticalPadding,
            bottom: ECommerceUtils.bodyVerticalPadding),
        child: TextFormField(
          controller: controller.usernameTextController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(LocaleKeys.shared_username.tr),
          ),
          validator: (final value) {
            controller.validateUsername(value);
            return controller.usernameValidation;
          },
        ),
      );

  Widget _logIn(final BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.only(
            bottom: ECommerceUtils.bodyVerticalPadding),
        child: SizedBox(
          width: ECommerceUtils.loginButtonWidth,
          child: Align(
            child: ElevatedButton(
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  //TODO implement login
                  //TODO Get.offNamed
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(LocaleKeys.shared_invalid_input.tr),
                  ));
                }
              },
              child: Text(LocaleKeys.shared_login.tr),
            ),
          ),
        ),
      );

  Widget _signIn() => Padding(
        padding: EdgeInsetsDirectional.only(
            bottom: ECommerceUtils.bodyVerticalPadding),
        child: Align(
          child: TextButton(
            onPressed: () {
              //TODO implement signup
            },
            child: Text(LocaleKeys.shared_signup.tr),
          ),
        ),
      );
}
