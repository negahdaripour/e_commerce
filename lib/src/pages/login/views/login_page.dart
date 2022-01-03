import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
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
      body: Obx(
        () => (controller.loading.value) ? _loading() : _body(context),
      ));

  Widget _loading() => const Center(child: CircularProgressIndicator());

  Widget _body(final BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.only(
            start: ECommerceUtils.bodyHorizontalPadding,
            end: ECommerceUtils.bodyHorizontalPadding),
        child: ListView(
          children: <Widget>[
            _loginForm(),
            _logIn(context),
            _signUp(),
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

  Widget _password() => Padding(
        padding: EdgeInsetsDirectional.only(
            bottom: ECommerceUtils.bodyVerticalPadding),
        child: TextFormField(
          obscureText: !controller.showPassword.value,
          controller: controller.passwordTextController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(LocaleKeys.shared_password.tr),
            suffixIcon: GestureDetector(
              onTap: () {
                controller.togglePasswordVisibility();
              },
              child: const Icon(Icons.remove_red_eye),
            ),
          ),
          validator: (final value) {
            controller.validatePassword(value);
            return controller.passwordValidation;
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
                  //TODO implement login shared preferences
                  controller.onLoginPressed();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.shared_invalid_input.tr),
                    ),
                  );
                }
              },
              child: Text(LocaleKeys.shared_login.tr),
            ),
          ),
        ),
      );

  Widget _signUp() => Padding(
        padding: EdgeInsetsDirectional.only(
            bottom: ECommerceUtils.bodyVerticalPadding),
        child: Align(
          child: OutlinedButton(
            onPressed: () {
              controller.onSignupPressed();
            },
            child: Text(LocaleKeys.shared_signup.tr),
          ),
        ),
      );
}
