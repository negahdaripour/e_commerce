import 'package:flutter/material.dart';

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
  static const Color infoColor = Color(0xffB4C6D6);
  static const Color secondaryColor = Color(0xff9A8C98);
  static const Color backgroundColor = Color(0xffF2E9E4);
  static const Color accentColor = Color(0xffF98A62);
  static const Color textColor = Color(0xFF22223B);
  static const Color liteTextColor = Color(0xFFF2E9E4);
  static const Color borderColor = Color(0xFF797d88);
  static const Color iconColor = Color(0xFFD1495B);
  static const Color successColor = Color(0xFF57B894);
  static const Color dangerColor = Color(0xFFD1495B);
  static const Color warningColor = Color(0xFFF98A62);
  static const Color disabledColor = Color(0xFFC6C2C2);

  static const Color appBarBackgroundColor = Color(0xff442C2E);

  ThemeData get themeData => ThemeData(
        fontFamily: fontFamily,
        primarySwatch: primaryColor,
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        primaryColorBrightness: Brightness.light,
        primaryColorLight: primaryColor[200],
        primaryColorDark: primaryColor[900],
        accentColor: accentColor,
        accentColorBrightness: Brightness.light,
        canvasColor: backgroundColor,
        scaffoldBackgroundColor: Colors.white,
        bottomAppBarColor: primaryColor[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFfeeae6),
          iconTheme: IconThemeData(color: appBarBackgroundColor),
          actionsIconTheme: IconThemeData(color: appBarBackgroundColor),
          centerTitle: false,
          titleTextStyle:
              TextStyle(color: appBarBackgroundColor, fontSize: 18.0),
        ),
        cardColor: const Color(0xffffffff),
        dividerColor: const Color(0x1f000000),
        highlightColor: const Color(0x66bcbcbc),
        splashColor: const Color(0x66c8c8c8),
        selectedRowColor: const Color(0xfff5f5f5),
        unselectedWidgetColor: const Color(0x8a000000),
        disabledColor: disabledColor,
        buttonColor: const Color(0xffe0e0e0),
        toggleableActiveColor: const Color(0xff1e88e5),
        secondaryHeaderColor: const Color(0xffe3f2fd),
        backgroundColor: backgroundColor,
        dialogBackgroundColor: backgroundColor,
        indicatorColor: const Color(0xff2196f3),
        hintColor: const Color(0x8a000000),
        errorColor: dangerColor,
      );
}
