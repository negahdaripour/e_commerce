import 'package:flutter/material.dart';

class NumberPicker extends StatelessWidget {
  final void Function(int)? getValue;
  final int initialValue;
  const NumberPicker(
      {required final this.getValue,
      required final this.initialValue,
      final Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
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
          ),
          Text(
            '$initialValue',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
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
                    )),
                height: 25.0,
                width: 25.0,
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Color(0xffff6a11),
                ),
              ),
            ),
          ),
        ],
      );
}
