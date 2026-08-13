/// TMDB'nin dizi (`tv`) içerikleri için döndürdüğü `status` alanının
/// yorumlanmış hali. Uygulama bu değeri hiçbir zaman kalıcı bir
/// `isCompleted` bayrağı olarak SAKLAMAZ; her zaman TMDB'den en güncel
/// haliyle çekilip (cache-first, bkz. MediaRepository.getMediaDetail)
/// ANLIK olarak bu enum'a çevrilir. Böylece bir dizi iptal edildikten
/// sonra (`Canceled`) başka bir platformda devam ederse (`Returning
/// Series`/`In Production`), bir sonraki veri yenilemesinde otomatik
/// olarak "Diziler" sekmesine geri döner — ayrıca bir migration veya
/// manuel işlem gerekmez.
enum TvShowLifecycle {
  returningSeries,
  inProduction,
  planned,
  pilot,
  ended,
  canceled,
  unknown;

  /// `true` ise dizi "Tamamlandı" sekmesine ait demektir.
  bool get isFinished =>
      this == TvShowLifecycle.ended || this == TvShowLifecycle.canceled;

  /// Arayüzde gösterilecek rozet metninin çeviri anahtarı (bkz.
  /// core/localization); UI katmanı `context.l10n.t(lifecycle.labelKey)`
  /// ile gösterir.
  String get labelKey => switch (this) {
    TvShowLifecycle.returningSeries => 'tv_lifecycle_returning_series',
    TvShowLifecycle.inProduction => 'tv_lifecycle_in_production',
    TvShowLifecycle.planned => 'tv_lifecycle_planned',
    TvShowLifecycle.pilot => 'tv_lifecycle_pilot',
    TvShowLifecycle.ended => 'tv_lifecycle_ended',
    TvShowLifecycle.canceled => 'tv_lifecycle_canceled',
    TvShowLifecycle.unknown => '',
  };
}

/// TMDB'nin ham `status` metnini (`CachedMedia.status`) [TvShowLifecycle]'a
/// çevirir. Tanınmayan/boş bir değer güvenli tarafta kalınarak
/// [TvShowLifecycle.unknown] (bitmemiş kabul edilir) olarak döner; böylece
/// TMDB'den henüz status bilgisi çekilememiş bir dizi yanlışlıkla
/// "Tamamlandı" sekmesine düşmez.
TvShowLifecycle parseTvShowLifecycle(String? rawStatus) {
  switch (rawStatus) {
    case 'Returning Series':
      return TvShowLifecycle.returningSeries;
    case 'In Production':
      return TvShowLifecycle.inProduction;
    case 'Planned':
      return TvShowLifecycle.planned;
    case 'Pilot':
      return TvShowLifecycle.pilot;
    case 'Ended':
      return TvShowLifecycle.ended;
    case 'Canceled':
      return TvShowLifecycle.canceled;
    default:
      return TvShowLifecycle.unknown;
  }
}
