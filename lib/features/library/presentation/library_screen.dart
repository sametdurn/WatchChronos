import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/cache/models/cached_media.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/responsive_grid.dart';
import '../../auth/presentation/utils/sign_out_confirmation.dart';
import '../../media/data/media_repository.dart';
import '../../media/domain/tv_entry_classification.dart';
import '../../media/domain/tv_watch_progress.dart';
import '../../media/domain/upcoming_classification.dart';
import '../../watch_entries/data/models/media_type.dart';
import '../../watch_entries/data/models/watch_entry.dart';
import '../../watch_entries/data/models/watch_status.dart';
import '../../watch_entries/data/watch_entries_repository.dart';
import 'widgets/poster_grid_tile.dart';
import 'widgets/watch_entry_card.dart';

/// Kütüphanem sekmesi: Diziler / Filmler / Tamamlandı / Favoriler.
///
/// Diziler <-> Tamamlandı ayrımı veritabanında saklanan kalıcı bir alana
/// DEĞİL, her seferinde TMDB'den (cache-first) çekilen güncel dizi
/// `status` + izlenen bölüm sayısına göre anlık hesaplanır (bkz.
/// features/media/domain/tv_entry_classification.dart). Böylece iptal
/// edilen bir dizi başka bir platformda devam ederse veya kullanıcı henüz
/// tüm bölümleri bitirmemişse, otomatik olarak doğru sekmede/grupta
/// görünür.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Ayarlar ve Profil sekmeleriyle ORTAK çıkış onay diyaloğu — bkz.
  /// `confirmSignOut` (features/auth/presentation/utils/sign_out_confirmation.dart).
  /// Bu ekrandaki app bar'daki çıkış ikonu daha önce onay istemeden
  /// doğrudan `signOut()` çağırıyordu; artık diğer ekranlarla birebir
  /// aynı diyaloğu kullanıyor.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WatchChronos'),
        actions: [
          IconButton(
            onPressed: () => confirmSignOut(context, ref),
            icon: const Icon(Icons.logout_rounded),
            tooltip: context.l10n.t('settings_sign_out'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(text: context.l10n.t('library_tab_shows')),
            Tab(text: context.l10n.t('library_tab_movies')),
            Tab(text: context.l10n.t('library_tab_completed')),
            Tab(text: context.l10n.t('library_tab_upcoming')),
            Tab(text: context.l10n.t('library_tab_favorites')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _DizilerTab(),
          _FilmlerTab(),
          _TamamlandiTab(),
          _YaklasanlarTab(),
          _FavoritesTab(),
        ],
      ),
    );
  }
}

/// Bir dizi kaydını sınıflandırmak için gereken bağlamı (medya + izlenen
/// bölüm sayısı) birlikte taşıyan yardımcı kayıt. `reachedEndOfAiredEpisodes`,
/// kullanıcının TMDB'de fiilen yayınlanmış tüm bölümleri izleyip izlemediğini
/// ifade eder (bkz. `hasReachedEndOfAiredTvEpisodes`); `classifyTvEntry`'nin
/// "Tüm bölümler izlendi" tespitini kart üzerindeki sıradaki-bölüm
/// hesaplamasıyla tutarlı hâle getirmek için kullanılır.
typedef _TvContext = ({
  WatchEntry entry,
  CachedMedia media,
  int watchedCount,
  bool reachedEndOfAiredEpisodes,
});

