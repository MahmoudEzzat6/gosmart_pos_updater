import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageDropdownWidget extends StatefulWidget {
  const LanguageDropdownWidget({super.key});

  @override
  State<LanguageDropdownWidget> createState() => _LanguageDropdownWidgetState();
}

class _LanguageDropdownWidgetState extends State<LanguageDropdownWidget> {
  Locale? _selectedLocale;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('languageCode') ?? 'en'; // default English
    setState(() {
      _selectedLocale = Locale(langCode);
    });
  }

  Future<void> _saveLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: _selectedLocale,
      hint: const Text('select_language').tr(),
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('ar'),
          child: Text('العربية'),
        ),
      ],
      onChanged: (locale) {
        if (locale != null) {
          setState(() {
            _selectedLocale = locale;
          });
          _saveLanguage(locale);
        }
      },
    );
  }
}
