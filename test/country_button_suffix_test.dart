import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_form_field/country_selector.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  group('CountryButtonStyle.suffix', () {
    Widget buildField({
      Widget? suffix,
      bool isCountryButtonPersistent = true,
      TextDirection textDirection = TextDirection.ltr,
    }) {
      return MaterialApp(
        localizationsDelegates: PhoneFieldLocalization.delegates,
        supportedLocales: const [Locale('en')],
        // below MaterialApp, which otherwise resets the direction
        home: Directionality(
          textDirection: textDirection,
          child: Scaffold(
            body: PhoneFormField(
              initialValue: PhoneNumber.parse('+33612345678'),
              isCountryButtonPersistent: isCountryButtonPersistent,
              countryButtonStyle: CountryButtonStyle(suffix: suffix),
            ),
          ),
        ),
      );
    }

    testWidgets('Should not change the country button without suffix',
        (tester) async {
      await tester.pumpWidget(buildField());
      expect(
        find.descendant(
          of: find.byType(CountryButton),
          matching: find.byType(IntrinsicHeight),
        ),
        findsNothing,
      );
    });

    for (final textDirection in TextDirection.values) {
      for (final isCountryButtonPersistent in [true, false]) {
        testWidgets(
            'Should display the suffix between the button and the number, '
            'as tall as the button content (${textDirection.name}, '
            'persistent: $isCountryButtonPersistent)', (tester) async {
          await tester.pumpWidget(buildField(
            suffix: const VerticalDivider(),
            isCountryButtonPersistent: isCountryButtonPersistent,
            textDirection: textDirection,
          ));
          // the painted line, not the space around it
          final line = tester.getRect(find.descendant(
            of: find.byType(VerticalDivider),
            matching: find.byType(DecoratedBox),
          ));
          final icon = tester.getRect(find.byIcon(Icons.arrow_drop_down));
          final input = tester.getRect(find.byType(EditableText));
          expect(line.height, moreOrLessEquals(icon.height));
          expect(icon.right, lessThanOrEqualTo(line.left));
          expect(line.right, lessThanOrEqualTo(input.left));
        });
      }
    }

    testWidgets('Should open the country selector when the suffix is tapped',
        (tester) async {
      await tester.pumpWidget(buildField(suffix: const VerticalDivider()));
      await tester.tap(find.byType(VerticalDivider));
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelectorPage), findsOneWidget);
    });
  });
}
