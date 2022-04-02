import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  group('PhoneFormField', () {
    final formKey = GlobalKey<FormState>();
    final phoneKey = GlobalKey<FormFieldState<PhoneNumber>>();
    Widget getWidget({
      Function(PhoneNumber?)? onChanged,
      Function(PhoneNumber?)? onSaved,
      PhoneNumber? initialValue,
      PhoneController? controller,
      bool showFlagInInput = true,
      IsoCode defaultCountry = IsoCode.US,
      bool shouldFormat = false,
      PhoneNumberInputValidator? validator,
    }) =>
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            PhoneFieldLocalization.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: Form(
              key: formKey,
              child: PhoneFormField(
                key: phoneKey,
                initialValue: initialValue,
                onChanged: onChanged,
                onSaved: onSaved,
                showFlagInInput: showFlagInInput,
                controller: controller,
                defaultCountry: defaultCountry,
                shouldFormat: shouldFormat,
                validator: validator,
              ),
            ),
          ),
        );

    group('display', () {
      testWidgets('Should display input', (tester) async {
        await tester.pumpWidget(getWidget());
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('Should display country code', (tester) async {
        await tester.pumpWidget(getWidget());
        expect(find.byType(CountryCodeChip), findsWidgets);
      });

      testWidgets('Should display flag', (tester) async {
        await tester.pumpWidget(getWidget());
        expect(find.byType(CircleFlag), findsWidgets);
      });
    });

    group('Country code', () {
      testWidgets('Should open dialog when country code is clicked',
          (tester) async {
        await tester.pumpWidget(getWidget());
        expect(find.byType(CountrySelector), findsNothing);
        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('country-code-overlay')));
        await tester.pumpAndSettle();
        expect(find.byType(CountrySelector), findsOneWidget);
      });
      testWidgets('Should have a default country', (tester) async {
        await tester.pumpWidget(getWidget(defaultCountry: IsoCode.FR));
        expect(find.text('+ 33'), findsWidgets);
      });

      testWidgets('Should hide flag', (tester) async {
        await tester.pumpWidget(getWidget(showFlagInInput: false));
        expect(find.byType(CircleFlag), findsNothing);
      });
    });

    group('value changes', () {
      testWidgets('Should display initial value', (tester) async {
        await tester.pumpWidget(getWidget(
            initialValue: PhoneNumber.fromIsoCode(IsoCode.FR, '478787827')));
        expect(find.text('+ 33'), findsWidgets);
        expect(find.text('478787827'), findsOneWidget);
      });

      testWidgets('Should change value of controller', (tester) async {
        final controller = PhoneController(null);
        PhoneNumber? newValue;
        controller.addListener(() {
          newValue = controller.value;
        });
        await tester.pumpWidget(
            getWidget(controller: controller, defaultCountry: IsoCode.US));
        final textField = find.byType(TextField);
        await tester.tap(textField);
        // non digits should not work
        await tester.enterText(textField, '123456789');
        expect(
            newValue, equals(PhoneNumber.fromIsoCode(IsoCode.US, '123456789')));
      });

      testWidgets('Should change value of input when controller changes',
          (tester) async {
        final controller = PhoneController(null);
        // ignore: unused_local_variable
        PhoneNumber? newValue;
        controller.addListener(() {
          newValue = controller.value;
        });
        await tester.pumpWidget(
            getWidget(controller: controller, defaultCountry: IsoCode.US));
        controller.value = PhoneNumber.fromIsoCode(IsoCode.FR, '488997722');
        await tester.pumpAndSettle();
        expect(find.text('+ 33'), findsWidgets);
        expect(find.text('488997722'), findsOneWidget);
      });
      testWidgets(
          'Should change value of country code chip when full number copy pasted',
          (tester) async {
        final controller = PhoneController(null);
        // ignore: unused_local_variable
        PhoneNumber? newValue;
        controller.addListener(() {
          newValue = controller.value;
        });
        await tester.pumpWidget(
            getWidget(controller: controller, defaultCountry: IsoCode.US));
        final textField = find.byType(TextField);
        await tester.tap(textField);
        // non digits should not work
        await tester.enterText(textField, '+33 0488 99 77 22');
        await tester.pump();
        expect(controller.value?.isoCode, equals(IsoCode.FR));
        expect(controller.value?.nsn, equals('488997722'));
      });

      testWidgets('Should call onChange', (tester) async {
        bool changed = false;
        PhoneNumber? phoneNumber = PhoneNumber.fromIsoCode(IsoCode.FR, '');
        void onChanged(PhoneNumber? p) {
          changed = true;
          phoneNumber = p;
        }

        await tester.pumpWidget(
          getWidget(
            initialValue: phoneNumber,
            onChanged: onChanged,
          ),
        );
        final textField = find.byType(TextField);
        await tester.tap(textField);
        // non digits should not work
        await tester.enterText(textField, 'aaa');
        await tester.pumpAndSettle();
        expect(changed, equals(false));
        await tester.enterText(textField, '123');
        await tester.pumpAndSettle();
        expect(changed, equals(true));
        expect(phoneNumber, equals(PhoneNumber.fromIsoCode(IsoCode.FR, '123')));
      });
    });

    group('validity', () {
      testWidgets('Should tell when a phone number is not valid',
          (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.fromIsoCode(IsoCode.FR, '');
        await tester.pumpWidget(getWidget(initialValue: phoneNumber));
        final foundTextField = find.byType(TextField);
        await tester.enterText(foundTextField, '9984');
        await tester.pumpAndSettle();

        expect(find.text('Invalid phone number'), findsOneWidget);
      });

      testWidgets(
          'Should tell when a phone number is not valid for a given phone number type',
          (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.fromIsoCode(IsoCode.BE, '');
        // valid fixed line
        await tester.pumpWidget(getWidget(
          initialValue: phoneNumber,
          validator: PhoneValidator.validFixedLine(),
        ));
        final foundTextField = find.byType(TextField);
        await tester.enterText(foundTextField, '77777777');
        await tester.pumpAndSettle();
        expect(find.text('Invalid'), findsNothing);
        // invalid mobile
        await tester.pumpWidget(getWidget(
          initialValue: phoneNumber,
          validator: PhoneValidator.validMobile(
            errorText: 'Invalid phone number',
          ),
        ));
        final foundTextField2 = find.byType(TextField);
        await tester.pumpAndSettle();
        await tester.enterText(foundTextField2, '77777777');
        await tester.pumpAndSettle();
        expect(find.text('Invalid phone number'), findsOneWidget);

        // valid mobile
        await tester.pumpWidget(getWidget(
          initialValue: phoneNumber,
          validator: PhoneValidator.validMobile(
            errorText: 'Invalid phone number',
          ),
        ));
        final foundTextField3 = find.byType(TextField);
        await tester.enterText(foundTextField3, '477668899');
        await tester.pumpAndSettle();
        expect(find.text('Invalid'), findsNothing);
      });
    });

    group('Format', () {
      testWidgets('Should format when shouldFormat is true', (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.fromIsoCode(IsoCode.FR, '');

        await tester.pumpWidget(
            getWidget(initialValue: phoneNumber, shouldFormat: true));
        await tester.pumpAndSettle();
        final foundTextField = find.byType(TextField);
        await tester.enterText(foundTextField, '677777777');
        await tester.pumpAndSettle();
        expect(find.text('6 77 77 77 77'), findsOneWidget);
      });
      testWidgets('Should not format when shouldFormat is false',
          (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.fromIsoCode(IsoCode.FR, '');

        await tester.pumpWidget(
            getWidget(initialValue: phoneNumber, shouldFormat: false));
        await tester.pumpAndSettle();
        final foundTextField = find.byType(TextField);
        await tester.enterText(foundTextField, '677777777');
        await tester.pumpAndSettle();
        expect(find.text('677777777'), findsOneWidget);
      });
    });

    group('form field', () {
      testWidgets('Should call onSaved', (tester) async {
        bool saved = false;
        PhoneNumber? phoneNumber = PhoneNumber.fromIsoCode(IsoCode.FR, '');
        void onSaved(PhoneNumber? p) {
          saved = true;
          phoneNumber = p;
        }

        await tester.pumpWidget(getWidget(
          initialValue: phoneNumber,
          onSaved: onSaved,
        ));
        final foundTextField = find.byType(TextField);
        await tester.enterText(foundTextField, '479281938');
        await tester.pumpAndSettle();
        formKey.currentState?.save();
        await tester.pumpAndSettle();
        expect(saved, isTrue);
        expect(phoneNumber,
            equals(PhoneNumber.fromIsoCode(IsoCode.FR, '479281938')));
      });

      testWidgets('Should reset', (tester) async {
        PhoneNumber? phoneNumber =
            PhoneNumber.fromIsoCode(IsoCode.FR, 'national');

        await tester.pumpWidget(getWidget(initialValue: phoneNumber));
        await tester.pumpAndSettle();
        const national = '123456';
        final foundTextField = find.byType(TextField);
        await tester.enterText(foundTextField, national);
        expect(find.text(national), findsOneWidget);
        formKey.currentState?.reset();
        await tester.pumpAndSettle();
        expect(find.text(national), findsNothing);
      });
    });
  });
}
