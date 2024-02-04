import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization_en.dart';
import 'package:phone_form_field/phone_form_field.dart';

typedef PhoneNumberInputValidator = String? Function(
    PhoneNumber? phoneNumber, BuildContext context);

class PhoneValidator {
  /// allow to compose several validators
  /// Note that validator list order is important as first
  /// validator failing will return according message.
  static PhoneNumberInputValidator compose(
    List<PhoneNumberInputValidator> validators,
  ) {
    return (valueCandidate, context) {
      for (var validator in validators) {
        final validatorResult = validator.call(valueCandidate, context);
        if (validatorResult != null) {
          return validatorResult;
        }
      }
      return null;
    };
  }

  static PhoneNumberInputValidator required({
    /// custom error message
    String? errorText,
  }) {
    return (PhoneNumber? valueCandidate, BuildContext context) {
      if (valueCandidate == null || (valueCandidate.nsn.trim().isEmpty)) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.requiredPhoneNumber ??
            PhoneFieldLocalizationEn().requiredPhoneNumber;
      }
      return null;
    };
  }

  static PhoneNumberInputValidator invalid({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      valid(errorText: errorText, allowEmpty: allowEmpty);

  static PhoneNumberInputValidator valid({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) {
    return (PhoneNumber? valueCandidate, BuildContext context) {
      if (valueCandidate == null && !allowEmpty) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.invalidPhoneNumber ??
            PhoneFieldLocalizationEn().invalidPhoneNumber;
      }
      if (valueCandidate != null &&
          (!allowEmpty || valueCandidate.nsn.isNotEmpty) &&
          !valueCandidate.isValid()) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.invalidPhoneNumber ??
            PhoneFieldLocalizationEn().invalidPhoneNumber;
      }
      return null;
    };
  }

  static PhoneNumberInputValidator validType(
    /// expected phonetype
    PhoneNumberType expectedType, {
    /// custom error message
    String? errorText,
  }) {
    return (PhoneNumber? valueCandidate, BuildContext context) {
      if (valueCandidate != null &&
          valueCandidate.nsn.isNotEmpty &&
          !valueCandidate.isValid(type: expectedType)) {
        if (expectedType == PhoneNumberType.mobile) {
          return errorText ??
              PhoneFieldLocalization.of(context)?.invalidMobilePhoneNumber ??
              PhoneFieldLocalizationEn().invalidMobilePhoneNumber;
        } else if (expectedType == PhoneNumberType.fixedLine) {
          return errorText ??
              PhoneFieldLocalization.of(context)?.invalidFixedLinePhoneNumber ??
              PhoneFieldLocalizationEn().invalidFixedLinePhoneNumber;
        }
        return errorText ??
            PhoneFieldLocalization.of(context)?.invalidPhoneNumber ??
            PhoneFieldLocalizationEn().invalidPhoneNumber;
      }
      return null;
    };
  }

  /// convenience shortcut method for
  /// invalidType(context, PhoneNumberType.fixedLine, ...)
  static PhoneNumberInputValidator validFixedLine({
    /// custom error message
    String? errorText,
  }) =>
      validType(
        PhoneNumberType.fixedLine,
        errorText: errorText,
      );

  /// convenience shortcut method for
  /// invalidType(context, PhoneNumberType.mobile, ...)
  static PhoneNumberInputValidator validMobile({
    /// custom error message
    String? errorText,
  }) =>
      validType(
        PhoneNumberType.mobile,
        errorText: errorText,
      );

  static PhoneNumberInputValidator validCountry(
    /// list of valid country isocode
    List<IsoCode> expectedCountries, {
    /// custom error message
    String? errorText,
  }) {
    return (PhoneNumber? valueCandidate, BuildContext context) {
      if (valueCandidate != null &&
          (valueCandidate.nsn.isNotEmpty) &&
          !expectedCountries.contains(valueCandidate.isoCode)) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.invalidCountry ??
            PhoneFieldLocalizationEn().invalidCountry;
      }
      return null;
    };
  }

  static PhoneNumberInputValidator get none =>
      (PhoneNumber? valueCandidate, BuildContext context) {
        return null;
      };
}
