import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() async {
  group('PhoneValidator.compose', () {
    testWidgets('compose should test each validator',
        (WidgetTester tester) async {
      bool first = false;
      bool second = false;
      bool last = false;

      final validator = PhoneValidator.compose([
        (PhoneNumber? p) {
          first = true;
          return null;
        },
        (PhoneNumber? p) {
          second = true;
          return null;
        },
        (PhoneNumber? p) {
          last = true;
          return null;
        },
      ]);

      expect(
          validator(const PhoneNumber(isoCode: IsoCode.FR, nsn: '')), isNull);
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
          return null;
        },
        (PhoneNumber? p) {
          return 'validation failed';
        },
        (PhoneNumber? p) {
          lastValidationDone = true;
          return null;
        },
      ]);
      expect(validator(const PhoneNumber(isoCode: IsoCode.FR, nsn: '')),
          equals('validation failed'));
      expect(firstValidationDone, isTrue);
      expect(lastValidationDone, isFalse);
    });
  });

  group('PhoneValidator.required', () {
    testWidgets('should be required value', (WidgetTester tester) async {
      final validator = PhoneValidator.required();
      expect(
        validator(const PhoneNumber(isoCode: IsoCode.US, nsn: '')),
        equals('requiredPhoneNumber'),
      );

      final validatorWithText = PhoneValidator.required(
        errorText: 'custom message',
      );
      expect(
        validatorWithText(const PhoneNumber(isoCode: IsoCode.US, nsn: '')),
        equals('custom message'),
      );
    });
  });

  group('PhoneValidator.invalid', () {
    testWidgets('should be invalid', (WidgetTester tester) async {
      final validator = PhoneValidator.valid();
      expect(
        validator(const PhoneNumber(isoCode: IsoCode.FR, nsn: '123')),
        equals('invalidPhoneNumber'),
      );

      final validatorWithText = PhoneValidator.valid(
        errorText: 'custom message',
      );
      expect(
        validatorWithText(const PhoneNumber(isoCode: IsoCode.FR, nsn: '123')),
        equals('custom message'),
      );
    });

    testWidgets('should (not) be invalid when (no) value entered',
        (WidgetTester tester) async {
      final validator = PhoneValidator.valid();
      expect(
        validator(const PhoneNumber(isoCode: IsoCode.FR, nsn: '')),
        isNull,
      );

      final validatorNotEmpty = PhoneValidator.valid(allowEmpty: false);
      expect(
        validatorNotEmpty(const PhoneNumber(isoCode: IsoCode.FR, nsn: '')),
        equals('invalidPhoneNumber'),
      );
    });
  });

  group('PhoneValidator.type', () {
    testWidgets('should be invalid mobile type', (WidgetTester tester) async {
      final validator = PhoneValidator.validMobile();
      expect(
        validator(const PhoneNumber(isoCode: IsoCode.FR, nsn: '412345678')),
        equals('invalidMobilePhoneNumber'),
      );

      final validatorWithText = PhoneValidator.validMobile(
        errorText: 'custom type message',
      );
      expect(
        validatorWithText(
            const PhoneNumber(isoCode: IsoCode.FR, nsn: '412345678')),
        equals('custom type message'),
      );
    });

    testWidgets('should (not) be invalid mobile type when (no) value entered',
        (WidgetTester tester) async {
      final validator = PhoneValidator.validMobile();
      expect(
        validator(const PhoneNumber(isoCode: IsoCode.FR, nsn: '')),
        isNull,
      );

      final validatorNotEmpty = PhoneValidator.validMobile(allowEmpty: false);
      expect(
        validatorNotEmpty(const PhoneNumber(isoCode: IsoCode.FR, nsn: '')),
        equals('invalidMobilePhoneNumber'),
      );
    });

    testWidgets('should be invalid fixed line type',
        (WidgetTester tester) async {
      final validator = PhoneValidator.validFixedLine();
      expect(
        validator(const PhoneNumber(isoCode: IsoCode.FR, nsn: '612345678')),
        equals('invalidFixedLinePhoneNumber'),
      );

      final validatorWithText = PhoneValidator.validFixedLine(
        errorText: 'custom fixed type message',
      );
      expect(
        validatorWithText(
            const PhoneNumber(isoCode: IsoCode.FR, nsn: '612345678')),
        equals('custom fixed type message'),
      );
    });

    testWidgets(
        'should (not) be invalid fixed line type when (no) value entered',
        (WidgetTester tester) async {
      final validator = PhoneValidator.validFixedLine();
      expect(
          validator(const PhoneNumber(isoCode: IsoCode.FR, nsn: '')), isNull);

      final validatorNotEmpty =
          PhoneValidator.validFixedLine(allowEmpty: false);
      expect(
        validatorNotEmpty(const PhoneNumber(isoCode: IsoCode.FR, nsn: '')),
        equals('invalidFixedLinePhoneNumber'),
      );
    });
  });

  group('PhoneValidator.country', () {
    testWidgets('should be invalid country', (WidgetTester tester) async {
      final validator = PhoneValidator.validCountry([IsoCode.FR, IsoCode.BE]);
      expect(
        validator(const PhoneNumber(isoCode: IsoCode.US, nsn: '112')),
        equals('invalidCountry'),
      );
    });

    testWidgets('should (not) be invalid country when (no) value entered',
        (WidgetTester tester) async {
      final validator = PhoneValidator.validCountry([IsoCode.US, IsoCode.BE]);
      expect(
        validator(const PhoneNumber(isoCode: IsoCode.FR, nsn: '')),
        isNull,
      );

      final validatorNotEmpty = PhoneValidator.validCountry(
        [IsoCode.US, IsoCode.BE],
        allowEmpty: false,
      );
      expect(
        validatorNotEmpty(const PhoneNumber(isoCode: IsoCode.FR, nsn: '')),
        equals('invalidCountry'),
      );
    });
  });
}
