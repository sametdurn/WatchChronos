import 'package:flutter/material.dart';

/// Uygulamanın desteklediği diller.
///
/// YENİ BİR DİL EKLEMEK İÇİN (ör. Almanca):
/// 1. Aşağıya `de(languageCode: 'de', nativeName: 'Deutsch')` gibi yeni bir
///    enum değeri ekle.
/// 2. `lib/core/localization/translations/` klasörüne `de.dart` dosyası
///    ekle: `tr.dart` dosyasındaki TÜM anahtarları kopyalayıp Almanca'ya
///    çevir (bkz. o dosyanın başındaki yönerge).
/// 3. `lib/core/localization/translations/translations.dart` içindeki
///    `appTranslations` haritasına `AppLocale.de: deTranslations` satırını
///    ekle.
/// Bu üç adım dışında hiçbir dosyayı değiştirmene gerek yok: ayarlar
/// ekranındaki dil seçici, yerelleştirme sistemi ve eksik çeviri geri
/// düşüşü (fallback) bu listeyi otomatik olarak kullanır.
enum AppLocale {
  tr(languageCode: 'tr', nativeName: 'Türkçe', tmdbLanguageCode: 'tr-TR'),
  en(languageCode: 'en', nativeName: 'English', tmdbLanguageCode: 'en-US');

  const AppLocale({
    required this.languageCode,
    required this.nativeName,
    required this.tmdbLanguageCode,
  });

  /// ISO 639-1 dil kodu (ör. 'tr', 'en').
  final String languageCode;

  /// Dil seçici gibi arayüzlerde gösterilen, o dilin kendi adı.
  final String nativeName;

  /// TMDB API'sine `language` query parametresi olarak gönderilen kod
  /// (ör. 'tr-TR', 'en-US'). Film/dizi başlıkları, açıklamalar ve bölüm
  /// adları TMDB'den bu dile göre çekilir.
  final String tmdbLanguageCode;

  Locale get toLocale => Locale(languageCode);

  /// Çeviri bulunamadığında geri düşülecek varsayılan dil.
  static const AppLocale fallback = AppLocale.tr;

  /// Bir dil koduna karşılık gelen [AppLocale] değerini döner; eşleşme
  /// yoksa [fallback] döner.
  static AppLocale fromLanguageCode(String? code) {
    return AppLocale.values.firstWhere(
      (locale) => locale.languageCode == code,
      orElse: () => fallback,
    );
  }

  static final List<Locale> supportedLocales = AppLocale.values
      .map((l) => l.toLocale)
      .toList(growable: false);
}
