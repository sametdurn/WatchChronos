import '../../media/data/models/movie_model.dart';
import '../../media/data/models/tv_show_model.dart';
import '../../media/data/tmdb_repository.dart';

/// TMDB tarafında bulunan, puanlanmış bir eşleşme adayı. Hem otomatik seçilen
/// tek kazananı, hem de belirsiz durumlarda kullanıcıya sunulacak üst
/// adayları taşımak için kullanılır.
class TvTimeMatchCandidate {
  const TvTimeMatchCandidate({
    required this.tmdbId,
    required this.title,
    required this.originalTitle,
    required this.year,
    required this.releaseDate,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.score,
  });

  final int tmdbId;
  final String title;
  final String originalTitle;
  final int? year;

  /// TMDB'nin tam yayın tarihi ("YYYY-MM-DD" formatında, ham hâliyle).
  /// Manuel seçim ekranında kullanıcının aynı isimli iki adayı (ör. iki
  /// farklı yıl/dublaj kaydı) ayırt edebilmesi için gösterilir.
  final String releaseDate;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;
  final double score;

  /// Poster VE puan verisi tamamen boşsa, bu TMDB kaydı büyük olasılıkla
  /// yanlış eşleşmiş ya da içeriği henüz doldurulmamış bir girdidir. Böyle
  /// bir "kazanan" otomatik aktarım için güvenilir kabul edilmez.
  bool get looksUnreliable =>
      (posterPath == null || posterPath!.isEmpty) && voteCount <= 0;
}

/// Tek bir içerik için eşleştirme turunun sonucu.
///
/// Üç hal vardır:
/// - `matched`: Tek bir güçlü aday var, otomatik aktarılabilir.
/// - `ambiguous`: Birden fazla güçlü aday birbirine çok yakın puanlı;
///   otomatik seçim yapılmadı, kullanıcıdan seçim istenmeli.
/// - `none`: Hiç makul aday bulunamadı.
class TvTimeMatchOutcome {
  const TvTimeMatchOutcome.matched(TvTimeMatchCandidate candidate)
    : best = candidate,
      candidates = const [],
      isAmbiguous = false;

  const TvTimeMatchOutcome.ambiguous(this.candidates)
    : best = null,
      isAmbiguous = true;

  const TvTimeMatchOutcome.none()
    : best = null,
      candidates = const [],
      isAmbiguous = false;

  final TvTimeMatchCandidate? best;

  /// Sadece `isAmbiguous == true` iken doludur (en güçlü ~3 aday).
  final List<TvTimeMatchCandidate> candidates;
  final bool isAmbiguous;

  bool get hasMatch => best != null;
}

/// TV Time'dan gelen ham başlık/yıl/sezon/bölüm bilgilerini TMDB arama
/// sonuçlarıyla karşılaştırıp bir güven puanı üzerinden en doğru eşleşmeyi
/// bulmaya çalışan motor.
///
/// Puanlama şu bileşenlerin ağırlıklı toplamıdır:
/// - Başlık benzerliği (normalize edilmiş + gerekirse fuzzy karşılaştırma)
/// - Yayın yılı uyuşması (TV Time başlığındaki "(YYYY)" ekinden çıkarılır;
///   bu ek özellikle aynı isimli remake/reboot yapımlarda TV Time'ın kendi
///   ayrım yöntemidir)
/// - Sezon/bölüm sayısı tutarlılığı (yalnızca belirsiz durumlarda, TMDB'den
///   ek detay isteği yapılarak)
///
/// İki en iyi aday arasındaki fark yeterince büyük değilse ([_ambiguityMargin])
/// sonuç `ambiguous` olarak döner; hiçbir otomatik seçim yapılmaz.
class TvTimeMatchEngine {
  TvTimeMatchEngine(this._tmdb);

  final TmdbRepository _tmdb;

  static const _minPlausibleScore = 0.45;
  static const _ambiguityMargin = 0.08;
  static const _titleWeight = 0.65;
  static const _yearWeight = 0.35;