/// Önceden her [WatchEntry] için `watchedEpisodesTotalCount` ayrı ayrı
/// çağrılıyordu (N dizi = N sorgu). Artık tüm izlenen bölüm sayıları tek
/// bir toplu sorguyla (`watchedEpisodesTotalCounts`) çekiliyor; sadece
/// medya detayları (cache-first, TMDB) hâlâ dizi başına çekiliyor.
Future<List<_TvContext>> _loadTvContext(
  List<WatchEntry> entries,
  MediaRepository mediaRepository,
  WatchEntriesRepository watchEntriesRepository, {
  bool forceRefresh = false,
}) async {
  final countsFuture = watchEntriesRepository.watchedEpisodesTotalCounts(
    watchEntryIds: entries.map((e) => e.id).toList(),
  );
  final mediaListFuture = Future.wait(
    entries.map(
      (entry) => mediaRepository.getMediaDetail(
        tmdbId: entry.tmdbId,
        mediaType: MediaType.tv,
        forceRefresh: forceRefresh,
      ),
    ),
  );

  final counts = await countsFuture;
  final mediaList = await mediaListFuture;

  // Sadece kullanıcı zaten TMDB'nin bildirdiği son sezonda ya da onun bir
  // gerisinde olan dizilerde gerekli (bkz. classifyTvEntry); diğerlerinde
  // gereksiz ağ isteği yapmamak için atlanır. Hata durumunda (ör.
  // çevrimdışı) sessizce false'a düşülür, aggregate sayım yoluna geri
  // dönülür.
  final reachedEndFlags = await Future.wait([
    for (var i = 0; i < entries.length; i++)
      hasReachedEndOfAiredTvEpisodes(
        tmdbId: entries[i].tmdbId,
        currentSeason: entries[i].currentSeason,
        currentEpisode: entries[i].currentEpisode,
        numberOfSeasons: mediaList[i].numberOfSeasons,
        mediaRepository: mediaRepository,
      ),
  ]);

  return [
    for (var i = 0; i < entries.length; i++)
      (
        entry: entries[i],
        media: mediaList[i],
        watchedCount: counts[entries[i].id] ?? 0,
        reachedEndOfAiredEpisodes: reachedEndFlags[i],
      ),
  ];
}

/// [_loadTvContext] ile aynı amaca hizmet eder ama filmler için: izlenen
/// bölüm sayısı gibi diziye özgü alanlar filmlerde anlamsız olduğundan
/// `watchedCount`/`reachedEndOfAiredEpisodes` hep sabit değerlerle doldurulur.
Future<List<_TvContext>> _loadMovieContext(
  List<WatchEntry> entries,
  MediaRepository mediaRepository, {
  bool forceRefresh = false,
}) async {
  final mediaList = await Future.wait(
    entries.map(
      (entry) => mediaRepository.getMediaDetail(
        tmdbId: entry.tmdbId,
        mediaType: MediaType.movie,
        forceRefresh: forceRefresh,
      ),
    ),
  );

  return [
    for (var i = 0; i < entries.length; i++)
      (
        entry: entries[i],
        media: mediaList[i],
        watchedCount: 0,
        reachedEndOfAiredEpisodes: false,
      ),
  ];
}

/// "Diziler" sekmesi: henüz tamamlanmamış (bkz. [TvLibrarySection])
/// diziler. "İzleniyor", "Devamı Gelecek" ve "Henüz Başlanmadı" olarak üç
/// alt gruba ayrılır.
///
/// Bir bölüm izlendi olarak işaretlendiğinde `watchEntries` stream'i yeni
/// bir liste yayınlar; bu SADECE ilgili dizinin `current_season`/
/// `current_episode` alanını değiştirir. Eskiden bu durumda tüm liste
/// yeniden hesaplanırken ekranda kısa süreliğine tam sayfa yükleniyor
/// (spinner) gösteriliyordu. Bunu önlemek için, önceki sonuç ekranda
/// tutulur ve güncel veri arka planda sessizce yüklenip hazır olduğunda
/// yerine konur; yalnızca ilk açılışta bekleme göstergesi gösterilir.
class _DizilerTab extends ConsumerStatefulWidget {
  const _DizilerTab();

  @override
  ConsumerState<_DizilerTab> createState() => _DizilerTabState();
}

class _DizilerTabState extends ConsumerState<_DizilerTab> {
  List<_TvContext>? _tvContext;
  bool _loading = false;
  String? _loadedSignature;

