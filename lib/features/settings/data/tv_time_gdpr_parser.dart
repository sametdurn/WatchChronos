import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:csv/csv.dart';

import 'models/tv_time_import_models.dart';

/// TV Time'ın GDPR self-service export'unda (`gdpr.tvtime.com`) gelen ZIP
/// dosyasını okuyup aktarım için gereken CSV'leri ayrıştırır.
///
/// Sadece şu dosyalar kullanılır (ZIP içindeki diğer onlarca CSV -
/// yorumlar, cihaz kayıtları, oturum token'ları vb. - aktarımla ilgili
/// olmadığı için yok sayılır):
/// - `user_tv_show_data.csv`               → dizi takip/izleme özeti
/// - `tracking-prod-records-v2.csv`        → dizi arşiv/takip durumu, en son
///                                            izlenen sezon-bölüm, bölüm
///                                            bazlı izleme olayları
///                                            (mevcutsa `tracking-prod-
///                                            records.csv`'ye tercih edilir)
/// - `tracking-prod-records.csv`           → film izleme/izleme listesi +
///                                            (v2 yoksa) bölüm izleme olayları
/// - `lists-prod-lists.csv` (opsiyonel)    → gerçek favori dizi/film listesi
///                                            (`user_tv_show_data.csv`'deki
///                                            `is_favorited` sütunu bu
///                                            export'ta hep 0 geliyor)
///
/// TV Time'da yıldızlı/numaralı bir puanlama sistemi olmadığı için
/// (sadece bölüm/film başına beğeni-tepki veriliyordu), export'taki
/// `ratings-*` dosyaları güvenilir bir puan içermez ve kasıtlı olarak
/// hiç okunmaz.
class TvTimeGdprParser {
  const TvTimeGdprParser();

  TvTimeImportData parse(List<int> zipBytes) {
    if (zipBytes.isEmpty) {
      throw const TvTimeParseException('tv_time_parse_error_empty_file');
    }

    final archive = ZipDecoder().decodeBytes(zipBytes);
    final fileNames = archive.files
        .where((f) => f.isFile)
        .map((f) => f.name.split('/').last)
        .toList();

    if (fileNames.isEmpty) {
      throw TvTimeParseException(
        'tv_time_parse_error_empty_zip',
        messageParams: {'bytes': '${zipBytes.length}'},
      );
    }

    const requiredFiles = [
      'user_tv_show_data.csv',
      'tracking-prod-records.csv',
    ];
    final missingFiles = requiredFiles
        .where(
          (required) => !fileNames.any(
            (name) => name.toLowerCase() == required.toLowerCase(),
          ),
        )
        .toList();
    if (missingFiles.isNotEmpty) {
      throw TvTimeParseException(
        'tv_time_parse_error_missing_files',
        messageParams: {
          'missing': missingFiles.join(', '),
          'count': '${fileNames.length}',
          'sample': fileNames.take(15).join(', ') +
              (fileNames.length > 15 ? ', ...' : ''),
        },
      );
    }

    // `lists-prod-lists.csv` opsiyoneldir (eski export'larda olmayabilir).
    // `user_tv_show_data.csv`'deki `is_favorited` sütunu bu export'ta hep 0
    // geldiği için (TV Time bunu doldurmuyor), gerçek favori bilgisi bu
    // ayrı "collection" listesinden (favorite-series / favorite-movies)
    // okunuyor.
    final favorites = _parseFavoriteLists(archive);

    // `tracking-prod-records-v2.csv`, dizi arşiv/takip durumunu ve bölüm
    // bazlı izleme olaylarını eski dosyadan çok daha zengin verir (bkz.
    // `_ShowAggregate`). Mevcutsa `_parseShows`'a birleştirilmek üzere
    // aktarılır; yoksa (eski export formatı) sadece eski dosyaya düşülür.
    final v2 = _parseTrackingV2(archive);

    final shows = _parseShows(archive, favorites.seriesIds, v2.showsById);

    final episodeWatches = <String, TvTimeEpisodeWatch>{};
    for (final ep in v2.episodeWatches) {
      episodeWatches['${_normalizeKey(ep.seriesName)}|${ep.seasonNumber}|${ep.episodeNumber}'] = ep;
    }

    final movies = <String, TvTimeMovieRecord>{};
    final movieUuidToName = <String, String>{};
    _parseTracking(archive, episodeWatches, movies, movieUuidToName);
    _applyFavoriteMovies(movies, movieUuidToName, favorites.movieUuids);

    if (shows.isEmpty && movies.isEmpty) {
      throw const TvTimeParseException('tv_time_parse_error_no_records');
    }

    return TvTimeImportData(
      shows: shows,
      episodeWatches: episodeWatches.values.toList(),
      movies: movies.values.toList(),
    );
  }

