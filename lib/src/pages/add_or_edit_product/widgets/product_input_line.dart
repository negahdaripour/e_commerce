import 'package:flutter/material.dart';

class ProductInputLine extends StatelessWidget {
  final String label;
  final Widget child;

  const ProductInputLine(
      {required final this.label, required final this.child, final Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label),
          child,
        ],
      );
}
