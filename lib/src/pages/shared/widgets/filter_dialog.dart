import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/e_commerce_utils.dart';

class FilterDialog extends StatelessWidget {
  final double min;
  final double max;
  final RangeValues rangeValues;
  final void Function(RangeValues)? getRangeValues;
  final bool initialValue;
  final void Function(bool)? getValue;

  const FilterDialog(
      {required final this.initialValue,
      required final this.getValue,
      required final this.getRangeValues,
      required final this.rangeValues,
      required final this.min,
      required final this.max,
      final Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) => SimpleDialog(
        title: Center(child: Text(LocaleKeys.shared_price_filter.tr)),
        children: <Widget>[
          _priceRange(),
          _priceValues(),
          _divider(),
          _inStockFilter(context),
          _actions(context),
        ],
      );

  Widget _priceRange() => RangeSlider(
        values: rangeValues,
        divisions: calculateNumberOfDivisions(),
        onChanged: (final newRangeValues) {
          getRangeValues?.call(newRangeValues);
        },
        max: max,
        min: min,
      );

  int calculateNumberOfDivisions() => (max - min) ~/ 100;

  Widget _priceValues() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('${LocaleKeys.shared_price.tr} :'),
          Text('${rangeValues.start.toInt()}'),
          const Text(' - '),
          Text('${rangeValues.end.toInt()}'),
        ],
      );

  Widget _divider() => Padding(
        padding: EdgeInsets.all(ECommerceUtils.largePadding),
        child: const Divider(),
      );

  Widget _inStockFilter(final BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(LocaleKeys.shared_products_in_stock.tr),
          Checkbox(
              activeColor: const Color(0xffB00020),
              value: initialValue,
              onChanged: (final newValue) {
                getValue?.call(newValue ?? false);
              })
        ],
      );

  Widget _actions(final BuildContext context) => Row(
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Get.back(result: true);
            },
            child: Text(
              LocaleKeys.shared_filter.tr,
              style: const TextStyle(color: Color(0xffB00020)),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text(
              LocaleKeys.shared_cancel.tr,
              style: const TextStyle(color: Color(0xffB00020)),
            ),
          )
        ],
      );
}
