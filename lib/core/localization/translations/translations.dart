import '../app_locale.dart';
import 'en.dart';
import 'tr.dart';

/// Her dil için anahtar -> metin haritası. Yeni bir dil eklerken buraya
/// bir satır eklemen yeterli (bkz. `app_locale.dart` başındaki yönerge).
final Map<AppLocale, Map<String, String>> appTranslations = {
  AppLocale.tr: trTranslations,
  AppLocale.en: enTranslations,
};