  String _normalizeKey(String value) =>
      value.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

  // ---------------------------------------------------------------------
  // CSV okuma yardımcıları
  // ---------------------------------------------------------------------

  List<List<dynamic>>? _readCsv(Archive archive, String fileName) {
    ArchiveFile? file;
    for (final candidate in archive.files) {
      if (!candidate.isFile) continue;
      final baseName = candidate.name.split('/').last;
      if (baseName.toLowerCase() == fileName.toLowerCase()) {
        file = candidate;
        break;
      }
    }
    if (file == null) return null;

    final rawBytes = file.content as List<int>;
    final content = utf8.decode(rawBytes, allowMalformed: true);
    if (content.trim().isEmpty) return null;

    // ÖNEMLİ: CsvToListConverter'ın varsayılan eol'u '\r\n'dir. TV Time'ın
    // GDPR export'undaki CSV'ler ise sade '\n' kullanıyor. Varsayılanla hiç
    // satır sonu bulunamadığı için tüm dosya TEK satır sanılıyordu. Önce
    // olası '\r\n'leri '\n'e indirgeyip sonra sabit '\n' ile parse ediyoruz;
    // böylece hem eski hem yeni export'lar (hangi satır sonunu kullanırsa
    // kullansın) doğru okunur.
    final normalized = content.replaceAll('\r\n', '\n');
    return const CsvToListConverter(eol: '\n').convert(normalized);
  }

  Map<String, int> _headerIndex(List<dynamic> header) {
    final map = <String, int>{};
    for (var i = 0; i < header.length; i++) {
      map[header[i].toString().trim()] = i;
    }
    return map;
  }

  String _str(List<dynamic> row, int? index) {
    if (index == null || index >= row.length) return '';
    final value = row[index];
    if (value == null) return '';
    return value.toString().trim();
  }

  int _int(List<dynamic> row, int? index) {
    return int.tryParse(_str(row, index)) ?? 0;
  }

  bool _bool(List<dynamic> row, int? index) {
    final value = _str(row, index).toLowerCase();
    return value == '1' || value == 'true' || value == 'yes';
  }

  // ---------------------------------------------------------------------
  // user_tv_show_data.csv
  // ---------------------------------------------------------------------

  List<TvTimeShowRecord> _parseShows(
    Archive archive,
    Set<int> favoriteSeriesIds,
    Map<int, _ShowAggregate> v2ById,
  ) {
    final rows = _readCsv(archive, 'user_tv_show_data.csv');
    if (rows == null || rows.length < 2) return const [];
    final idx = _headerIndex(rows.first);

    final result = <TvTimeShowRecord>[];
    final seenIds = <int>{};
    for (final row in rows.skip(1)) {
      if (row.isEmpty) continue;
      final rawName = _str(row, idx['tv_show_name']);
      if (rawName.isEmpty) continue;
      final tvShowId = _int(row, idx['tv_show_id']);
      final agg = v2ById[tvShowId];
      if (tvShowId != 0) seenIds.add(tvShowId);

      // `is_favorited` sütunu bu export'ta güvenilir doldurulmuyor (hep 0
      // geliyor); bu yüzden `lists-prod-lists.csv`'deki `favorite-series`
      // koleksiyonundan gelen id kümesiyle de OR'lanıyor.
      final isFavorited =
          _bool(row, idx['is_favorited']) ||
          favoriteSeriesIds.contains(tvShowId);

      final hint = _extractYearHint(rawName);
      result.add(
        TvTimeShowRecord(
          tvTimeShowId: tvShowId == 0 ? null : tvShowId,
          name: hint.clean,
          yearHint: hint.year,
          isFollowed: _bool(row, idx['is_followed']) || (agg?.isFollowed ?? false),
          isFavorited: isFavorited,
          // İki kaynaktan hangisi daha yüksekse o alınır (biri diğerinden
          // daha güncel/eksiksiz senkronize olmuş olabilir).
          episodesSeen: [
            _int(row, idx['nb_episodes_seen']),
            agg?.episodesSeen ?? 0,
          ].reduce((a, b) => a > b ? a : b),
          isArchived: agg?.isArchived ?? false,
          isForLater: agg?.isForLater ?? false,
          rewatchCount: agg?.rewatchCount ?? 0,
          currentSeason: agg?.currentSeason,
          currentEpisode: agg?.currentEpisode,
        ),
      );
    }

    // `tracking-prod-records-v2.csv`'de olup `user_tv_show_data.csv`'de HİÇ
    // bulunmayan diziler de olabilir (nadir, ama es geçilmemeli).
    for (final entry in v2ById.entries) {
      if (seenIds.contains(entry.key)) continue;
      final agg = entry.value;
      if (!agg.isFollowed && !agg.isArchived && agg.episodesSeen <= 0) continue;
      result.add(
        TvTimeShowRecord(
          tvTimeShowId: entry.key,
          name: '(bilinmeyen dizi #${entry.key})',
          isFollowed: agg.isFollowed,
          isFavorited: false,
          episodesSeen: agg.episodesSeen,
          isArchived: agg.isArchived,
          isForLater: agg.isForLater,
          rewatchCount: agg.rewatchCount,
          currentSeason: agg.currentSeason,
          currentEpisode: agg.currentEpisode,
        ),
      );
    }
    return result;
  }

