import 'package:flutter/material.dart';

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
      : super(key: key);

  @override
  Widget build(final BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _add(),
          _amount(),
          _subtract(),
        ],
      );

  Widget _add() {
    if (initialValue >= maxValue) {
      return _disabledAdd();
    } else {
      return _enabledAdd();
    }
  }

  Widget _disabledAdd() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.white10,
            ),
          ),
          height: 25.0,
          width: 25.0,
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
            color: Colors.grey,
          ),
        ),
      ));

  Widget _enabledAdd() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            getValue?.call(initialValue + 1);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.black12,
                )),
            height: 25.0,
            width: 25.0,
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 18,
              color: Color(0xffff6a11),
            ),
          ),
        ),
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

  Widget _subtract() {
    if (initialValue <= minValue) {
      return _disabledSubtract();
    } else {
      return _enabledSubtract();
    }
  }

  Widget _disabledSubtract() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.white10,
              ),
            ),
            height: 25.0,
            width: 25.0,
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.grey,
            ),
          ),
        ),
      );

  Widget _enabledSubtract() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            getValue?.call(initialValue - 1);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.black12,
              ),
            ),
            height: 25.0,
            width: 25.0,
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Color(0xffff6a11),
            ),
          ),
        ),
      );
}
