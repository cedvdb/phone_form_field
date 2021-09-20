import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_form_field/phone_form_field.dart';

typedef PhoneNumberInputValidator = String? Function(PhoneNumber? phoneNumber);

class PhoneValidator {
  /// allow to compose several validators
  /// Note that validator list order is important as first
  /// validator failing will return according message.
  static PhoneNumberInputValidator compose(
      List<PhoneNumberInputValidator> validators) {
    return (valueCandidate) {
      for (var validator in validators) {
        final validatorResult = validator.call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }
      return null;
    };
  }

  static PhoneNumberInputValidator required(
    BuildContext context, {

    /// custom error message
    String? errorText,
  }) {
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate == null || (valueCandidate.nsn.trim().isEmpty)) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.requiredPhoneNumber ??
            'Required phone number';
      }
      return null;
    };
  }

  static PhoneNumberInputValidator invalid(
    BuildContext context, {

    /// custom error message
    String? errorText,

    /// determine if lightParser should be used for validating number,
    /// lightParser uses less memory but use only length to
    /// validate input number
    bool useLightParser = false,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) {
    final parser = PhoneParser();
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate != null &&
          (!allowEmpty || valueCandidate.nsn.isNotEmpty) &&
          !parser.validate(valueCandidate)) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.invalidPhoneNumber;
        // ??
        // 'Invalid phone number';
      }
      return null;
    };
  }

  static PhoneNumberInputValidator invalidType(
    BuildContext context,

    /// expected phonetype
    PhoneNumberType expectedType, {

    /// custom error message
    String? errorText,

    /// determine if lightParser should be used for validating number,
    /// lightParser uses less memory but use only length to
    /// validate input number
    bool useLightParser = false,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) {
    final defaultMessage = expectedType == PhoneNumberType.mobile
        ? PhoneFieldLocalization.of(context)?.invalidMobilePhoneNumber ??
            'Invalid mobile phone number'
        : PhoneFieldLocalization.of(context)?.invalidFixedLinePhoneNumber ??
            'Invalid fixed line phone number';
    final parser = PhoneParser();
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate != null &&
          (!allowEmpty || valueCandidate.nsn.isNotEmpty) &&
          !parser.validate(valueCandidate, expectedType)) {
        return errorText ?? defaultMessage;
      }
      return null;
    };
  }

  /// convenience shortcut method for
  /// invalidType(context, PhoneNumberType.fixedLine, ...)
  static PhoneNumberInputValidator invalidFixedLine(
    BuildContext context, {

    /// custom error message
    String? errorText,

    /// determine if lightParser should be used for validating number,
    /// lightParser uses less memory but use only length to
    /// validate input number
    bool useLightParser = false,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      invalidType(
        context,
        PhoneNumberType.fixedLine,
        errorText: errorText,
        useLightParser: useLightParser,
        allowEmpty: allowEmpty,
      );

  /// convenience shortcut method for
  /// invalidType(context, PhoneNumberType.mobile, ...)
  static PhoneNumberInputValidator invalidMobile(
    BuildContext context, {

    /// custom error message
    String? errorText,

    /// determine if lightParser should be used for validating number,
    /// lightParser uses less memory but use only length to
    /// validate input number
    bool useLightParser = false,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      invalidType(
        context,
        PhoneNumberType.mobile,
        errorText: errorText,
        useLightParser: useLightParser,
        allowEmpty: allowEmpty,
      );

  static PhoneNumberInputValidator invalidCountry(
    BuildContext context,

    /// list of valid country isocode
    List<String> expectedCountries, {

    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) {
    assert(
      expectedCountries.every((isoCode) => isoCodes.contains(isoCode)),
      'Each expectedCountries value be valid country isoCode',
    );

    return (PhoneNumber? valueCandidate) {
      if (valueCandidate != null &&
          (!allowEmpty || valueCandidate.nsn.isNotEmpty) &&
          !expectedCountries.contains(valueCandidate.isoCode)) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.invalidCountry ??
            'Invalid country';
      }
      return null;
    };
  }

  static PhoneNumberInputValidator get none => (PhoneNumber? valueCandidate) {};
}
