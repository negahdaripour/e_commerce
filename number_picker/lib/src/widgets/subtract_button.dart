import 'package:flutter/material.dart';

import '../infrastructure/utils/number_picker_utils.dart';

class SubtractButton extends StatelessWidget {
  final int initialValue;
  final void Function(int)? getValue;
  final bool isEnabled;
  const SubtractButton(
      {required final this.getValue,
      required final this.initialValue,
      required final this.isEnabled,
      final Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) =>
      isEnabled ? _enabledSubtract(context) : _disabledSubtract();

  Widget _disabledSubtract() => Padding(
        padding: EdgeInsets.all(NumberPickerUtils.mediumPadding),
        child: InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(NumberPickerUtils.buttonBorderRadius),
              border: Border.all(
                color: Colors.white10,
              ),
            ),
            height: NumberPickerUtils.costumeButtonSize,
            width: NumberPickerUtils.costumeButtonSize,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: NumberPickerUtils.iconSize,
              color: Colors.grey,
            ),
          ),
        ),
      );

  Widget _enabledSubtract(final BuildContext context) => Padding(
        padding: EdgeInsets.all(NumberPickerUtils.mediumPadding),
        child: InkWell(
          onTap: () {
            getValue?.call(initialValue - 1);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(NumberPickerUtils.buttonBorderRadius),
              border: Border.all(
                color: Colors.black12,
              ),
            ),
            height: NumberPickerUtils.costumeButtonSize,
            width: NumberPickerUtils.costumeButtonSize,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: NumberPickerUtils.iconSize,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
}
