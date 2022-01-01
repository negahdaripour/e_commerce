import 'package:flutter/material.dart';

import '../../../infrastructure/utils/e_commerce_utils.dart';

class Tags extends StatelessWidget {
  final List<String> tags;

  const Tags({required final this.tags, final Key? key}) : super(key: key);

  Widget _itemBuilder(final int index) => Padding(
        padding: EdgeInsetsDirectional.only(end: ECommerceUtils.largePadding),
        child: ChoiceChip(
          label: Text(tags[index]),
          selected: false,
        ),
      );

  @override
  Widget build(final BuildContext context) => SizedBox(
        height: ECommerceUtils.tagsHeight,
        child: Padding(
          padding: EdgeInsets.only(bottom: ECommerceUtils.largePadding),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(tags.length, _itemBuilder),
          ),
        ),
      );
}
