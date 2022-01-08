import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_picker/number_picker.dart';
import 'package:number_picker/src/widgets/add_button.dart';
import 'package:number_picker/src/widgets/subtract_button.dart';

void main() {
  testWidgets('number picker widget', (final tester) async {
    int initialValue = 5;
    const int maxValue = 10;
    const int minValue = 0;
    void getValue(final int newValue) {
      initialValue = newValue;
    }

    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: NumberPicker(
          getValue: getValue,
          initialValue: initialValue,
          maxValue: maxValue,
          minValue: minValue,
        ),
      ),
    ));

    final numberFinder = find.text('$initialValue');
    final addFinder = find.byType(AddButton);
    final subtractFinder = find.byType(SubtractButton);

    expect(numberFinder, findsOneWidget);
    expect(addFinder, findsOneWidget);
    expect(subtractFinder, findsOneWidget);
  });

  testWidgets('add button Check', (final tester) async {
    int initialValue = 8;
    const int maxValue = 10;
    const int minValue = 0;

    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: StatefulBuilder(
          builder: (final context, final setState) => NumberPicker(
            getValue: (final newValue) {
              setState(() => initialValue = newValue);
            },
            initialValue: initialValue,
            maxValue: maxValue,
            minValue: minValue,
          ),
        ),
      ),
    ));

    final addFinder =
        find.widgetWithIcon(InkWell, Icons.arrow_forward_ios_rounded);
    expect(addFinder, findsOneWidget);

    await tester.tap(addFinder);
    await tester.pump();
    await tester.tap(addFinder);
    await tester.pump();
    await tester.tap(addFinder);
    await tester.pump();
    await tester.tap(addFinder);
    await tester.pump();

    expect(find.text('$initialValue'), findsOneWidget);
  });

  testWidgets('subtract button check', (final tester) async {
    int initialValue = 3;
    const int maxValue = 10;
    const int minValue = 0;

    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: StatefulBuilder(
          builder: (final context, final setState) => NumberPicker(
            getValue: (final newValue) {
              setState(() => initialValue = newValue);
            },
            initialValue: initialValue,
            maxValue: maxValue,
            minValue: minValue,
          ),
        ),
      ),
    ));

    final subtractFinder =
        find.widgetWithIcon(InkWell, Icons.arrow_back_ios_rounded);
    expect(subtractFinder, findsOneWidget);

    await tester.tap(subtractFinder);
    await tester.pump();
    await tester.tap(subtractFinder);
    await tester.pump();
    await tester.tap(subtractFinder);
    await tester.pump();
    await tester.tap(subtractFinder);
    await tester.pump();

    expect(find.text('$initialValue'), findsOneWidget);
  });

  testWidgets('min max value check', (final tester) async {
    int initialValue = 8;
    const int maxValue = 0;
    const int minValue = 10;
    void getValue(final int newValue) {
      initialValue = newValue;
    }

    expect(() {
      NumberPicker(
        getValue: getValue,
        initialValue: initialValue,
        maxValue: maxValue,
        minValue: minValue,
      );
    }, throwsAssertionError);
  });

  testWidgets('initialValue range check', (final tester) async {
    int initialValue = 18;
    const int maxValue = 0;
    const int minValue = 0;
    void getValue(final int newValue) {
      initialValue = newValue;
    }

    expect(() {
      NumberPicker(
        getValue: getValue,
        initialValue: initialValue,
        maxValue: maxValue,
        minValue: minValue,
      );
    }, throwsAssertionError);
  });
}
