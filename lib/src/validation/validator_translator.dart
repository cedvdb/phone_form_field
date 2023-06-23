import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';

typedef _PhoneValidatorMessageDelegate = String? Function(BuildContext context);

class ValidatorTranslator {
  static final Map<String, _PhoneValidatorMessageDelegate> _validatorMessages =
      {
    'invalidPhoneNumber': (ctx) =>
        PhoneFieldLocalization.of(ctx)?.invalidPhoneNumber,
    'invalidCountry': (ctx) => PhoneFieldLocalization.of(ctx)?.invalidCountry,
    'invalidMobilePhoneNumber': (ctx) =>
        PhoneFieldLocalization.of(ctx)?.invalidMobilePhoneNumber,
    'invalidFixedLinePhoneNumber': (ctx) =>
        PhoneFieldLocalization.of(ctx)?.invalidFixedLinePhoneNumber,
    'requiredPhoneNumber': (ctx) =>
        PhoneFieldLocalization.of(ctx)?.requiredPhoneNumber,
  };

  static final Map<String, String> _defaults = {
    'invalidPhoneNumber': 'Invalid phone number',
    'invalidCountry': 'Invalid country',
    'invalidMobilePhoneNumber': 'Invalid mobile phone number',
    'invalidFixedLinePhoneNumber': 'Invalid fixedline phone number',
    'requiredPhoneNumber': 'required phone number',
  };

  /// Localised name depending on the current application locale
  /// If you have many LocalisedName to handle in a same context, consider
  /// supplying the second optional PhoneFieldLocalization to avoid
  /// walking up the widget to get [PhoneFieldLocalization] instance
  /// for each call.
  static String message(
    BuildContext context,
    String key,
  ) {
    String? name = getMessageFromKey(context, key);
    return name ?? _defaults[key] ?? key;
  }

  static String? getMessageFromKey(BuildContext ctx, String key) {
    final _PhoneValidatorMessageDelegate? translateFn = _validatorMessages[key];
    return translateFn?.call(ctx);
  }
}
