import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyIntl {
  static AppLocalizations? _S;
  static AppLocalizations get S => _S!;

  static Locale? _locale;
  static Locale get locale => _locale!;

  static init() async {
    final preferred = PlatformDispatcher.instance.locales;
    const supported = AppLocalizations.supportedLocales;
    _locale = basicLocaleListResolution(preferred, supported);
    _S = await AppLocalizations.delegate.load(locale);
  }
}