  // ---------------------------------------------------------------------
  // Başlık normalize / benzerlik
  // ---------------------------------------------------------------------

  static const _turkishMap = {
    'ç': 'c', 'ğ': 'g', 'ı': 'i', 'i̇': 'i', 'ö': 'o', 'ş': 's', 'ü': 'u',
    'â': 'a', 'î': 'i', 'û': 'u', 'é': 'e', 'è': 'e', 'ê': 'e', 'à': 'a',
    'ñ': 'n', 'ß': 'ss',
  };

  /// Küçük/büyük harf farkını, Türkçe/aksanlı karakterleri, noktalama
  /// işaretlerini kaldırıp gereksiz boşlukları temizleyen normalize.
  String normalizeTitle(String value) {
    var result = value.toLowerCase();
    _turkishMap.forEach((from, to) => result = result.replaceAll(from, to));
    // Noktalama: - : ' . ! , ? " ( ) vb. hepsini boşluğa çevir.
    result = result.replaceAll(RegExp(r'''[-:.'!,?"()\[\]/_]'''), ' ');
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();
    return result;
  }

  /// TV Time başlıklarında aynı isimli remake/reboot yapımları ayırmak için
  /// sona eklenen "(YYYY)" ekini ayıklar (ör. "The Flash (2014)").
  ({String clean, int? year}) extractYearHint(String rawTitle) {
    final match = RegExp(r'^(.*)\((\d{4})\)\s*$').firstMatch(rawTitle.trim());
    if (match == null) return (clean: rawTitle.trim(), year: null);
    return (
      clean: match.group(1)!.trim(),
      year: int.tryParse(match.group(2)!),
    );
  }

  /// 0..1 arası, iki normalize başlık arasındaki benzerlik. Levenshtein
  /// oranı ile kelime kümesi (token) örtüşmesinin ortalamasıdır; böylece
  /// hem yazım farklarına (fuzzy) hem kelime sırası/eksik kelime farkına
  /// karşı dayanıklıdır.
  double _similarity(String a, String b) {
    if (a.isEmpty || b.isEmpty) return 0;
    if (a == b) return 1;

    final levRatio = 1 - (_levenshtein(a, b) / [a.length, b.length].reduce((x, y) => x > y ? x : y));

    final tokensA = a.split(' ').where((t) => t.isNotEmpty).toSet();
    final tokensB = b.split(' ').where((t) => t.isNotEmpty).toSet();
    double tokenRatio;
    if (tokensA.isEmpty || tokensB.isEmpty) {
      tokenRatio = 0;
    } else {
      final intersection = tokensA.intersection(tokensB).length;
      final union = tokensA.union(tokensB).length;
      tokenRatio = union == 0 ? 0 : intersection / union;
    }

    return (levRatio * 0.5) + (tokenRatio * 0.5);
  }

  int _levenshtein(String a, String b) {
    final la = a.length, lb = b.length;
    if (la == 0) return lb;
    if (lb == 0) return la;
    var prev = List<int>.generate(lb + 1, (i) => i);
    for (var i = 1; i <= la; i++) {
      final current = List<int>.filled(lb + 1, 0);
      current[0] = i;
      for (var j = 1; j <= lb; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        current[j] = [
          current[j - 1] + 1,
          prev[j] + 1,
          prev[j - 1] + cost,
        ].reduce((x, y) => x < y ? x : y);
      }
      prev = current;
    }
    return prev[lb];
  }

  double _titleScore(String targetNormalized, String candidateTitle, String candidateOriginal) {
    final s1 = _similarity(targetNormalized, normalizeTitle(candidateTitle));
    final s2 = candidateOriginal.isEmpty
        ? 0.0
        : _similarity(targetNormalized, normalizeTitle(candidateOriginal));
    return s1 > s2 ? s1 : s2;
  }

