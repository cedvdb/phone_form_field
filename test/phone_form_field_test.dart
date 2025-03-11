import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_selector/flutter_country_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/localization/generated/phone_field_localization_impl_en.dart';

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
      bool showDropdownIcon = true,
      PhoneNumberInputValidator Function(BuildContext)? validatorBuilder,
      bool enabled = true,
    }) =>
        MaterialApp(
          localizationsDelegates: PhoneFieldLocalization.delegates,
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: Builder(builder: (context) {
              return Form(
                key: formKey,
                child: PhoneFormField(
                  key: phoneKey,
                  initialValue: initialValue,
                  onChanged: onChanged,
                  onSaved: onSaved,
                  onTapOutside: onTapOutside,
                  countryButtonStyle: CountryButtonStyle(
                    showFlag: showFlagInInput,
                    showDialCode: showDialCode,
                    showDropdownIcon: showDropdownIcon,
                  ),
                  controller: controller,
                  validator: validatorBuilder?.call(context),
                  enabled: enabled,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              );
            }),
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
      final countryButtonFinder = find.byType(CountryButton);

      expect(
        find.descendant(
          of: countryButtonFinder,
          matching: find.byType(CircleFlag),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: countryButtonFinder,
          matching: find.byType(ColorFiltered),
        ),
        findsNothing,
      );
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

      expect(find.byType(CountrySelectorSheet), findsNothing);
      expect(find.byType(CountrySelectorPage), findsNothing);
    });

    group('Country code', () {
      testWidgets('Should open dialog when country code is clicked',
          (tester) async {
        await tester.pumpWidget(getWidget());
        expect(find.byType(CountrySelectorPage), findsNothing);
        await tester.tap(find.byType(PhoneFormField));
        await tester.pump(const Duration(seconds: 1));
        await tester.tap(find.byType(CountryButton));
        await tester.pumpAndSettle();
        expect(find.byType(CountrySelectorPage), findsOneWidget);
      });

      testWidgets('Should grey scale flag when disabled', (tester) async {
        await tester.pumpWidget(getWidget(enabled: false));
        final colorFil = find.byType(ColorFiltered);
        expect(colorFil, findsOne);

        expect(
          find.descendant(
            of: colorFil,
            matching: find.byType(CircleFlag),
          ),
          findsOneWidget,
        );
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

      testWidgets('Can delete phone number', (tester) async {
        final controller = PhoneController(
          initialValue: PhoneNumber.parse('+64'),
        );

        await tester.pumpWidget(getWidget(controller: controller));
        await tester.pump(const Duration(seconds: 1));
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '+64210000000');
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('+ 64'), findsOneWidget);
        expect(find.text('210 000 000'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pump();

        expect(controller.value.nsn, equals(''));
      });

      testWidgets('Can delete phone number with area code in parentheses',
          (tester) async {
        final controller = PhoneController(
          initialValue: PhoneNumber.parse('+1'),
        );

        await tester.pumpWidget(getWidget(controller: controller));
        await tester.pump(const Duration(seconds: 1));
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '+14165555555');
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('+ 1'), findsOneWidget);
        expect(find.text('(416) 555-5555'), findsOneWidget);

        // delete all digits up to the area code (416)
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);

        // attempt to delete area code
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);

        expect(find.text('(416'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);

        expect(find.text('(416)'), findsNothing);
        expect(controller.value.nsn, equals(''));
      });

      testWidgets('Can enter phone number with area code', (tester) async {
        final controller = PhoneController(
          initialValue: PhoneNumber.parse('+1'),
        );

        await tester.pumpWidget(getWidget(controller: controller));
        await tester.pump(const Duration(seconds: 1));
        final phoneField = find.byType(PhoneFormField);

        await tester.enterText(phoneField, '(416');

        await tester.pump(const Duration(seconds: 1));

        expect(find.text('+ 1'), findsOneWidget);
        expect(find.text('(416)'), findsOneWidget);
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

    testWidgets('Should hide dropdown icon when showDropDownIcon is false',
        (tester) async {
      await tester.pumpWidget(getWidget(showDropdownIcon: false));
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
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

    testWidgets('Should get value of controller as initial value',
        (tester) async {
      final controller = PhoneController();
      final phoneNumber = PhoneNumber.parse('+33488997722');
      controller.value = phoneNumber;
      await tester.pumpWidget(getWidget(controller: controller));

      final PhoneFormFieldState phoneFieldState =
          tester.state(find.byType(PhoneFormField));
      expect(phoneFieldState.value, equals(phoneNumber));
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

    testWidgets('Should call onChange when countryCode updated',
        (tester) async {
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
      await tester.tap(find.byType(CountryButton));
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelectorPage), findsOneWidget);
      await tester.tap(find.byType(ListTile).first);
      expect(changed, equals(true));
      expect(
        phoneNumber,
        equals(PhoneNumber.parse('', destinationCountry: IsoCode.AF)),
      );
    });

    group('validator', () {
      testWidgets(
          'Should display invalid message when PhoneValidator.valid is used '
          'and the phone number is invalid', (tester) async {
        PhoneNumber? phoneNumber = PhoneNumber.parse('+33');
        await tester.pumpWidget(
          getWidget(
            initialValue: phoneNumber,
            validatorBuilder: (context) => PhoneValidator.valid(context),
          ),
        );
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '9984');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(
          find.text(PhoneFieldLocalizationImplEn().invalidPhoneNumber),
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
          validatorBuilder: (context) => PhoneValidator.validMobile(context),
        ));
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '6 99 99 99 99');
        await tester.pumpAndSettle();
        expect(
          find.text(PhoneFieldLocalizationImplEn().invalidMobilePhoneNumber),
          findsNothing,
        );
        await tester.enterText(phoneField, '777');
        await tester.pumpAndSettle();
        expect(
          find.text(PhoneFieldLocalizationImplEn().invalidMobilePhoneNumber),
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
          validatorBuilder: (context) => PhoneValidator.validFixedLine(context),
        ));
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '67777777');
        await tester.pumpAndSettle();
        expect(
          find.text(PhoneFieldLocalizationImplEn().invalidFixedLinePhoneNumber),
          findsNothing,
        );
        await tester.enterText(phoneField, '777');
        await tester.pumpAndSettle();
        expect(
          find.text(PhoneFieldLocalizationImplEn().invalidFixedLinePhoneNumber),
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
          validatorBuilder: (context) => PhoneValidator.required(context),
        ));
        controller.changeNationalNumber('');
        await tester.pumpAndSettle();

        expect(
          find.text(PhoneFieldLocalizationImplEn().requiredPhoneNumber),
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
            validatorBuilder: (context) =>
                PhoneValidator.validCountry(context, [IsoCode.FR, IsoCode.BE]),
          ));
          controller.changeCountry(IsoCode.US);
          await tester.pumpAndSettle();
          expect(
            find.text(PhoneFieldLocalizationImplEn().invalidCountry),
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

        await tester.pumpWidget(
          getWidget(
            initialValue: PhoneNumber.parse('+33'),
            validatorBuilder: (context) => validator,
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
        await tester.pumpWidget(
          getWidget(
            initialValue: PhoneNumber.parse('+33'),
            validatorBuilder: (context) => validator,
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
        await tester.enterText(phoneField, '477889922');
        await tester.pump(const Duration(seconds: 1));
        formKey.currentState?.save();
        await tester.pump(const Duration(seconds: 1));
        expect(saved, isTrue);
        expect(
          phoneNumber,
          equals(
            PhoneNumber.parse(
              '477 88 99 22',
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
        await tester.enterText(phoneField, '488 22 33 44');
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
        PhoneNumber? phoneNumber = PhoneNumber.parse('+32');

        await tester.pumpWidget(getWidget(initialValue: phoneNumber));
        await tester.pump(const Duration(seconds: 1));
        const national = '477 88 99 22';
        final phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, national);
        await tester.pumpAndSettle();
        expect(find.text(national), findsOneWidget);
        formKey.currentState?.reset();
        await tester.pumpAndSettle();
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
