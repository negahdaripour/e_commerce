import 'package:flutter/material.dart';

import '../infrastructure/utils/number_picker_utils.dart';

class AddButton extends StatelessWidget {
  final int initialValue;
  final void Function(int)? getValue;
  final bool isEnabled;
  const AddButton(
      {required final this.initialValue,
      required final this.getValue,
      required final this.isEnabled,
      final Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) =>
      isEnabled ? _enabledAdd(context) : _disabledAdd();

  Widget _disabledAdd() => Padding(
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
            Icons.add,
            size: NumberPickerUtils.iconSize,
            color: Colors.grey,
          ),
        ),
      ));

  Widget _enabledAdd(final BuildContext context) => Padding(
        padding: EdgeInsets.all(NumberPickerUtils.mediumPadding),
        child: InkWell(
          onTap: () {
            getValue?.call(initialValue + 1);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(NumberPickerUtils.buttonBorderRadius),
                border: Border.all(
                  color: Colors.black12,
                )),
            height: NumberPickerUtils.costumeButtonSize,
            width: NumberPickerUtils.costumeButtonSize,
            child: Icon(
              Icons.add,
              size: NumberPickerUtils.iconSize,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
}
