import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_locale.dart';

/// Kullanıcının seçtiği uygulama dilini cihazda saklar.
///
/// `EnvConfig` ile aynı desende: `main()` içinde uygulama ağacı
/// oluşturulmadan ÖNCE [load] çağrılır, böylece arayüz ilk karede zaten
/// doğru dille açılır (dil değişikliği "yanıp sönmesi" olmaz).
class AppLocaleStorage {
  AppLocaleStorage._();

  static const _storage = FlutterSecureStorage();
  static const _key = 'APP_LOCALE';

  static AppLocale _current = AppLocale.fallback;

  /// Kayıtlı dili belleğe yükler. Kayıtlı bir değer yoksa (ilk çalıştırma)
  /// cihazın sistem dili desteklenen diller arasındaysa o kullanılır;
  /// desteklenmiyorsa [AppLocale.fallback]'e düşülür. Kullanıcı ayarlar
  /// ekranından bir dil seçtiği anda bu otomatik tespit bir daha
  /// devreye girmez; [save] ile kaydedilen değer sonraki açılışlarda
  /// doğrudan kullanılır.
  static Future<void> load() async {
    final code = await _storage.read(key: _key);
    if (code != null) {
      _current = AppLocale.fromLanguageCode(code);
      return;
    }
    _current = _detectDeviceLocale();
  }

  /// Cihazın sistem dilini [AppLocale] listesiyle eşleştirir; eşleşme
  /// yoksa [AppLocale.fallback] döner. Yalnızca ilk kurulumda (kayıtlı
  /// dil yokken) kullanılır.
  static AppLocale _detectDeviceLocale() {
    final deviceLanguageCode = PlatformDispatcher.instance.locale.languageCode;
    return AppLocale.values.firstWhere(
      (locale) => locale.languageCode == deviceLanguageCode,
      orElse: () => AppLocale.fallback,
    );
  }

  /// main() içindeki [load] çağrısından sonra senkron olarak okunabilen,
  /// o anki dil.
  static AppLocale get current => _current;

  static Future<void> save(AppLocale locale) async {
    _current = locale;
    await _storage.write(key: _key, value: locale.languageCode);
  }
}
