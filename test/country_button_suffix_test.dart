import 'dart:math' as math;

import 'package:circle_flags/circle_flags.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_form_field/country_selector.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  Widget buildField({
    Widget? suffix,
    bool isCountryButtonPersistent = true,
    InputBorder? border,
    bool withLabel = false,
    TextDirection textDirection = TextDirection.ltr,
    bool enabled = true,
    bool showDropdownIcon = true,
    bool scrollable = false,
    ThemeData? theme,
  }) {
    final Widget field = PhoneFormField(
      initialValue: PhoneNumber.parse('+33612345678'),
      enabled: enabled,
      isCountryButtonPersistent: isCountryButtonPersistent,
      decoration: InputDecoration(
        border: border,
        labelText: withLabel ? 'Phone' : null,
      ),
      countryButtonStyle: CountryButtonStyle(
        showDropdownIcon: showDropdownIcon,
        suffix: suffix,
      ),
    );
    return MaterialApp(
      theme: theme,
      localizationsDelegates: PhoneFieldLocalization.delegates,
      supportedLocales: const [Locale('en')],
      // the directionality must be below MaterialApp, which otherwise resets
      // it from the locale
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          body: scrollable ? ListView(children: [field]) : field,
        ),
      ),
    );
  }

  Finder inCountryButton(Finder finder) =>
      find.descendant(of: find.byType(CountryButton), matching: finder);

  // the painted line of the divider, not the space it takes
  Rect lineRect(WidgetTester tester) => tester.getRect(find.descendant(
        of: find.byType(VerticalDivider),
        matching: find.byType(DecoratedBox),
      ));

  group('CountryButtonStyle.suffix layout', () {
    for (final textDirection in TextDirection.values) {
      for (final isCountryButtonPersistent in [true, false]) {
        for (final border in <InputBorder?>[
          null,
          const OutlineInputBorder(),
          const UnderlineInputBorder(),
        ]) {
          for (final withLabel in [false, true]) {
            final description = '${textDirection.name}, '
                'persistent: $isCountryButtonPersistent, '
                'border: ${border?.runtimeType}, '
                'label: $withLabel';

            testWidgets(
                'VerticalDivider is as tall as the button content and placed '
                'between the button and the number ($description)',
                (tester) async {
              Widget build({Widget? suffix}) => buildField(
                    suffix: suffix,
                    isCountryButtonPersistent: isCountryButtonPersistent,
                    border: border,
                    withLabel: withLabel,
                    textDirection: textDirection,
                  );

              await tester.pumpWidget(build());
              final fieldHeight = tester.getSize(find.byType(TextField)).height;
              final buttonLeft =
                  tester.getRect(find.byType(CountryButton)).left;

              await tester.pumpWidget(build(suffix: const VerticalDivider()));
              final line = lineRect(tester);
              final flag = tester.getRect(inCountryButton(
                find.byType(CircleFlag),
              ));
              final dialCode = tester.getRect(find.text('+ 33'));
              final dropdownIcon =
                  tester.getRect(find.byIcon(Icons.arrow_drop_down));
              final input = tester.getRect(find.byType(EditableText));
              final contentHeight = [
                flag.height,
                dialCode.height,
                dropdownIcon.height,
              ].reduce(math.max);

              // as tall as the content: not the 48px box of the prefix icon,
              // not the max height and not collapsed
              expect(line.height, moreOrLessEquals(contentHeight));
              expect(line.center.dy, moreOrLessEquals(flag.center.dy));
              // physical order: flag, dial code, icon, line, number
              expect(flag.right, lessThanOrEqualTo(dialCode.left));
              expect(dropdownIcon.right, lessThanOrEqualTo(line.left));
              expect(line.right, lessThanOrEqualTo(input.left));
              // nothing else moves
              expect(
                tester.getSize(find.byType(TextField)).height,
                moreOrLessEquals(fieldHeight),
              );
              expect(
                tester.getRect(find.byType(CountryButton)).left,
                moreOrLessEquals(buttonLeft),
              );
            });
          }
        }
      }
    }

    testWidgets('VerticalDivider does not collapse when height is unbounded',
        (tester) async {
      await tester.pumpWidget(buildField(
        suffix: const VerticalDivider(),
        scrollable: true,
      ));
      final dropdownIcon = tester.getRect(find.byIcon(Icons.arrow_drop_down));
      expect(lineRect(tester).height, greaterThan(0));
      expect(lineRect(tester).height, moreOrLessEquals(dropdownIcon.height));
    });

    testWidgets(
        'VerticalDivider is as tall as the content with compact density',
        (tester) async {
      await tester.pumpWidget(buildField(
        suffix: const VerticalDivider(),
        theme: ThemeData(visualDensity: VisualDensity.compact),
      ));
      final dropdownIcon = tester.getRect(find.byIcon(Icons.arrow_drop_down));
      expect(lineRect(tester).height, moreOrLessEquals(dropdownIcon.height));
    });
  });

  group('CountryButtonStyle.suffix behavior', () {
    testWidgets('Should not change the country button without suffix',
        (tester) async {
      await tester.pumpWidget(buildField());
      final countryButton = tester.widget<CountryButton>(
        find.byType(CountryButton),
      );
      expect(countryButton.suffix, isNull);
      expect(inCountryButton(find.byType(IntrinsicHeight)), findsNothing);
    });

    testWidgets('Should display the suffix inside the country button',
        (tester) async {
      const divider = VerticalDivider();
      await tester.pumpWidget(buildField(suffix: divider));
      final countryButton = tester.widget<CountryButton>(
        find.byType(CountryButton),
      );
      expect(countryButton.suffix, same(divider));
      expect(inCountryButton(find.byType(VerticalDivider)), findsOneWidget);
    });

    for (final isCountryButtonPersistent in [true, false]) {
      testWidgets(
          'Should open the country selector when the suffix is tapped '
          '(persistent: $isCountryButtonPersistent)', (tester) async {
        await tester.pumpWidget(buildField(
          suffix: const VerticalDivider(),
          isCountryButtonPersistent: isCountryButtonPersistent,
        ));
        expect(find.byType(CountrySelectorPage), findsNothing);
        await tester.tap(find.byType(VerticalDivider));
        await tester.pumpAndSettle();
        expect(find.byType(CountrySelectorPage), findsOneWidget);
      });
    }

    testWidgets('Should not open the country selector when disabled',
        (tester) async {
      await tester.pumpWidget(buildField(
        suffix: const VerticalDivider(),
        enabled: false,
      ));
      await tester.tap(find.byType(VerticalDivider), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelectorPage), findsNothing);
    });

    testWidgets('Should allow a custom dropdown icon', (tester) async {
      await tester.pumpWidget(buildField(
        showDropdownIcon: false,
        suffix: const Icon(Icons.expand_more),
      ));
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
      expect(inCountryButton(find.byIcon(Icons.expand_more)), findsOneWidget);
      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelectorPage), findsOneWidget);
    });

    testWidgets('Should not change the semantics of the country button',
        (tester) async {
      await tester.pumpWidget(buildField());
      final labelWithoutSuffix =
          tester.getSemantics(find.byType(CountryButton)).label;

      await tester.pumpWidget(buildField(suffix: const VerticalDivider()));
      final labelWithSuffix =
          tester.getSemantics(find.byType(CountryButton)).label;

      expect(labelWithSuffix, labelWithoutSuffix);
      expect(labelWithSuffix, contains('France'));
    });
  });

  group('CountryButton.suffix', () {
    Widget buildButton(
      Widget Function(Widget button) wrap, {
      TextDirection textDirection = TextDirection.ltr,
    }) {
      return MaterialApp(
        home: Directionality(
          textDirection: textDirection,
          child: Scaffold(
            body: wrap(CountryButton(
              isoCode: IsoCode.FR,
              onTap: () {},
              suffix: const VerticalDivider(),
            )),
          ),
        ),
      );
    }

    final wrappers = <String, Widget Function(Widget)>{
      'loose constraints': (button) => Center(child: button),
      'tight height': (button) => Center(
            child: SizedBox(height: 100, child: button),
          ),
      'unbounded height': (button) => ListView(children: [
            Align(alignment: Alignment.centerLeft, child: button),
          ]),
    };

    wrappers.forEach((name, wrap) {
      testWidgets('VerticalDivider is as tall as the content ($name)',
          (tester) async {
        await tester.pumpWidget(buildButton(wrap));
        final dropdownIcon = tester.getRect(find.byIcon(Icons.arrow_drop_down));
        expect(lineRect(tester).height, greaterThan(0));
        expect(lineRect(tester).height, moreOrLessEquals(dropdownIcon.height));
      });
    });

    testWidgets('Should display the suffix at the end of the button in rtl',
        (tester) async {
      await tester.pumpWidget(buildButton(
        (button) => Center(child: button),
        textDirection: TextDirection.rtl,
      ));
      final flag = tester.getRect(find.byType(CircleFlag));
      expect(lineRect(tester).right, lessThanOrEqualTo(flag.left));
    });
  });

  test('CountryButtonStyle.copyWith should keep or replace the suffix', () {
    const divider = VerticalDivider();
    const icon = Icon(Icons.expand_more);
    const style = CountryButtonStyle(suffix: divider);
    expect(const CountryButtonStyle().suffix, isNull);
    expect(style.copyWith(flagSize: 30).suffix, same(divider));
    expect(style.copyWith(suffix: icon).suffix, same(icon));
  });
}
