import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/validator/phone_validator.dart';

void main() async {
  Future<BuildContext> getBuildContext(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          PhoneFieldLocalization.delegate,
        ],
        home: Material(
          child: Container(),
        ),
      ),
    );
    return tester.element(find.byType(Container));
  }

  group('PhoneValidator.compose', () {
    testWidgets('compose should test each validator',
        (WidgetTester tester) async {
      bool first = false;
      bool second = false;
      bool last = false;

      final validator = PhoneValidator.compose([
        (PhoneNumber? p) {
          first = true;
        },
        (PhoneNumber? p) {
          second = true;
        },
        (PhoneNumber? p) {
          last = true;
        },
      ]);

      expect(validator(PhoneNumber(isoCode: '', nsn: '')), isNull);
      expect(first, isTrue);
      expect(second, isTrue);
      expect(last, isTrue);
    });

    testWidgets('compose should stop and return first validator failure',
        (WidgetTester tester) async {
      bool firstValidationDone = false;
      bool lastValidationDone = false;
      final validator = PhoneValidator.compose([
        (PhoneNumber? p) {
          firstValidationDone = true;
        },
        (PhoneNumber? p) {
          return "validation failed";
        },
        (PhoneNumber? p) {
          lastValidationDone = true;
        },
      ]);
      expect(validator(PhoneNumber(isoCode: '', nsn: '')),
          equals("validation failed"));
      expect(firstValidationDone, isTrue);
      expect(lastValidationDone, isFalse);
    });
  });

  group('PhoneValidator.required', () {
    testWidgets('should be required value', (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.required(context);
      expect(
        validator(PhoneNumber(isoCode: 'US', nsn: '')),
        equals("Required phone number"),
      );

      final validatorWithText = PhoneValidator.required(
        context,
        errorText: 'custom message',
      );
      expect(
        validatorWithText(PhoneNumber(isoCode: 'US', nsn: '')),
        equals("custom message"),
      );
    });
  });

  group('PhoneValidator.invalid', () {
    testWidgets('should be invalid', (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.invalid(context);
      expect(
        validator(PhoneNumber(isoCode: 'FR', nsn: '123')),
        equals("Invalid phone number"),
      );

      final validatorWithText = PhoneValidator.invalid(
        context,
        errorText: 'custom message',
      );
      expect(
        validatorWithText(PhoneNumber(isoCode: 'FR', nsn: '123')),
        equals("custom message"),
      );
    });

    testWidgets('should (not) be invalid when (no) value entered',
        (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.invalid(context);
      expect(
        validator(PhoneNumber(isoCode: 'FR', nsn: '')),
        isNull,
      );

      final validatorNotEmpty =
          PhoneValidator.invalid(context, allowEmpty: false);
      expect(
        validatorNotEmpty(PhoneNumber(isoCode: 'FR', nsn: '')),
        equals("Invalid phone number"),
      );
    });
  });

  group('PhoneValidator.type', () {
    testWidgets('should be invalid mobile type', (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.invalidMobile(context);
      expect(
        validator(PhoneNumber(isoCode: 'FR', nsn: '412345678')),
        equals("Invalid mobile phone number"),
      );

      final validatorWithText = PhoneValidator.invalidMobile(
        context,
        errorText: 'custom type message',
      );
      expect(
        validatorWithText(PhoneNumber(isoCode: 'FR', nsn: '412345678')),
        equals("custom type message"),
      );
    });

    testWidgets('should (not) be invalid mobile type when (no) value entered',
        (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.invalidMobile(context);
      expect(
        validator(PhoneNumber(isoCode: 'FR', nsn: '')),
        isNull,
      );

      final validatorNotEmpty =
          PhoneValidator.invalidMobile(context, allowEmpty: false);
      expect(
        validatorNotEmpty(PhoneNumber(isoCode: 'FR', nsn: '')),
        equals("Invalid mobile phone number"),
      );
    });

    testWidgets('should be invalid fixed line type',
        (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.invalidFixedLine(context);
      expect(
        validator(PhoneNumber(isoCode: 'FR', nsn: '612345678')),
        equals("Invalid fixed line phone number"),
      );

      final validatorWithText = PhoneValidator.invalidFixedLine(
        context,
        errorText: 'custom fixed type message',
      );
      expect(
        validatorWithText(PhoneNumber(isoCode: 'FR', nsn: '612345678')),
        equals("custom fixed type message"),
      );
    });

    testWidgets(
        'should (not) be invalid fixed line type when (no) value entered',
        (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.invalidFixedLine(context);
      expect(validator(PhoneNumber(isoCode: 'FR', nsn: '')), isNull);

      final validatorNotEmpty =
          PhoneValidator.invalidFixedLine(context, allowEmpty: false);
      expect(
        validatorNotEmpty(PhoneNumber(isoCode: 'FR', nsn: '')),
        equals("Invalid fixed line phone number"),
      );
    });
  });

  group('PhoneValidator.country', () {
    testWidgets('should be invalid country', (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.invalidCountry(context, ['FR', 'BE']);
      expect(
        validator(PhoneNumber(isoCode: 'US', nsn: '112')),
        equals("Invalid country"),
      );
    });

    testWidgets('should (not) be invalid country when (no) value entered',
        (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.invalidCountry(context, ['US', 'BE']);
      expect(
        validator(PhoneNumber(isoCode: 'FR', nsn: '')),
        isNull,
      );

      final validatorNotEmpty = PhoneValidator.invalidCountry(
        context,
        ['US', 'BE'],
        allowEmpty: false,
      );
      expect(
        validatorNotEmpty(PhoneNumber(isoCode: 'FR', nsn: '')),
        equals("Invalid country"),
      );
    });

    testWidgets('country validator should refuse invalid isoCode',
        (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      expect(
        () => PhoneValidator.invalidCountry(context, ['INVALID_ISO_CODE']),
        throwsAssertionError,
      );
    });
  });
}
