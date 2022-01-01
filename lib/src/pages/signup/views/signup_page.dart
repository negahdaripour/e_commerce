import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/e_commerce_utils.dart';
import '../controllers/signup_controller.dart';

class SignupPage extends GetView<SignupPageController> {
  const SignupPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.shared_signup.tr),
        ),
        body: _body(context),
      );

  Widget _body(final BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.only(
          start: ECommerceUtils.bodyHorizontalPadding,
          end: ECommerceUtils.bodyHorizontalPadding,
        ),
        child: ListView(
          children: <Widget>[
            _signupForm(context),
            _signUp(context),
          ],
        ),
      );

  Widget _signupForm(final BuildContext context) => Form(
        key: controller.formKey,
        child: Column(
          children: [
            _productPicture(context),
            _addProductPicture(context),
            _firstname(),
            _lastname(),
            _username(),
            _password(),
            _repeatPassword(),
            _address(),
          ],
        ),
      );

  Widget _productPicture(final BuildContext context) => Obx(() => Padding(
        padding: EdgeInsets.only(
            top: ECommerceUtils.bodyHorizontalPadding,
            bottom: ECommerceUtils.largePadding),
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
      ));

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
              LocaleKeys.shared_add_profile_picture.tr,
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

  Widget _firstname() => Padding(
        padding:
            EdgeInsetsDirectional.only(top: ECommerceUtils.bodyVerticalPadding),
        child: TextFormField(
          controller: controller.firstnameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(LocaleKeys.shared_first_name.tr),
          ),
          validator: (final value) => controller.checkEmptyField(value),
        ),
      );

  Widget _lastname() => Padding(
        padding:
            EdgeInsetsDirectional.only(top: ECommerceUtils.bodyVerticalPadding),
        child: TextFormField(
          controller: controller.lastnameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(LocaleKeys.shared_last_name.tr),
          ),
          validator: (final value) => controller.checkEmptyField(value),
        ),
      );

  Widget _username() => Padding(
        padding: EdgeInsetsDirectional.only(
          top: ECommerceUtils.bodyVerticalPadding,
        ),
        child: TextFormField(
          controller: controller.usernameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(LocaleKeys.shared_username.tr),
          ),
          validator: (final value) => controller.validateUsername(value),
        ),
      );

  Widget _password() => Padding(
        padding: EdgeInsetsDirectional.only(
          top: ECommerceUtils.bodyVerticalPadding,
        ),
        child: TextFormField(
          controller: controller.passwordController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(LocaleKeys.shared_password.tr),
          ),
          validator: (final value) => controller.validatePassword(value),
        ),
      );

  Widget _repeatPassword() => Padding(
        padding: EdgeInsetsDirectional.only(
          top: ECommerceUtils.bodyVerticalPadding,
        ),
        child: TextFormField(
          controller: controller.repeatPasswordController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(LocaleKeys.shared_repeat_password.tr),
          ),
          validator: (final value) =>
              controller.validateRepeatedPassword(value),
        ),
      );

  Widget _address() => Padding(
        padding: EdgeInsetsDirectional.only(
          top: ECommerceUtils.bodyVerticalPadding,
          bottom: ECommerceUtils.bodyVerticalPadding,
        ),
        child: TextFormField(
          controller: controller.addressController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(LocaleKeys.shared_address.tr),
          ),
          validator: (final value) => controller.checkEmptyField(value),
        ),
      );

  Widget _signUp(final BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.only(
            bottom: ECommerceUtils.bodyVerticalPadding),
        child: Align(
          child: ElevatedButton(
            onPressed: () {
              if (controller.formKey.currentState!.validate()) {
                if (controller.imageBytes.value != null) {
                  controller.addUser();
                  //TODO go to user product page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.shared_no_picture_added.tr),
                    ),
                  );
                }
              }
            },
            child: Text(LocaleKeys.shared_signup.tr),
          ),
        ),
      );
}