  // ÖNEMLİ: Sınıflandırma (bkz. tv_entry_classification.dart) artık hem
  // `entry.status` hem bölüm sayısına bakıyor; `entry.status` her zaman
  // `watchEntries` stream'inden taze geldiği için, yeniden hesaplamayı
  // tetiklemek için ARTIK her build'de koşulsuz yeniden sorgu atmaya gerek
  // yok. Eskiden burada koşulsuz bir `_ensureLoaded` çağrısı vardı; bu,
  // `setState` -> yeniden build -> tekrar `_ensureLoaded` -> tekrar
  // `setState` şeklinde kendi kendini besleyen bir döngüye yol açıyordu.
  // Bu döngü hem gereksiz sorgu yüküne hem de (kararlı olmayan sıralamayla
  // birleşince) kartların ara sıra pozisyon değiştirip AnimatedSwitcher
  // geçişini yanlışlıkla tetiklemesine sebep oluyordu. Artık yalnızca
  // girdi listesi gerçekten değiştiğinde (veya elle "aşağı çekip
  // yenile" yapıldığında) yeniden yükleniyor.
  Future<void> _ensureLoaded(
    List<WatchEntry> entries,
    MediaRepository mediaRepository,
    WatchEntriesRepository repository, {
    bool forceRefresh = false,
  }) async {
    final signature = entries
        .map((e) => '${e.id}:${e.status.name}:${e.updatedAt.microsecondsSinceEpoch}')
        .join('|');
    if (!forceRefresh && _tvContext != null && signature == _loadedSignature) {
      return;
    }
    if (_loading) return;
    _loading = true;
    try {
      final data = await _loadTvContext(
        entries,
        mediaRepository,
        repository,
        forceRefresh: forceRefresh,
      );
      if (!mounted) return;
      _loadedSignature = signature;
      setState(() => _tvContext = data);
    } finally {
      _loading = false;
    }
  }

  static const _tvStatuses = {
    WatchStatus.planned,
    WatchStatus.watching,
    WatchStatus.completed,
  };

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(watchEntriesRepositoryProvider);
    final mediaRepository = ref.watch(mediaRepositoryProvider);
    final entriesAsync = ref.watch(libraryEntriesStreamProvider);

    if (entriesAsync.isLoading && _tvContext == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (entriesAsync.hasError && _tvContext == null) {
      return const _ErrorMessage();
    }

    final entries = (entriesAsync.asData?.value ?? const <WatchEntry>[])
        .where(
          (e) => e.mediaType == MediaType.tv && _tvStatuses.contains(e.status),
        )
        .toList();

        if (entries.isEmpty && _tvContext == null) {
          return _EmptyMessage(
            message: context.l10n.t('library_no_shows'),
          );
        }

        // Güncel veriyi ekrandaki listeyi bozmadan arka planda yükle.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _ensureLoaded(entries, mediaRepository, repository);
        });

        if (_tvContext == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final watching = <_TvContext>[];
        final upcoming = <_TvContext>[];
        final notStarted = <_TvContext>[];

        for (final tv in _tvContext!) {
          // Henüz hiç bölümü yayınlanmamış diziler burada değil,
          // Yaklaşanlar sekmesinde gösterilir. Çıkış tarihi geldiğinde bu
          // kontrol artık `false` döner ve dizi otomatik olarak buraya
          // (Henüz Başlanmadı grubuna) düşer.
          if (isUnreleasedTv(tv.media)) continue;
          final section = classifyTvEntry(
            media: tv.media,
            entry: tv.entry,
            watchedEpisodesCount: tv.watchedCount,
            reachedEndOfAiredEpisodes: tv.reachedEndOfAiredEpisodes,
          );
          switch (section) {
            case TvLibrarySection.watching:
              watching.add(tv);
              break;
            case TvLibrarySection.upcoming:
              upcoming.add(tv);
              break;
            case TvLibrarySection.notStarted:
              notStarted.add(tv);
              break;
            case TvLibrarySection.completed:
              break; // Tamamlandı sekmesinde gösterilir.
          }
        }

        // En son bölümü izlenen dizi en üstte görünsün diye "İzleniyor"
        // listesi `updated_at`'e göre (en yeni önce) sıralanır. `updated_at`
        // bir bölüm izlendi işaretlendiğinde (current_season/current_episode
        // güncellemesiyle birlikte) DB tarafından otomatik güncellenir.
        //
        // ÖNEMLİ: `updated_at` aynı olan girdiler için (ör. TV Time'dan
        // toplu aktarılan diziler hep aynı ana sahip olur) ikinci bir
        // kıyaslama (entry.id) eklenmezse sıralama KARARLI olmaz — Dart'ın
        // `sort`'u eşit elemanlarda sıra garantisi vermez. Bu da her
        // yeniden hesaplamada aynı listenin farklı sırada çıkmasına, dolayı
        // ile aşağıdaki kartların (aşağıda [key] eklense bile) gereksiz yer
        // değiştirmesine yol açabiliyordu. `entry.id`'yi ikincil anahtar
        // yaparak sıralamayı kararlı hale getiriyoruz.
        watching.sort((a, b) {
          final cmp = b.entry.updatedAt.compareTo(a.entry.updatedAt);
          return cmp != 0 ? cmp : a.entry.id.compareTo(b.entry.id);
        });

        Future<void> onRefresh() =>
            _ensureLoaded(entries, mediaRepository, repository, forceRefresh: true);

        if (watching.isEmpty && upcoming.isEmpty && notStarted.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _EmptyMessage(
                  message: context.l10n.t('library_no_ongoing_shows'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (watching.isNotEmpty) ...[
                _SectionHeader(title: context.l10n.t('library_section_watching')),
                ...watching.map(
                  (tv) => WatchEntryCard(
                    key: ValueKey(tv.entry.id),
                    entry: tv.entry,
                    watchedCount: tv.watchedCount,
                  ),
                ),
              ],
              if (upcoming.isNotEmpty) ...[
                _SectionHeader(title: context.l10n.t('library_section_upcoming')),
                ...upcoming.map(
                  (tv) => WatchEntryCard(
                    key: ValueKey(tv.entry.id),
                    entry: tv.entry,
                    watchedCount: tv.watchedCount,
                  ),
                ),
              ],
              if (notStarted.isNotEmpty) ...[
                _SectionHeader(title: context.l10n.t('library_section_not_started')),
                ...notStarted.map(
                  (tv) => WatchEntryCard(
                    key: ValueKey(tv.entry.id),
                    entry: tv.entry,
                    watchedCount: tv.watchedCount,
                  ),
                ),
              ],
            ],
          ),
        );
  }
}

