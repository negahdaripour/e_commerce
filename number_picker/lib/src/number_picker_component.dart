import 'package:flutter/material.dart';

import 'widgets/add_button.dart';
import 'widgets/subtract_button.dart';

class NumberPicker extends StatelessWidget {
  final void Function(int)? getValue;
  final int initialValue;
  final int maxValue;
  final int minValue;
  const NumberPicker(
      {required final this.getValue,
      required final this.initialValue,
      required final this.maxValue,
      required final this.minValue,
      final Key? key})
      : assert(
            minValue <= maxValue, 'minValue has to be smaller than maxValue'),
        assert(initialValue >= minValue && initialValue <= maxValue,
            'initialValue has to be between minValue and maxvalue'),
        super(key: key);

  @override
  Widget build(final BuildContext context) => Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _add(context),
          _amount(),
          _subtract(context),
        ],
      );

  Widget _add(final BuildContext context) => AddButton(
        initialValue: initialValue,
        getValue: getValue,
        isEnabled: initialValue < maxValue,
      );

  Widget _amount() {
    if (initialValue < minValue) {
      return Text(
        '$minValue',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    } else if (initialValue > maxValue) {
      return Text(
        '$maxValue',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    }
    return Text(
      '$initialValue',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _subtract(final BuildContext context) => SubtractButton(
      getValue: getValue,
      initialValue: initialValue,
      isEnabled: initialValue > minValue);
}
