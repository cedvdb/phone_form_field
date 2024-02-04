import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/country_selection/country_list_view.dart';

void main() {
  group('PhoneFormField', () {
    final formKey = GlobalKey<FormState>();
    final phoneKey = GlobalKey<FormFieldState<PhoneNumber>>();

    Widget getWidget({
      Function(PhoneNumber?)? onChanged,
      Function(PhoneNumber?)? onSaved,
      Function(PointerDownEvent)? onTapOutside,
      PhoneNumber? initialValue,
      PhoneController? controller,
      bool showFlagInInput = true,
      bool showDialCode = true,
      PhoneNumberInputValidator? validator,
      bool enabled = true,
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
                onTapOutside: onTapOutside,
                showFlagInInput: showFlagInInput,
                showDialCode: showDialCode,
                controller: controller,
                validator: validator,
                enabled: enabled,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
          ),
        );

    testWidgets('Should display input', (tester) async {
      await tester.pumpWidget(
        getWidget(initialValue: PhoneNumber.parse('+33')),
      );
      expect(find.byType(PhoneFormField), findsOneWidget);
    });

    testWidgets('Should display country code', (tester) async {
      await tester.pumpWidget(getWidget());
      expect(find.byType(CountryButton), findsWidgets);
    });

    testWidgets('Should display flag', (tester) async {
      await tester.pumpWidget(getWidget());
      expect(find.byType(CircleFlag), findsWidgets);
    });

    testWidgets(
        'Should not show country selection when disabled and country chip is tapped',
        (tester) async {
      await tester.pumpWidget(getWidget(enabled: false));
      final countryChip =
          tester.widget<CountryButton>(find.byType(CountryButton));
      expect(countryChip.enabled, false);

      await tester.tap(find.byType(CountryButton), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(CountryListView), findsNothing);
    });

    group('Country code', () {
      testWidgets('Should open dialog when country code is clicked',
          (tester) async {
        await tester.pumpWidget(getWidget());
        expect(find.byType(CountryListView), findsNothing);
        await tester.tap(find.byType(PhoneFormField));
        await tester.pump(const Duration(seconds: 1));
        await tester.tap(find.byType(CountryButton));
        await tester.pumpAndSettle();
        expect(find.byType(CountryListView), findsOneWidget);
      });
      testWidgets('Should hide flag', (tester) async {
        await tester.pumpWidget(getWidget(showFlagInInput: false));
        expect(find.byType(CircleFlag), findsNothing);
      });

      testWidgets('Should format phone number', (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.FR,
        );

        await tester.pumpWidget(getWidget(initialValue: phoneNumber));
        await tester.pump(const Duration(seconds: 1));
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '677777777');
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('6 77 77 77 77'), findsOneWidget);
      });

      testWidgets('Should show dial code when showDialCode is true',
          (tester) async {
        PhoneNumber phoneNumber = PhoneNumber.parse('+33');

        await tester.pumpWidget(
          getWidget(
            initialValue: phoneNumber,
            showDialCode: true,
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('+ 33'), findsOneWidget);
      });

      testWidgets('Should hide dial code when showDialCode is false',
          (tester) async {
        PhoneNumber phoneNumber = PhoneNumber.parse('+33');

        await tester.pumpWidget(
          getWidget(
            initialValue: phoneNumber,
            showDialCode: false,
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('+ 33'), findsNothing);
      });
    });

    testWidgets('Should display initial value', (tester) async {
      await tester.pumpWidget(
        getWidget(
          initialValue: PhoneNumber.parse('+33478787827'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('+ 33'), findsWidgets);
      expect(find.text('4 78 78 78 27'), findsOneWidget);
    });

    testWidgets('Should change value of controller', (tester) async {
      final controller = PhoneController(
        initialValue: PhoneNumber.parse('+1'),
      );
      PhoneNumber? newValue;
      controller.addListener(() {
        newValue = controller.value;
      });
      await tester.pumpWidget(getWidget(controller: controller));
      final phoneField = find.byType(PhoneFormField);
      await tester.tap(phoneField);
      // non digits should not work
      await tester.enterText(phoneField, '123456789');
      expect(
        newValue,
        equals(PhoneNumber.parse('+1 123456789')),
      );
    });

    testWidgets('Should change value of input when controller changes',
        (tester) async {
      final controller = PhoneController();
      await tester.pumpWidget(getWidget(controller: controller));
      controller.value = PhoneNumber.parse('+33488997722');

      await tester.pumpAndSettle();

      expect(find.text('+ 33'), findsWidgets);
      expect(find.text(controller.value.formatNsn()), findsOneWidget);
    });

    testWidgets(
        'Should change value of country code chip when full number copy pasted',
        (tester) async {
      final controller = PhoneController();
      // ignore: unused_local_variable
      PhoneNumber? newValue;
      controller.addListener(() {
        newValue = controller.value;
      });
      await tester.pumpWidget(getWidget(controller: controller));
      final phoneField = find.byType(PhoneFormField);
      await tester.tap(phoneField);
      // non digits should not work
      await tester.enterText(phoneField, '+33 0488 99 77 22');
      await tester.pump();
      expect(controller.value.isoCode, equals(IsoCode.FR));
      expect(controller.value.nsn, equals('488997722'));
    });

    testWidgets('Should call onChange', (tester) async {
      bool changed = false;
      PhoneNumber? phoneNumber =
          PhoneNumber.parse('', destinationCountry: IsoCode.FR);
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
      final phoneField = find.byType(PhoneFormField);
      await tester.tap(phoneField);
      // non digits should not work
      await tester.enterText(phoneField, 'aaa');
      await tester.pump(const Duration(seconds: 1));
      expect(changed, equals(false));
      await tester.enterText(phoneField, '123');
      await tester.pump(const Duration(seconds: 1));
      expect(changed, equals(true));
      expect(
        phoneNumber,
        equals(PhoneNumber.parse('123', destinationCountry: IsoCode.FR)),
      );
    });

    group('validator', () {
      testWidgets(
          'Should display invalid message when no validator is specified and '
          'the phone number is invalid', (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.parse('+33');
        await tester.pumpWidget(getWidget(initialValue: phoneNumber));
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '9984');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(
          find.text(PhoneFieldLocalizationEn().invalidPhoneNumber),
          findsOneWidget,
        );
      });

      testWidgets(
          'Should display invalid mobile phone when PhoneValidator.validMobile'
          ' is used and the phone number is not a mobile phone number',
          (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.parse('+33');
        await tester.pumpWidget(getWidget(
          initialValue: phoneNumber,
          validator: PhoneValidator.validMobile(),
        ));
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '6 99 99 99 99');
        await tester.pumpAndSettle();
        expect(
          find.text(PhoneFieldLocalizationEn().invalidMobilePhoneNumber),
          findsNothing,
        );
        await tester.enterText(phoneField, '777');
        await tester.pumpAndSettle();
        expect(
          find.text(PhoneFieldLocalizationEn().invalidMobilePhoneNumber),
          findsOneWidget,
        );
      });

      testWidgets(
          'Should display invalid fixed line phone when PhoneValidator.validFixedLine'
          ' is used and the phone number is not a fixed line phone number',
          (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.parse('+32');
        await tester.pumpWidget(getWidget(
          initialValue: phoneNumber,
          validator: PhoneValidator.validFixedLine(),
        ));
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '67777777');
        await tester.pumpAndSettle();
        expect(
          find.text(PhoneFieldLocalizationEn().invalidFixedLinePhoneNumber),
          findsNothing,
        );
        await tester.enterText(phoneField, '777');
        await tester.pumpAndSettle();
        expect(
          find.text(PhoneFieldLocalizationEn().invalidFixedLinePhoneNumber),
          findsOneWidget,
        );
      });

      testWidgets(
          'should display error when PhoneValidator.required is used and the nsn is empty',
          (WidgetTester tester) async {
        final controller =
            PhoneController(initialValue: PhoneNumber.parse('+32 444'));
        await tester.pumpWidget(getWidget(
          controller: controller,
          validator: PhoneValidator.required(),
        ));
        controller.changeNationalNumber('');
        await tester.pumpAndSettle();

        expect(
          find.text(PhoneFieldLocalizationEn().requiredPhoneNumber),
          findsOneWidget,
        );
      });

      testWidgets(
        'should show error message when PhoneValidator.validCountry '
        'is used and the current country is invalid',
        (WidgetTester tester) async {
          final controller =
              PhoneController(initialValue: PhoneNumber.parse('+32 444'));
          await tester.pumpWidget(getWidget(
            controller: controller,
            validator: PhoneValidator.validCountry([IsoCode.FR, IsoCode.BE]),
          ));
          controller.changeCountry(IsoCode.US);
          await tester.pumpAndSettle();
          expect(
            find.text(PhoneFieldLocalizationEn().invalidCountry),
            findsOneWidget,
          );
        },
      );

      testWidgets('should validate against all validators when compose is used',
          (WidgetTester tester) async {
        bool first = false;
        bool second = false;
        bool last = false;

        final validator = PhoneValidator.compose([
          (PhoneNumber? p, BuildContext context) {
            first = true;
            return null;
          },
          (PhoneNumber? p, BuildContext context) {
            second = true;
            return null;
          },
          (PhoneNumber? p, BuildContext context) {
            last = true;
            return null;
          },
        ]);

        await tester.pumpWidget(
          getWidget(
            initialValue: PhoneNumber.parse('+33'),
            validator: validator,
          ),
        );
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '9999');
        await tester.pumpAndSettle();
        expect(first, isTrue);
        expect(second, isTrue);
        expect(last, isTrue);
      });

      testWidgets(
          'should stop and return first validator failure when compose is used',
          (WidgetTester tester) async {
        bool firstValidationDone = false;
        bool lastValidationDone = false;
        final validator = PhoneValidator.compose([
          (PhoneNumber? p, BuildContext context) {
            firstValidationDone = true;
            return null;
          },
          (PhoneNumber? p, BuildContext context) {
            return 'validation failed';
          },
          (PhoneNumber? p, BuildContext context) {
            lastValidationDone = true;
            return null;
          },
        ]);
        await tester.pumpWidget(
          getWidget(
            initialValue: PhoneNumber.parse('+33'),
            validator: validator,
          ),
        );
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '9999');
        await tester.pumpAndSettle();

        expect(find.text('validation failed'), findsOneWidget);
        expect(firstValidationDone, isTrue);
        expect(lastValidationDone, isFalse);
      });
    });

    group('Format', () {
      testWidgets('Should format when shouldFormat is true', (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.FR,
        );

        await tester.pumpWidget(getWidget(initialValue: phoneNumber));
        await tester.pump(const Duration(seconds: 1));
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '677777777');
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('6 77 77 77 77'), findsOneWidget);
      });
    });

    group('form field', () {
      testWidgets('Should call onSaved', (tester) async {
        bool saved = false;
        PhoneNumber? phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.FR,
        );
        void onSaved(PhoneNumber? p) {
          saved = true;
          phoneNumber = p;
        }

        await tester.pumpWidget(getWidget(
          initialValue: phoneNumber,
          onSaved: onSaved,
        ));
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '479281938');
        await tester.pump(const Duration(seconds: 1));
        formKey.currentState?.save();
        await tester.pump(const Duration(seconds: 1));
        expect(saved, isTrue);
        expect(
          phoneNumber,
          equals(
            PhoneNumber.parse(
              '479281938',
              destinationCountry: IsoCode.FR,
            ),
          ),
        );
      });

      testWidgets('Should call onTapOutside', (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.FR,
        );

        void onTapOutside(PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        }

        await tester.pumpWidget(getWidget(
          initialValue: phoneNumber,
          onTapOutside: onTapOutside,
        ));

        final FocusScopeNode primaryFocus =
            FocusManager.instance.primaryFocus as FocusScopeNode;

        // Verify that the PhoneFormField is unfocused
        expect(primaryFocus.focusedChild, isNull);

        // Tap on the PhoneFormField to focus it
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '479281938');
        await tester.pump(const Duration(seconds: 1));

        // Verify that the PhoneFormField has focus
        expect(primaryFocus.focusedChild, isNotNull);

        // Tap outside the PhoneFormField to unfocus it
        await tester.tap(find.byType(Scaffold));
        await tester.pumpAndSettle();

        // Verify that the PhoneFormField is unfocused
        expect(primaryFocus.focusedChild, isNull);
      });
      testWidgets(
          'Should call onTapOutside not unfocus keyboard if already unfocused',
          (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.FR,
        );

        void onTapOutside(PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        }

        await tester.pumpWidget(getWidget(
          initialValue: phoneNumber,
          onTapOutside: onTapOutside,
        ));

        // Verify that the PhoneFormField is unfocused initially
        expect(
          (FocusManager.instance.primaryFocus as FocusScopeNode).focusedChild,
          isNull,
        );
        // Tap outside the PhoneFormField
        await tester.tap(find.byType(Scaffold));
        await tester.pump();

        // Verify that the PhoneFormField is still unfocused
        expect(
          (FocusManager.instance.primaryFocus as FocusScopeNode).focusedChild,
          isNull,
        );
      });

      testWidgets('Should reset with form state', (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.parse('+33');

        await tester.pumpWidget(getWidget(initialValue: phoneNumber));
        await tester.pump(const Duration(seconds: 1));
        const national = '123456';
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, national);
        expect(find.text(national), findsOneWidget);
        formKey.currentState?.reset();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text(national), findsNothing);
      });
    });

    group('Directionality', () {
      testWidgets('Using textDirection.LTR on RTL context', (tester) async {
        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.rtl,
          child: getWidget(),
        ));
        final finder = find.byType(Directionality);
        final widget = finder.at(1).evaluate().single.widget as Directionality;
        expect(widget.textDirection, TextDirection.ltr);
      });
    });
  });
}