/// "Filmler" sekmesi: kapak resimleriyle grid görünümü, en yeni yapım
/// yılına sahip film en üstte (solda) olacak şekilde sıralanır.
class _FilmlerTab extends ConsumerStatefulWidget {
  const _FilmlerTab();

  @override
  ConsumerState<_FilmlerTab> createState() => _FilmlerTabState();
}

class _FilmlerTabState extends ConsumerState<_FilmlerTab> {
  List<_TvContext>? _movies;
  bool _loading = false;
  String? _loadedSignature;

  // _DizilerTabState._ensureLoaded'daki ile AYNI kök sorun burada da
  // vardı: `build()` her çalıştığında koşulsuz `addPostFrameCallback` ile
  // `_ensureLoaded` tetikleniyor, o da işi bitirince `setState` çağırıyor,
  // bu da yeni bir `build()` -> yeni bir `_ensureLoaded` çağrısına yol
  // açıyordu. Sonuç: sekme ekranda kaldığı sürece duran bir döngü —
  // cache taze olsa bile sürekli yeniden hesaplama/rebuild, cache
  // süresi (7 gün) dolduğunda ise TMDB'ye art arda gereksiz istek.
  // Diziler sekmesindeki çözümle birebir aynı yaklaşım: girdi listesi
  // gerçekten değişmediyse (id + updatedAt imzası aynıysa) ve zorla
  // yenileme istenmediyse hiçbir şey yapmadan çık.
  Future<void> _ensureLoaded(
    List<WatchEntry> entries,
    MediaRepository mediaRepository,
    WatchEntriesRepository repository, {
    bool forceRefresh = false,
  }) async {
    final signature = entries
        .map((e) => '${e.id}:${e.updatedAt.microsecondsSinceEpoch}')
        .join('|');
    if (!forceRefresh && _movies != null && signature == _loadedSignature) {
      return;
    }
    if (_loading) return;
    _loading = true;
    try {
      final mediaList = await Future.wait(
        entries.map(
          (entry) => mediaRepository.getMediaDetail(
            tmdbId: entry.tmdbId,
            mediaType: MediaType.movie,
            forceRefresh: forceRefresh,
          ),
        ),
      );
      final List<_TvContext> combined = [
        for (var i = 0; i < entries.length; i++)
          (
            entry: entries[i],
            media: mediaList[i],
            watchedCount: 0,
            reachedEndOfAiredEpisodes: false,
          ),
      ];
      // Henüz vizyona girmemiş filmler burada değil, Yaklaşanlar
      // sekmesinde gösterilir. Vizyon tarihi geldiğinde bu kontrol artık
      // `false` döner ve film otomatik olarak buraya düşer.
      final released = combined
          .where((movie) => !isUnreleasedMovie(movie.media))
          .toList();
      // En yeni yapım yılı en üstte: `releaseDate` olmayanlar en sona atılır.
      released.sort((a, b) {
        final dateA = a.media.releaseDate;
        final dateB = b.media.releaseDate;
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA);
      });
      if (!mounted) return;
      _loadedSignature = signature;
      setState(() => _movies = released);
    } finally {
      _loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(watchEntriesRepositoryProvider);
    final mediaRepository = ref.watch(mediaRepositoryProvider);
    final entriesAsync = ref.watch(libraryEntriesStreamProvider);

    if (entriesAsync.isLoading && _movies == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (entriesAsync.hasError && _movies == null) return const _ErrorMessage();

    final entries = (entriesAsync.asData?.value ?? const <WatchEntry>[])
        .where(
          (e) =>
              e.mediaType == MediaType.movie &&
              e.status != WatchStatus.completed,
        )
        .toList();

        if (entries.isEmpty && _movies == null) {
          return _EmptyMessage(
            message: context.l10n.t('library_no_movies'),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _ensureLoaded(entries, mediaRepository, repository);
        });

        final movies = _movies;
        Future<void> onRefresh() => _ensureLoaded(
          entries,
          mediaRepository,
          repository,
          forceRefresh: true,
        );

        if (movies == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (movies.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _EmptyMessage(
                  message: context.l10n.t('library_no_movies'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: responsivePosterExtent(context),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2 / 3,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) => PosterGridTile(
              entry: movies[index].entry,
              media: movies[index].media,
            ),
          ),
        );
  }
}

/// "Yaklaşanlar" sekmesi: kütüphaneye eklenmiş ama TMDB'de henüz hiç
/// bölümü/vizyonu yayınlanmamış diziler ve filmler, ayrı başlıklar altında
/// gösterilir. Bir yapımın çıkış tarihi geldiğinde ([isUnreleasedTv]/
/// [isUnreleasedMovie] `false` döner) otomatik olarak buradan kalkar ve
/// normal Diziler/Filmler sekmesinde görünmeye başlar — ayrıca bir "taşıma"
/// işlemi yapılmaz, filtre her build'de tarihe göre yeniden hesaplanır.
class _YaklasanlarTab extends ConsumerStatefulWidget {
  const _YaklasanlarTab();

  @override
  ConsumerState<_YaklasanlarTab> createState() => _YaklasanlarTabState();
}

class _YaklasanlarTabState extends ConsumerState<_YaklasanlarTab> {
  // Bilerek `_DizilerTab`/`_FilmlerTab`'daki gibi imza bazlı önbellekleme
  // KULLANILMIYOR: buradaki sınıflandırma (bkz. isUnreleasedTv/Movie)
  // saatin geçmesine bağlı olarak değişiyor, ama entry'lerin kendisi
  // (status/updatedAt) çıkış tarihi geldiğinde değişmiyor. İmza bazlı bir
  // önbellek bu durumda eskimiş sonucu sonsuza dek gösterip sadece uygulama
  // yeniden başlatılınca düzelirdi. Bunun yerine `_TamamlandiTab` ile aynı
  // desen kullanılır: sonuç her build'de taze hesaplanır, `_forceRefresh`
  // ise sadece "aşağı çekip yenile" ile TMDB'den zorla tekrar çekmeyi
  // tetiklemek için bir anahtardır.
  bool _forceRefresh = false;

  static const _tvStatuses = {WatchStatus.planned, WatchStatus.watching};

  Future<void> _onRefresh(
    List<WatchEntry> tvEntries,
    List<WatchEntry> movieEntries,
    MediaRepository mediaRepository,
    WatchEntriesRepository repository,
  ) async {
    await Future.wait([
      _loadTvContext(
        tvEntries,
        mediaRepository,
        repository,
        forceRefresh: true,
      ),
      _loadMovieContext(movieEntries, mediaRepository, forceRefresh: true),
    ]);
    if (mounted) setState(() => _forceRefresh = !_forceRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(watchEntriesRepositoryProvider);
    final mediaRepository = ref.watch(mediaRepositoryProvider);
    final entriesAsync = ref.watch(libraryEntriesStreamProvider);

    if (entriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (entriesAsync.hasError) {
      return const _ErrorMessage();
    }

    final allEntries = entriesAsync.asData?.value ?? const <WatchEntry>[];
    final tvEntries = allEntries
        .where(
          (e) => e.mediaType == MediaType.tv && _tvStatuses.contains(e.status),
        )
        .toList();
    final movieEntries = allEntries
        .where(
          (e) =>
              e.mediaType == MediaType.movie &&
              e.status != WatchStatus.completed,
        )
        .toList();

    Future<void> onRefresh() =>
        _onRefresh(tvEntries, movieEntries, mediaRepository, repository);

    return FutureBuilder<List<List<_TvContext>>>(
      key: ValueKey(_forceRefresh),
      future: Future.wait([
        _loadTvContext(tvEntries, mediaRepository, repository),
        _loadMovieContext(movieEntries, mediaRepository),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const _ErrorMessage();
        }

        final upcomingTv =
            snapshot.data![0].where((tv) => isUnreleasedTv(tv.media)).toList()
              ..sort((a, b) {
                // En yakın çıkış tarihi en üstte; tarihi belirsiz olanlar
                // en sona.
                final dateA = a.media.firstAirDate;
                final dateB = b.media.firstAirDate;
                if (dateA == null && dateB == null) return 0;
                if (dateA == null) return 1;
                if (dateB == null) return -1;
                return dateA.compareTo(dateB);
              });

        final upcomingMovies =
            snapshot.data![1]
                .where((movie) => isUnreleasedMovie(movie.media))
                .toList()
              ..sort((a, b) {
                final dateA = a.media.releaseDate;
                final dateB = b.media.releaseDate;
                if (dateA == null && dateB == null) return 0;
                if (dateA == null) return 1;
                if (dateB == null) return -1;
                return dateA.compareTo(dateB);
              });

        if (upcomingTv.isEmpty && upcomingMovies.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _EmptyMessage(message: context.l10n.t('library_no_upcoming')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (upcomingTv.isNotEmpty) ...[
                _SectionHeader(
                  title: context.l10n.t('library_upcoming_shows_title'),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: responsivePosterExtent(context),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2 / 3,
                  ),
                  itemCount: upcomingTv.length,
                  itemBuilder: (context, index) => PosterGridTile(
                    entry: upcomingTv[index].entry,
                    media: upcomingTv[index].media,
                  ),
                ),
              ],
              if (upcomingMovies.isNotEmpty) ...[
                _SectionHeader(
                  title: context.l10n.t('library_upcoming_movies_title'),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: responsivePosterExtent(context),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2 / 3,
                  ),
                  itemCount: upcomingMovies.length,
                  itemBuilder: (context, index) => PosterGridTile(
                    entry: upcomingMovies[index].entry,
                    media: upcomingMovies[index].media,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// "Tamamlandı" sekmesi: tamamlanmış diziler + izlenmiş filmler, ayrı
/// başlıklar altında yana kayan poster listeleri olarak gösterilir.
class _TamamlandiTab extends ConsumerStatefulWidget {
  const _TamamlandiTab();

  @override
  ConsumerState<_TamamlandiTab> createState() => _TamamlandiTabState();
}

class _TamamlandiTabState extends ConsumerState<_TamamlandiTab> {
  bool _forceRefresh = false;

  static const _tvStatuses = {
    WatchStatus.planned,
    WatchStatus.watching,
    WatchStatus.completed,
  };

  Future<void> _onRefresh(
    List<WatchEntry> tvEntries,
    MediaRepository mediaRepository,
    WatchEntriesRepository repository,
  ) async {
    // Kütüphane sekmesindeki (Diziler) önbellek tazeliği sorunuyla aynı
    // kökten kaçınmak için: aşağı çekip yenile, TMDB verisini zorla tazeler
    // ve ardından bir sonraki `build`'de bu taze veriyle yeniden hesaplanır.
    await _loadTvContext(
      tvEntries,
      mediaRepository,
      repository,
      forceRefresh: true,
    );
    if (mounted) setState(() => _forceRefresh = !_forceRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(watchEntriesRepositoryProvider);
    final mediaRepository = ref.watch(mediaRepositoryProvider);
    final entriesAsync = ref.watch(libraryEntriesStreamProvider);

    if (entriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (entriesAsync.hasError) return const _ErrorMessage();

    final allEntries = entriesAsync.asData?.value ?? const <WatchEntry>[];
    final completedMovies = allEntries
        .where(
          (e) =>
              e.mediaType == MediaType.movie &&
              e.status == WatchStatus.completed,
        )
        .toList();
    final tvEntries = allEntries
        .where(
          (e) =>
              e.mediaType == MediaType.tv &&
              _tvStatuses.contains(e.status),
        )
        .toList();

    {
      {
        return FutureBuilder<List<_TvContext>>(
              // `_forceRefresh` sadece yeni bir Future oluşturup aşağı
              // çekildiğinde gerçekten yeniden sorgu atılmasını sağlamak
              // için anahtar olarak kullanılıyor.
              key: ValueKey(_forceRefresh),
              future: _loadTvContext(tvEntries, mediaRepository, repository),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const _ErrorMessage();
                }

                final finishedTv = snapshot.data!
                    .where(
                      (tv) =>
                          classifyTvEntry(
                            media: tv.media,
                            entry: tv.entry,
                            watchedEpisodesCount: tv.watchedCount,
                            reachedEndOfAiredEpisodes: tv.reachedEndOfAiredEpisodes,
                          ) ==
                          TvLibrarySection.completed,
                    )
                    .map((tv) => tv.entry)
                    .toList()
                  ..sort(_byMostRecentlyFinished);

                final sortedCompletedMovies = [...completedMovies]
                  ..sort(_byMostRecentlyFinished);

                Future<void> onRefresh() =>
                    _onRefresh(tvEntries, mediaRepository, repository);

                if (finishedTv.isEmpty && completedMovies.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        _EmptyMessage(
                          message: context.l10n.t('library_no_completed'),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: onRefresh,
                  child: _CompletedSections(
                    finishedTv: finishedTv,
                    completedMovies: sortedCompletedMovies,
                  ),
                );
              },
            );
      }
    }
  }
}

/// Tamamlanan dizi/film girdilerini en son bitirilen en üstte olacak
/// şekilde sıralar. `finishedAt`, bir kayıt "completed" durumuna ilk
/// geçtiğinde bir kere set edilir (bkz. WatchEntriesRepository.upsertStatus);
/// bu alan henüz dolmamış eski kayıtlarda `updatedAt`'e geri düşülür.
int _byMostRecentlyFinished(WatchEntry a, WatchEntry b) {
  final aDate = a.finishedAt ?? a.updatedAt;
  final bDate = b.finishedAt ?? b.updatedAt;
  return bDate.compareTo(aDate);
}

/// Favori dizi/film girdilerini en son favorilenen en üstte olacak şekilde
/// sıralar. `favoritedAt`, `is_favorite` false'tan true'ya geçtiğinde bir DB
/// trigger'ı tarafından otomatik set edilir (bkz.
/// 20260805120000_watch_entries_favorited_at.sql migration'ı) ve favori
/// KALDIĞI sürece başka bir alan değişse bile SABİT kalır — bu yüzden
/// `updatedAt` burada kullanılamaz (o, favori dışı her değişiklikte de
/// güncellenir ve sıralamayı yanlış yapar). Migration öncesi favorilenmiş
/// eski kayıtlar migration sırasında `updatedAt`'e yaklaşık dolduruldu; yine
/// de hiç dolmamış olma ihtimaline karşı burada da `updatedAt`'e düşülüyor.
int _byMostRecentlyFavorited(WatchEntry a, WatchEntry b) {
  final aDate = a.favoritedAt ?? a.updatedAt;
  final bDate = b.favoritedAt ?? b.updatedAt;
  return bDate.compareTo(aDate);
}

/// "Tamamlanan Diziler" ve "Tamamlanan Filmler" başlıklarını ve altlarında
/// yana kayan poster listelerini gösterir. Bir başlığa dokununca o türün
/// tam grid sayfası açılır.
class _CompletedSections extends StatelessWidget {
  const _CompletedSections({
    required this.finishedTv,
    required this.completedMovies,
  });

  final List<WatchEntry> finishedTv;
  final List<WatchEntry> completedMovies;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (finishedTv.isNotEmpty)
          _CompletedSection(
            title: context.l10n.t('library_completed_shows_title'),
            entries: finishedTv,
            mediaType: MediaType.tv,
          ),
        if (completedMovies.isNotEmpty)
          _CompletedSection(
            title: context.l10n.t('library_completed_movies_title'),
            entries: completedMovies,
            mediaType: MediaType.movie,
          ),
      ],
    );
  }
}

class _CompletedSection extends StatelessWidget {
  const _CompletedSection({
    required this.title,
    required this.entries,
    required this.mediaType,
  });

  final String title;
  final List<WatchEntry> entries;
  final MediaType mediaType;

  @override
  Widget build(BuildContext context) {
    return _HorizontalPosterSection(
      title: title,
      entries: entries,
      onSeeAll: () => context.push(
        AppRoutes.completedGrid(mediaType: mediaType.name),
      ),
    );
  }
}

/// Bir başlık + yana kayan poster listesi gösterir; başlığa dokununca
/// [onSeeAll] çağrılır (genelde tam grid sayfasını açar). Hem "Tamamlandı"
/// hem de "Favoriler" sekmelerinde diziler/filmler için ayrı ayrı
/// kullanılan ortak görsel yapı.
class _HorizontalPosterSection extends StatelessWidget {
  const _HorizontalPosterSection({
    required this.title,
    required this.entries,
    required this.onSeeAll,
  });

  final String title;
  final List<WatchEntry> entries;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Geniş ekranlarda (PC) yatay şerit sabit küçük boyutta kalıp altında
    // boşluk bırakmasın diye poster genişliği/yüksekliği ölçeklenir (bkz.
    // discover/widgets/trending_section.dart'taki aynı yaklaşım).
    final scale = posterStripScaleFactor(context);
    final tileWidth = 110 * scale;
    final sectionHeight = 190 * scale;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onSeeAll,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
          SizedBox(
            height: sectionHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: entries.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) => SizedBox(
                width: tileWidth,
                child: PosterGridTile(entry: entries[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Favoriler" sekmesi: [_TamamlandiTab] ile aynı görsel yapıda,
/// "Favori Diziler" ve "Favori Filmler" olarak türe göre ayrılmış yana
/// kayan poster listeleri. Bir başlığa dokununca o türün tam grid
/// sayfası ([FavoritesGridScreen]) açılır.
class _FavoritesTab extends ConsumerWidget {
  const _FavoritesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(libraryEntriesStreamProvider);

    if (entriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (entriesAsync.hasError) return const _ErrorMessage();

    final entries = (entriesAsync.asData?.value ?? const <WatchEntry>[])
        .where((e) => e.isFavorite)
        .toList();
    final favoriteTv = entries
        .where((e) => e.mediaType == MediaType.tv)
        .toList()
      ..sort(_byMostRecentlyFavorited);
    final favoriteMovies = entries
        .where((e) => e.mediaType == MediaType.movie)
        .toList()
      ..sort(_byMostRecentlyFavorited);

    if (favoriteTv.isEmpty && favoriteMovies.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(milliseconds: 300)),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _EmptyMessage(message: context.l10n.t('library_no_favorites')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => Future.delayed(const Duration(milliseconds: 300)),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (favoriteTv.isNotEmpty)
            _HorizontalPosterSection(
              title: context.l10n.t('library_favorite_shows_title'),
              entries: favoriteTv,
              onSeeAll: () => context.push(
                AppRoutes.favoritesGrid(mediaType: MediaType.tv.name),
              ),
            ),
          if (favoriteMovies.isNotEmpty)
            _HorizontalPosterSection(
              title: context.l10n.t('library_favorite_movies_title'),
              entries: favoriteMovies,
              onSeeAll: () => context.push(
                AppRoutes.favoritesGrid(mediaType: MediaType.movie.name),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.t('common_something_went_wrong'),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}