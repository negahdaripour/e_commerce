import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => const Scaffold(
        body: Center(
            child: Icon(
          Icons.favorite,
          size: 180.0,
          color: Colors.black,
        )),
      );
}
