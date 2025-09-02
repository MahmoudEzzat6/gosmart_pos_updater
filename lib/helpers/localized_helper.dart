import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

extension LocaleHelper on BuildContext {
  String localizedValue({required String en, required String ar}) {
    return locale.languageCode == 'ar' ? ar : en;
  }
}
