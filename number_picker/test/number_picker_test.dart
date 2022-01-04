import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_picker/number_picker.dart';

void main() {
  testWidgets('number picker widget', (final tester) async {
    const int initialValue = 5;
    const int maxValue = 3;
    const int minValue = 0;

    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: NumberPicker(
          getValue: (final newValue) {
            print('------------------------------------');
            print('$newValue');
          },
          initialValue: initialValue,
          maxValue: maxValue,
          minValue: minValue,
        ),
      ),
    ));

    final numberFinder = find.text('$initialValue');
    final addFinder =
        find.widgetWithIcon(InkWell, Icons.arrow_back_ios_rounded);
    final subtractFinder =
        find.widgetWithIcon(InkWell, Icons.arrow_forward_ios_rounded);

    // expect(numberFinder, findsOneWidget);
    expect(addFinder, findsOneWidget);
    expect(subtractFinder, findsOneWidget);

    await tester.tap(addFinder);
    await tester.pump();
    await tester.tap(addFinder);
    await tester.pump();

    final enabledAddFinder = find.byWidget(
      const Icon(
        Icons.arrow_back_ios_rounded,
        size: 18,
        color: Color(0xffff6a11),
      ),
    );

    final enabledSubtractFinder = find.byWidget(
      const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18,
        color: Color(0xffff6a11),
      ),
    );

    // expect(enabledAddFinder, findsOneWidget);
    // expect(enabledSubtractFinder, findsOneWidget);
  });
}
