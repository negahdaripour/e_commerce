import 'package:flutter/material.dart';

import '../utils/e_commerce_utils.dart';

class CustomMaterialTheme {
  late final String fontFamily;

  CustomMaterialTheme({required final this.fontFamily});

  static const MaterialColor primaryColor = MaterialColor(0xffff6a11, {
    50: Color(0xFFfeeae6),
    100: Color(0xFFffb28e),
    200: Color(0xffffb28e),
    300: Color(0xffff9561),
    400: Color(0xffff7e3c),
    500: Color(0xffff6a11),
    600: Color(0xfff8640c),
    700: Color(0xffea5c05),
    800: Color(0xffdc5502),
    900: Color(0xffc34800),
  });

  static const MaterialColor secondaryColor = MaterialColor(0xffB00020, {
    50: Color(0xFFffeaec),
    100: Color(0xFFffcbcd),
    200: Color(0xfff39791),
    300: Color(0xffea6e66),
    400: Color(0xfff34c3f),
    500: Color(0xfff63a1d),
    600: Color(0xffe82e1f),
    700: Color(0xffd6221a),
    800: Color(0xffc91911),
    900: Color(0xffbb0000),
  });

  static const Color fontColor = Color(0xff442C2E);
  static const Color costumeGrey = Color(0xff707070);
  static const Color costumeGreyLight = Color(0xffE0E0E0);
  static const Color focusedBorder = Color(0xffff9561);
  static const Color flatButtonText = Color(0xffEE8C6D);
  static const Color tagBackground = Color(0xFFfeeae6);
  static const Color favoriteColor = Color(0xffbb0000);

  ThemeData get themeData => ThemeData(
        fontFamily: fontFamily,
        brightness: Brightness.light,
        primaryColor: primaryColor,
        primaryColorBrightness: Brightness.light,
        primaryColorLight: primaryColor[50],
        primaryColorDark: primaryColor[900],
        secondaryHeaderColor: secondaryColor,
        primarySwatch: secondaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFfeeae6),
          iconTheme: const IconThemeData(color: fontColor),
          actionsIconTheme: const IconThemeData(color: fontColor),
          centerTitle: false,
          titleTextStyle: TextStyle(
              color: fontColor, fontSize: 17.0, fontFamily: fontFamily),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: costumeGrey)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: focusedBorder)),
          labelStyle: TextStyle(
            color: costumeGrey,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor[200],
            onPrimary: fontColor,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: secondaryColor[900],
            backgroundColor: secondaryColor[100],
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(
                    style: BorderStyle.solid, color: costumeGreyLight),
                onSurface: flatButtonText)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: fontColor,
          backgroundColor: primaryColor,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: tagBackground,
          brightness: Brightness.light,
          disabledColor: tagBackground,
          deleteIconColor: primaryColor,
          labelStyle: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
          ),
          padding: EdgeInsets.all(ECommerceUtils.mediumPadding),
          secondaryLabelStyle: TextStyle(color: primaryColor[500]),
          secondarySelectedColor: tagBackground,
          selectedColor: tagBackground,
          shape: const StadiumBorder(
            side: BorderSide(
              color: primaryColor,
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: costumeGrey, fontWeight: FontWeight.w400),
        ),
        listTileTheme: ListTileThemeData(
          textColor: fontColor,
          tileColor: primaryColor[50],
          style: ListTileStyle.list,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          linearTrackColor: primaryColor,
          circularTrackColor: primaryColor,
          color: primaryColor[200],
          refreshBackgroundColor: primaryColor[200],
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor)
            .copyWith(secondary: secondaryColor),
        dividerTheme: const DividerThemeData(color: costumeGrey),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((final states) {
            if (states.contains(MaterialState.selected)) {
              return primaryColor;
            } else {
              return costumeGrey;
            }
          }),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((final states) {
            if (states.contains(MaterialState.selected)) {
              return primaryColor;
            } else {
              return Colors.white;
            }
          }),
          trackColor: MaterialStateProperty.resolveWith((final states) {
            if (states.contains(MaterialState.selected)) {
              return primaryColor[200];
            } else {
              return Colors.grey;
            }
          }),
        ),
        sliderTheme: const SliderThemeData(
          trackHeight: 1.0,
          activeTrackColor: secondaryColor,
          thumbColor: secondaryColor,
        ),
      );
}
