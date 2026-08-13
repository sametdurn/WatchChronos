/// TV Time GDPR export ZIP'inden ayrıştırılan ham veri modelleri.
///
/// TV Time (tvtime.com) 15 Temmuz 2026'da kapandığı için kullanıcılar
/// `gdpr.tvtime.com` üzerinden kendi verilerinin bir ZIP kopyasını
/// indirebiliyordu. Bu dosyalar, o ZIP içindeki CSV'lerden çıkarılan
/// ara veri yapılarını tanımlar.
library;

/// `user_tv_show_data.csv` + `tracking-prod-records-v2.csv` (`user-series-*`
/// satırları) birleştirilerek oluşturulan, kullanıcının takip ettiği/izlediği
/// her dizi için tek satırlık özet kayıt.
///
/// İki dosya, TV Time'ın kendi içindeki aynı dizi kimliğiyle (`tv_show_id` /
/// `s_id`) eşleştirilir; bu yüzden [tvTimeShowId] doluysa iki kaynak da
/// birleştirilmiş demektir.
class TvTimeShowRecord {
  const TvTimeShowRecord({
    required this.name,
    required this.isFollowed,
    required this.isFavorited,
    required this.episodesSeen,
    this.tvTimeShowId,
    this.isArchived = false,
    this.isForLater = false,
    this.rewatchCount = 0,
    this.currentSeason,
    this.currentEpisode,
    this.yearHint,
  });

  /// TV Time'ın kendi içindeki dizi kimliği (TheTVDB tabanlı). Sadece
  /// dosyaları birbirine eşlemek için kullanılır, TMDB eşleştirmesinde
  /// KULLANILMAZ (TMDB farklı bir kimlik alanı).
  final int? tvTimeShowId;

  final String name;
  final bool isFollowed;
  final bool isFavorited;
  final int episodesSeen;

  /// `tracking-prod-records-v2.csv`'deki `is_archived`. Kullanıcı diziyi
  /// aktif takipten kaldırıp arşivlemişse `true`.
  final bool isArchived;

  /// `is_for_later` — TV Time'da "sonra izle" işaretlemesi (WatchChronos'ta
  /// `planned` durumuna karşılık gelir).
  final bool isForLater;

  /// Bölüm bazlı `rewatch_count` alanlarının bu dizi için en yükseği.
  /// WatchChronos'ta ayrı bir "yeniden izleme sayısı" alanı olmadığından
  /// aktarım sırasında not olarak eklenir.
  final int rewatchCount;

  /// `most_recent_ep_watched` alanından çözülen, kullanıcının en son
  /// izlediği sezon/bölüm (bir "kaldığı yer" işaretçisi).
  final int? currentSeason;
  final int? currentEpisode;

  /// Başlıkta "(YYYY)" şeklinde bir yıl eki varsa (TV Time'ın aynı isimli
  /// remake/reboot yapımları ayırma yöntemi), buraya çıkarılır; [name] bu
  /// ekten arındırılmış halidir.
  final int? yearHint;
}

/// Bölüm bazlı bir izleme olayı (`tracking-prod-records-v2.csv`'deki
/// `watch-episode-*` satırları, yoksa eski `tracking-prod-records.csv`).
///
/// Not: TV Time GDPR export'u her dizi için bölüm bölüm geçmiş vermez;
/// sadece bazı diziler için (genelde daha yakın tarihli izlemeler) bu
/// düzeyde ayrıntı bulunur. Diğer diziler için sadece toplam izlenen
/// bölüm sayısı (`TvTimeShowRecord.episodesSeen`) mevcuttur.
class TvTimeEpisodeWatch {
  const TvTimeEpisodeWatch({
    required this.seriesName,
    required this.seasonNumber,
    required this.episodeNumber,
    this.watchedAt,
    this.rewatchCount = 0,
  });

  final String seriesName;
  final int seasonNumber;
  final int episodeNumber;
  final DateTime? watchedAt;
  final int rewatchCount;
}

/// `tracking-prod-records.csv` içindeki film satırlarından (hem
/// `towatch` hem `watch` tipi) birleştirilmiş film kaydı.
class TvTimeMovieRecord {
  TvTimeMovieRecord({required this.name, this.releaseYear, this.runtimeMinutes});

  final String name;
  final int? releaseYear;

  /// TV Time'ın kaydettiği süre (dakika), varsa. Aynı isimli remake/reboot
  /// filmlerde (ör. iki farklı "Dune") yıl bilgisi de yetersiz kaldığında
  /// TMDB adayları arasında ek bir ayırt edici olarak kullanılır.
  final int? runtimeMinutes;

  /// `true` ise film izlenmiş (watched); `false` ise sadece izleme
  /// listesine (watchlist) eklenmiş demektir.
  bool watched = false;
  DateTime? watchedAt;

  /// `lists-prod-lists.csv` içindeki `favorite-movies` listesinden gelir.
  /// TV Time'da filmler için `is_favorited` gibi bir sütun yoktur; favori
  /// bilgisi yalnızca bu ayrı liste üzerinden çıkarılabilir.
  bool isFavorited = false;
}

/// [TvTimeGdprParser] ZIP'i okuyamadığında veya beklenen dosyaları/veriyi
/// bulamadığında fırlatılır. Mesajı doğrudan kullanıcıya (geliştirici
/// tarafından teşhis amaçlı) gösterilecek şekilde açıklayıcıdır.
/// [messageKey] bir çeviri anahtarıdır (bkz. core/localization);
/// [messageParams] o anahtardaki `{param}` yer tutucularını doldurur. UI
/// katmanı `context.l10n.tp(messageKey, messageParams)` ile gösterir.
class TvTimeParseException implements Exception {
  const TvTimeParseException(this.messageKey, {this.messageParams = const {}});

  final String messageKey;
  final Map<String, String> messageParams;

  @override
  String toString() => messageKey;
}

/// Parser'ın tek seferde ürettiği, aktarım servisinin ihtiyaç duyduğu
/// tüm verileri barındıran kapsayıcı.
///
/// Not: TV Time'da yıldızlı/numaralı bir puanlama sistemi yoktu (sadece
/// bölüm/film başına beğeni-tepki veriliyordu), bu yüzden export'taki
/// "rating" dosyaları güvenilir bir puan içermiyor ve aktarıma dahil
/// edilmiyor.
class TvTimeImportData {
  const TvTimeImportData({
    required this.shows,
    required this.episodeWatches,
    required this.movies,
  });

  final List<TvTimeShowRecord> shows;
  final List<TvTimeEpisodeWatch> episodeWatches;
  final List<TvTimeMovieRecord> movies;
}
