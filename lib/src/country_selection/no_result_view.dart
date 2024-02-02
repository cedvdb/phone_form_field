import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization_en.dart';

class NoResultView extends StatelessWidget {
  final String? title;
  const NoResultView({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title ??
            PhoneFieldLocalization.of(context)?.noResultMessage ??
            PhoneFieldLocalizationEn().noResultMessage,
        key: const ValueKey('no-result'),
      ),
    );
  }
}
