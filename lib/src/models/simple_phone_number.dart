import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class SimplePhoneNumber {
  final String national;
  final String isoCode;

  SimplePhoneNumber({
    required this.isoCode,
    required this.national,
  });

  SimplePhoneNumber.fromPhoneNumber(PhoneNumber phoneNumber)
      : isoCode = phoneNumber.isoCode,
        national = phoneNumber.nsn;

  SimplePhoneNumber copyWith({
    String? national,
    String? isoCode,
  }) {
    return SimplePhoneNumber(
      national: national ?? this.national,
      isoCode: isoCode ?? this.isoCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SimplePhoneNumber &&
        other.national == national &&
        other.isoCode == isoCode;
  }

  @override
  int get hashCode => national.hashCode ^ isoCode.hashCode;

  @override
  String toString() =>
      'SimplePhoneNumber(national: $national, isoCode: $isoCode)';
}