  /// TV Time başlıklarında aynı isimli remake/reboot yapımları ayırmak için
  /// sona eklenen "(YYYY)" ekini ayıklar (ör. "The Flash (2014)"). Eşleştirme
  /// motoru bu ipucunu yayın yılı olarak kullanır.
  ({String clean, int? year}) _extractYearHint(String rawTitle) {
    final match = RegExp(r'^(.*)\((\d{4})\)\s*$').firstMatch(rawTitle.trim());
    if (match == null) return (clean: rawTitle.trim(), year: null);
    return (clean: match.group(1)!.trim(), year: int.tryParse(match.group(2)!));
  }

  // ---------------------------------------------------------------------
  // tracking-prod-records.csv
  // ---------------------------------------------------------------------

  void _parseTracking(
    Archive archive,
    Map<String, TvTimeEpisodeWatch> episodeWatches,
    Map<String, TvTimeMovieRecord> movies,
    Map<String, String> movieUuidToName,
  ) {
    final rows = _readCsv(archive, 'tracking-prod-records.csv');
    if (rows == null || rows.length < 2) return;
    final idx = _headerIndex(rows.first);

    for (final row in rows.skip(1)) {
      if (row.isEmpty) continue;
      final type = _str(row, idx['type']);
      final entityType = _str(row, idx['entity_type']);

      // `favorite-movies` listesi (bkz. `_parseFavoriteLists`) filmleri
      // sadece `uuid` ile verir, isim taşımaz. Bu dosyadaki satırlarda ise
      // hem `uuid` hem `movie_name` bulunuyor; bu eşlemeyi tür/olay ne
      // olursa olsun (follow/watch/towatch) topluyoruz ki favori listesi
      // yalnızca "towatch" durumundaki bir filmi işaret ettiğinde de isim
      // çözülebilsin.
      final rowUuid = _str(row, idx['uuid']);
      final rowMovieName = _str(row, idx['movie_name']);
      if (rowUuid.isNotEmpty && rowMovieName.isNotEmpty) {
        movieUuidToName.putIfAbsent(rowUuid, () => rowMovieName);
      }

      if (type == 'watch' && entityType == 'episode') {
        // `tracking-prod-records-v2.csv` (bkz. `_parseTrackingV2`) bu
        // olayları çok daha eksiksiz (+ yeniden izleme sayısı) verdiği
        // için ORADA zaten varsa burası SADECE eksik kalanları tamamlar.
        final seriesName = _str(row, idx['series_name']);
        final season = _int(row, idx['season_number']);
        final episode = _int(row, idx['episode_number']);
        if (seriesName.isEmpty || season <= 0 || episode <= 0) continue;
        final key = '${_normalizeKey(seriesName)}|$season|$episode';
        episodeWatches.putIfAbsent(
          key,
          () => TvTimeEpisodeWatch(
            seriesName: seriesName,
            seasonNumber: season,
            episodeNumber: episode,
            watchedAt: _watchDate(row, idx),
          ),
        );
      } else if (type == 'watch' && entityType == 'movie') {
        final name = _str(row, idx['movie_name']);
        if (name.isEmpty) continue;
        final record = movies.putIfAbsent(
          name,
          () => TvTimeMovieRecord(
            name: name,
            releaseYear: _releaseYear(row, idx),
            runtimeMinutes: _runtimeMinutes(row, idx),
          ),
        );
        record.watched = true;
        record.watchedAt = _watchDate(row, idx);
      } else if (type == 'towatch' && entityType == 'movie') {
        final name = _str(row, idx['movie_name']);
        if (name.isEmpty) continue;
        movies.putIfAbsent(
          name,
          () => TvTimeMovieRecord(
            name: name,
            releaseYear: _releaseYear(row, idx),
            runtimeMinutes: _runtimeMinutes(row, idx),
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------
  // tracking-prod-records-v2.csv
  // ---------------------------------------------------------------------
  //
  // Bu dosya tek bir tabloda iki farklı satır türü barındırır (`key`
  // sütunundaki önek ile ayrılır):
  // - `user-series-<uuid>`  → dizi başına TEK özet satır: takip/arşiv
  //   durumu, toplam izlenen bölüm sayısı, en son izlenen sezon/bölüm.
  // - `watch-episode-<...>` → her bölüm izleme olayı için AYRI satır:
  //   hangi sezon/bölüm, ne zaman, kaçıncı kez (yeniden) izlendiği.
  //
  // Film bu dosyada HİÇ yer almaz (yalnızca `tracking-prod-records.csv`'de
  // bulunur); bu yüzden film ayrıştırması hâlâ `_parseTracking`'de kalır.

  ({Map<int, _ShowAggregate> showsById, List<TvTimeEpisodeWatch> episodeWatches})
  _parseTrackingV2(Archive archive) {
    final rows = _readCsv(archive, 'tracking-prod-records-v2.csv');
    if (rows == null || rows.length < 2) {
      return (showsById: <int, _ShowAggregate>{}, episodeWatches: <TvTimeEpisodeWatch>[]);
    }
    final idx = _headerIndex(rows.first);
    final showsById = <int, _ShowAggregate>{};
    final episodeWatches = <TvTimeEpisodeWatch>[];

    for (final row in rows.skip(1)) {
      if (row.isEmpty) continue;
      final key = _str(row, idx['key']);

      if (key.startsWith('user-series-')) {
        final sId = _int(row, idx['s_id']);
        if (sId == 0) continue;
        final mostRecent = _parseMostRecentEpWatched(_str(row, idx['most_recent_ep_watched']));
        final existing = showsById[sId];
        showsById[sId] = _ShowAggregate(
          isFollowed: _bool(row, idx['is_followed']),
          isArchived: _bool(row, idx['is_archived']),
          isForLater: _bool(row, idx['is_for_later']),
          episodesSeen: _int(row, idx['ep_watch_count']),
          currentSeason: mostRecent.season,
          currentEpisode: mostRecent.episode,
          rewatchCount: existing?.rewatchCount ?? 0,
        );
      } else if (key.startsWith('watch-episode-')) {
        final seriesName = _str(row, idx['series_name']);
        final season = _int(row, idx['season_number']);
        final episode = _int(row, idx['episode_number']);
        final sId = _int(row, idx['s_id']);
        final rewatch = _int(row, idx['rewatch_count']);
        if (sId != 0 && rewatch > 0) {
          final existing = showsById[sId];
          if (existing == null) {
            showsById[sId] = _ShowAggregate(rewatchCount: rewatch);
          } else if (rewatch > existing.rewatchCount) {
            showsById[sId] = existing.copyWith(rewatchCount: rewatch);
          }
        }
        if (seriesName.isEmpty || season <= 0 || episode <= 0) continue;
        episodeWatches.add(
          TvTimeEpisodeWatch(
            seriesName: seriesName,
            seasonNumber: season,
            episodeNumber: episode,
            watchedAt: _parseDateTime(_str(row, idx['created_at'])),
            rewatchCount: rewatch,
          ),
        );
      }
    }

    return (showsById: showsById, episodeWatches: episodeWatches);
  }

  /// `most_recent_ep_watched` sütunu Go'nun `fmt` ile bastırdığı bir map
  /// metnidir: `map[ep_id:6.010572e+06 ep_no:10 s_no:2 uuid:... watch_date:
  /// 1.667052066199003e+15]`. Sadece sezon/bölüm numaralarını çıkarıyoruz
  /// (izlenme tarihi zaten `watch-episode-*` satırlarından, tek tek ve daha
  /// güvenilir şekilde geliyor).
  ({int? season, int? episode}) _parseMostRecentEpWatched(String raw) {
    if (raw.isEmpty) return (season: null, episode: null);
    final seasonMatch = RegExp(r's_no:(\d+)').firstMatch(raw);
    final episodeMatch = RegExp(r'ep_no:(\d+)').firstMatch(raw);
    return (
      season: seasonMatch != null ? int.tryParse(seasonMatch.group(1)!) : null,
      episode: episodeMatch != null ? int.tryParse(episodeMatch.group(1)!) : null,
    );
  }

  DateTime? _parseDateTime(String raw) {
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw)?.toUtc();
  }

  // ---------------------------------------------------------------------
  // lists-prod-lists.csv (favorite-series / favorite-movies)
  // ---------------------------------------------------------------------

  /// `_parseFavoriteLists`'in döndürdüğü, favori dizi TVDB id'leri ve
  /// favori film uuid'lerini bir arada taşıyan sonuç.
  ///
  /// Not: TV Time'da favori diziler TVDB id'siyle, favori filmler ise
  /// yalnızca kendi dahili `uuid`'siyle tutuluyor (isim bu dosyada hiç
  /// geçmiyor); film ismi ayrıca `tracking-prod-records.csv`'den
  /// (`_parseTracking` sırasında toplanan `movieUuidToName`) çözülüyor.
  ({Set<int> seriesIds, Set<String> movieUuids}) _parseFavoriteLists(
    Archive archive,
  ) {
    final rows = _readCsv(archive, 'lists-prod-lists.csv');
    if (rows == null || rows.length < 2) {
      return (seriesIds: <int>{}, movieUuids: <String>{});
    }
    final idx = _headerIndex(rows.first);
    final sKeyIdx = idx['s_key'];
    final objectsIdx = idx['objects'];

    final seriesIds = <int>{};
    final movieUuids = <String>{};

    for (final row in rows.skip(1)) {
      if (row.isEmpty) continue;
      final sKey = _str(row, sKeyIdx);
      if (sKey != 'favorite-series' && sKey != 'favorite-movies') continue;
      final objects = _str(row, objectsIdx);
      if (objects.isEmpty) continue;

      for (final entry in _splitMapEntries(objects)) {
        if (sKey == 'favorite-series') {
          final idMatch = RegExp(r'(?:^|\s)id:(\d+)(?=\s|$)').firstMatch(entry);
          if (idMatch != null) {
            seriesIds.add(int.parse(idMatch.group(1)!));
          }
        } else {
          final uuidMatch = RegExp(
            r'(?:^|\s)uuid:([0-9a-fA-F-]{36})(?=\s|$)',
          ).firstMatch(entry);
          if (uuidMatch != null) {
            movieUuids.add(uuidMatch.group(1)!);
          }
        }
      }
    }

    return (seriesIds: seriesIds, movieUuids: movieUuids);
  }

  /// `lists-prod-lists.csv`'nin `objects` sütunu Go'nun `fmt` ile
  /// bastırdığı, JSON OLMAYAN bir map dizisi metnidir:
  /// `[map[k1:v1 k2:[a b]] map[k3:v3]]` (virgülsüz, boşlukla ayrılmış).
  /// Bu metni, iç içe köşeli parantezleri (ör. `fanart:[url1 url2]`)
  /// doğru sayarak en üst seviyedeki her `map[...]` bloğunu ayrı bir
  /// string olarak döner. Basit bir regex burada yeterli olmaz çünkü
  /// iç içe `[...]` blokları erken kapanışa (yanlış eşleşmeye) yol açar.
  List<String> _splitMapEntries(String objectsField) {
    final trimmed = objectsField.trim();
    if (!trimmed.startsWith('[') || !trimmed.endsWith(']')) return const [];
    final inner = trimmed.substring(1, trimmed.length - 1);

    final entries = <String>[];
    var i = 0;
    while (i < inner.length) {
      final mapStart = inner.indexOf('map[', i);
      if (mapStart == -1) break;
      final bracketStart = mapStart + 3; // 'map' sonrası '[' konumu
      var depth = 0;
      var k = bracketStart;
      for (; k < inner.length; k++) {
        if (inner[k] == '[') {
          depth++;
        } else if (inner[k] == ']') {
          depth--;
          if (depth == 0) break;
        }
      }
      if (depth != 0) break; // eşleşmeyen parantez, bozuk veri
      entries.add(inner.substring(bracketStart + 1, k));
      i = k + 1;
    }
    return entries;
  }

  /// Favori film uuid'lerini, `tracking-prod-records.csv`'den toplanan
  /// uuid→isim eşlemesi üzerinden çözüp ilgili [TvTimeMovieRecord]'u
  /// favori olarak işaretler. Film daha önce izlenmiş/izleme listesinde
  /// değilse (yalnızca favorilere eklenmişse) yeni bir kayıt oluşturulur.
  void _applyFavoriteMovies(
    Map<String, TvTimeMovieRecord> movies,
    Map<String, String> movieUuidToName,
    Set<String> favoriteMovieUuids,
  ) {
    for (final uuid in favoriteMovieUuids) {
      final name = movieUuidToName[uuid];
      if (name == null || name.isEmpty) continue;
      final record = movies.putIfAbsent(
        name,
        () => TvTimeMovieRecord(name: name),
      );
      record.isFavorited = true;
    }
  }

  int? _releaseYear(List<dynamic> row, Map<String, int> idx) {
    final raw = _str(row, idx['release_date']);
    if (raw.isEmpty) return null;
    return int.tryParse(raw.split('-').first);
  }

  int? _runtimeMinutes(List<dynamic> row, Map<String, int> idx) {
    final raw = _str(row, idx['runtime']);
    if (raw.isEmpty) return null;
    // Bazı satırlarda ondalıklı gelebiliyor (ör. "142.0").
    return double.tryParse(raw)?.round();
  }

  DateTime? _watchDate(List<dynamic> row, Map<String, int> idx) {
    final rawDate = _str(row, idx['watch_date']);
    final directEpoch = int.tryParse(rawDate);
    if (directEpoch != null && directEpoch > 0) {
      return _fromEpoch(directEpoch);
    }

    final rangeKey = _str(row, idx['watch_date_range_key']);
    final match = RegExp(r'(\d{9,})$').firstMatch(rangeKey);
    if (match != null) {
      final epoch = int.tryParse(match.group(1)!);
      if (epoch != null) return _fromEpoch(epoch);
    }
    return null;
  }

  DateTime _fromEpoch(int epoch) {
    // Bazı alanlar saniye, bazıları milisaniye cinsinden gelebiliyor.
    final isMillis = epoch > 100000000000;
    return DateTime.fromMillisecondsSinceEpoch(
      isMillis ? epoch : epoch * 1000,
      isUtc: true,
    );
  }

}

/// `tracking-prod-records-v2.csv`'deki `user-series-*` satırlarından (+
/// gerekirse `watch-episode-*` satırlarındaki `rewatch_count`'tan) çıkarılan,
/// bir dizi için toplanmış ek bilgi. `_parseShows` bunu `tv_show_id` üzerinden
/// `user_tv_show_data.csv`'deki temel kayıtla birleştirir.
class _ShowAggregate {
  const _ShowAggregate({
    this.isFollowed = false,
    this.isArchived = false,
    this.isForLater = false,
    this.episodesSeen = 0,
    this.currentSeason,
    this.currentEpisode,
    this.rewatchCount = 0,
  });

  final bool isFollowed;
  final bool isArchived;
  final bool isForLater;
  final int episodesSeen;
  final int? currentSeason;
  final int? currentEpisode;
  final int rewatchCount;

  _ShowAggregate copyWith({int? rewatchCount}) => _ShowAggregate(
    isFollowed: isFollowed,
    isArchived: isArchived,
    isForLater: isForLater,
    episodesSeen: episodesSeen,
    currentSeason: currentSeason,
    currentEpisode: currentEpisode,
    rewatchCount: rewatchCount ?? this.rewatchCount,
  );
}
