import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_locale.dart';
import 'translations/translations.dart';

/// Uygulama genelinde çevrilmiş metinlere erişim sağlar.
///
/// Doğrudan kullanmak yerine `context.l10n.t('anahtar')` şeklinde,
/// aşağıdaki `AppLocalizationsX` extension'ı üzerinden erişilmesi
/// önerilir.
class AppLocalizations {
  AppLocalizations(this.locale)
    : _current = appTranslations[AppLocale.fromLanguageCode(
        locale.languageCode,
      )]!;

  final Locale locale;
  final Map<String, String> _current;

  static final Map<String, String> _fallback =
      appTranslations[AppLocale.fallback]!;

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(
      localizations != null,
      'AppLocalizations.of() çağrıldı ama en yakın Localizations widget\'ı '
      'bulunamadı. MaterialApp/MaterialApp.router içine '
      'AppLocalizations.delegate eklendiğinden emin ol.',
    );
    return localizations!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// [key] için mevcut dildeki metni döner. Çeviri eksikse İngilizce/Türkçe
  /// fallback haritasına, o da yoksa anahtarın kendisine düşer — böylece
  /// eksik bir çeviri uygulamayı çökertmek yerine sadece o metni
  /// olduğu gibi (anahtar adıyla) gösterir.
  String t(String key) => _current[key] ?? _fallback[key] ?? key;

  /// `{param}` yer tutucuları içeren metinler için. Örn:
  /// `t('hello_name')` -> "Merhaba {name}" iken
  /// `tp('hello_name', {'name': 'Ada'})` -> "Merhaba Ada".
  String tp(String key, Map<String, String> params) {
    var value = t(key);
    for (final entry in params.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value);
    }
    return value;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocale.values.any((l) => l.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// `context.l10n.t('anahtar')` kısayolu.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