  double _yearScore(int? targetYear, int? candidateYear) {
    // Yıl bilgisi yoksa bu bileşeni nötr say (ne ceza ne bonus) — aksi
    // halde yıl vermeyen TV Time kayıtları haksız yere düşük puan alır.
    if (targetYear == null || candidateYear == null) return 0.6;
    final diff = (targetYear - candidateYear).abs();
    if (diff == 0) return 1;
    if (diff == 1) return 0.5; // yayın/TMDB kayıt tarihi farkı toleransı
    return 0.0;
  }

  // ---------------------------------------------------------------------
  // Dizi eşleştirme
  // ---------------------------------------------------------------------

  Future<TvTimeMatchOutcome> matchShow({
    required String rawName,
    int? episodesSeenHint,
  }) async {
    final hint = extractYearHint(rawName);
    final normalized = normalizeTitle(hint.clean);

    final result = await _tmdb.searchMulti(hint.clean);
    if (result.tvShows.isEmpty) return const TvTimeMatchOutcome.none();

    final scored = <_ScoredShow>[
      for (final candidate in result.tvShows)
        _ScoredShow(
          candidate,
          _titleWeight * _titleScore(normalized, candidate.name, candidate.originalName) +
              _yearWeight * _yearScore(hint.year, _yearOf(candidate.firstAirDate)),
        ),
    ]..sort((a, b) => b.score.compareTo(a.score));

    Future<List<_ScoredShow>> Function(List<_ScoredShow> top)? refine;
    if (episodesSeenHint != null) {
      refine = (List<_ScoredShow> topScored) async {
        // Belirsiz durumda TMDB'den sezon/bölüm sayısını çekip TV Time'daki
        // izlenen bölüm sayısıyla tutarlılığını ekstra bir sinyal olarak
        // puana katıyoruz.
        final refined = <_ScoredShow>[];
        for (final s in topScored) {
          var score = s.score;
          try {
            final detail = await _tmdb.getTvDetail(s.show.id);
            if (detail.numberOfEpisodes > 0) {
              final consistent = episodesSeenHint <= detail.numberOfEpisodes + 2;
              score += consistent ? 0.08 : -0.15;
            }
          } catch (_) {
            // Detay alınamazsa mevcut puanla devam.
          }
          refined.add(_ScoredShow(s.show, score));
        }
        refined.sort((a, b) => b.score.compareTo(a.score));
        return refined;
      };
    }

    return _resolve<_ScoredShow>(
      scored,
      toCandidate: (s) => TvTimeMatchCandidate(
        tmdbId: s.show.id,
        title: s.show.name,
        originalTitle: s.show.originalName,
        year: _yearOf(s.show.firstAirDate),
        releaseDate: s.show.firstAirDate,
        posterPath: s.show.posterPath,
        voteAverage: s.show.voteAverage,
        voteCount: s.show.voteCount,
        score: s.score,
      ),
      refineTopN: refine,
    );
  }

  // ---------------------------------------------------------------------
  // Film eşleştirme
  // ---------------------------------------------------------------------

