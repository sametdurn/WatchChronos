import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/media/data/tmdb_providers.dart';
import '../cache/media_cache_repository.dart';
import 'app_locale.dart';
import 'app_locale_storage.dart';

/// O anki uygulama dilini tutar ve ayarlar ekranındaki dil seçiciden
/// güncellenmesini sağlar. Başlangıç değeri `main()` içinde `runApp`'tan
/// önce yüklenen [AppLocaleStorage.current]'tan gelir; bu sayede ilk
/// karede zaten doğru dil gösterilir.
class LocaleController extends Notifier<AppLocale> {
  @override
  AppLocale build() => AppLocaleStorage.current;

  Future<void> setLocale(AppLocale locale) async {
    if (locale == state) return;
    state = locale;
    await AppLocaleStorage.save(locale);
    // Film/dizi detay ve sezon/bölüm önbelleği eski dildeki başlıkları
    // tutuyor olabilir (bkz. `MediaCacheRepository.clearAll` üzerindeki
    // not). Dil değişir değişmez temizleyerek, kullanıcı içeriklere
    // tekrar girdiğinde TMDB'den yeni dille çekilmesini sağlıyoruz.
    await ref.read(mediaCacheRepositoryProvider).clearAll();
    // Trend listeleri (Discover ekranı) Isar önbelleğinden değil ayrı bir
    // oturum-içi TTL cache'inden geliyor (bkz. tmdb_providers.dart); dil
    // değişince bunlar da geçersiz kılınmazsa eski dildeki başlıklarla
    // gösterilmeye devam ederdi.
    ref.invalidate(trendingMoviesProvider(1));
    ref.invalidate(trendingTvShowsProvider(1));
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, AppLocale>(
  LocaleController.new,
);
