class PhoneNumberInput {
  final String national;
  final String isoCode;

  PhoneNumberInput({
    required this.isoCode,
    required this.national,
  });

  PhoneNumberInput copyWith({
    String? national,
    String? isoCode,
  }) {
    return PhoneNumberInput(
      national: national ?? this.national,
      isoCode: isoCode ?? this.isoCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhoneNumberInput &&
        other.national == national &&
        other.isoCode == isoCode;
  }

  @override
  int get hashCode => national.hashCode ^ isoCode.hashCode;
}