  Future<TvTimeMatchOutcome> matchMovie({
    required String rawName,
    int? releaseYearHint,
    int? runtimeMinutesHint,
  }) async {
    final hint = extractYearHint(rawName);
    final effectiveYear = releaseYearHint ?? hint.year;
    final normalized = normalizeTitle(hint.clean);

    final result = await _tmdb.searchMulti(hint.clean);
    if (result.movies.isEmpty) return const TvTimeMatchOutcome.none();

    final scored = <_ScoredMovie>[
      for (final candidate in result.movies)
        _ScoredMovie(
          candidate,
          _titleWeight * _titleScore(normalized, candidate.title, candidate.originalTitle) +
              _yearWeight * _yearScore(effectiveYear, _yearOf(candidate.releaseDate)),
        ),
    ]..sort((a, b) => b.score.compareTo(a.score));

    Future<List<_ScoredMovie>> Function(List<_ScoredMovie> top)? refine;
    if (runtimeMinutesHint != null) {
      refine = (List<_ScoredMovie> topScored) async {
        // Belirsiz durumda (ör. aynı isimli remake) TMDB'den süreyi çekip
        // TV Time'daki kayıtlı süreyle tutarlılığını ekstra bir sinyal
        // olarak puana katıyoruz.
        final refined = <_ScoredMovie>[];
        for (final s in topScored) {
          var score = s.score;
          try {
            final detail = await _tmdb.getMovieDetail(s.movie.id);
            if (detail.runtime > 0) {
              final diff = (detail.runtime - runtimeMinutesHint).abs();
              score += diff <= 3 ? 0.08 : (diff <= 10 ? 0.0 : -0.15);
            }
          } catch (_) {
            // Detay alınamazsa mevcut puanla devam.
          }
          refined.add(_ScoredMovie(s.movie, score));
        }
        refined.sort((a, b) => b.score.compareTo(a.score));
        return refined;
      };
    }

    return _resolve<_ScoredMovie>(
      scored,
      toCandidate: (s) => TvTimeMatchCandidate(
        tmdbId: s.movie.id,
        title: s.movie.title,
        originalTitle: s.movie.originalTitle,
        year: _yearOf(s.movie.releaseDate),
        releaseDate: s.movie.releaseDate,
        posterPath: s.movie.posterPath,
        voteAverage: s.movie.voteAverage,
        voteCount: s.movie.voteCount,
        score: s.score,
      ),
      refineTopN: refine,
    );
  }

  /// Ortak karar mantığı: en iyi adayla ikincisi arasındaki fark yeterince
  /// büyükse (ve en iyi aday makul bir eşikteyse) net eşleşme; değilse
  /// (gerekirse [refineTopN] ile ek bilgi toplanıp tekrar denendikten sonra
  /// da) belirsizlik kullanıcıya bırakılır.
  Future<TvTimeMatchOutcome> _resolve<T extends _Scored>(
    List<T> sortedScored, {
    required TvTimeMatchCandidate Function(T) toCandidate,
    required Future<List<T>> Function(List<T> top)? refineTopN,
  }) async {
    double scoreOf(T s) => s.score;

    var working = sortedScored;
    if (working.isEmpty || scoreOf(working.first) < _minPlausibleScore) {
      return const TvTimeMatchOutcome.none();
    }

    var isClose = working.length > 1 &&
        (scoreOf(working[0]) - scoreOf(working[1])) < _ambiguityMargin &&
        scoreOf(working[1]) >= _minPlausibleScore;

    if (isClose && refineTopN != null) {
      final top = working.take(3).toList();
      working = await refineTopN(top);
      isClose = working.length > 1 &&
          (scoreOf(working[0]) - scoreOf(working[1])) < _ambiguityMargin &&
          scoreOf(working[1]) >= _minPlausibleScore;
    }

    if (!isClose) {
      final best = toCandidate(working.first);

      // Tek güçlü aday bulundu ama TMDB'deki kaydında ne afiş ne de oy/puan
      // verisi var (looksUnreliable). Bu genelde ya yanlış bir eşleşmedir
      // ya da TMDB'de içeriği henüz doldurulmamış bir girdidir; sessizce
      // otomatik aktarmak yerine kullanıcıya manuel onay/seçim sorulur.
      // Elde varsa bir sonraki en iyi 2 aday da (daha dolu veriyle) seçenek
      // olarak sunulur.
      if (best.looksUnreliable) {
        return TvTimeMatchOutcome.ambiguous([
          best,
          ...working.skip(1).take(2).map(toCandidate),
        ]);
      }

      return TvTimeMatchOutcome.matched(best);
    }

    return TvTimeMatchOutcome.ambiguous(
      working.take(3).map(toCandidate).toList(),
    );
  }

  int? _yearOf(String dateStr) {
    if (dateStr.isEmpty) return null;
    return int.tryParse(dateStr.split('-').first);
  }
}

abstract class _Scored {
  double get score;
}

class _ScoredShow implements _Scored {
  _ScoredShow(this.show, this.score);
  final TvShowModel show;
  @override
  final double score;
}

class _ScoredMovie implements _Scored {
  _ScoredMovie(this.movie, this.score);
  final MovieModel movie;
  @override
  final double score;
}
