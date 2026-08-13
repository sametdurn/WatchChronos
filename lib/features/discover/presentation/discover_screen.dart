import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/network/api_exception.dart';
import '../../media/data/models/multi_search_result_model.dart';
import '../../media/data/tmdb_providers.dart';
import '../../watch_entries/data/models/media_type.dart';
import 'controllers/search_controller.dart';
import 'widgets/media_search_result_tile.dart';
import 'widgets/trending_section.dart';

/// [MediaSearchItem]'ları kullanıcının arama sorgusuna göre sıralar:
/// 1. Tam isim eşleşmeleri (başlık ya da orijinal isim sorguyla birebir
///    aynıysa), bunlar arasında en popüler olan en üstte.
/// 2. Sorguyla başlayan ("benzer") isimler, yine popülerliğe göre.
/// 3. Sorguyu herhangi bir yerinde geçiren kısmi eşleşmeler.
/// Film/dizi ayrımı yapılmaz; tek bir karışık liste olarak sıralanır.
List<MediaSearchItem> _rankSearchResults(
  List<MediaSearchItem> items,
  String query,
) {
  final q = query.trim().toLowerCase();

  int tierOf(MediaSearchItem item) {
    final title = item.title.trim().toLowerCase();
    final originalTitle = item.originalTitle.trim().toLowerCase();
    if (title == q || originalTitle == q) return 0; // tam eşleşme
    if (title.startsWith(q) || originalTitle.startsWith(q)) {
      return 1; // benzer isim
    }
    return 2; // kısmi eşleşme
  }

  final ranked = [...items];
  ranked.sort((a, b) {
    final tierA = tierOf(a);
    final tierB = tierOf(b);
    if (tierA != tierB) return tierA.compareTo(tierB);
    return b.popularity.compareTo(a.popularity);
  });
  return ranked;
}

/// Keşfet sekmesi: TMDB'de film/dizi arama (debounce'lu).
class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchTextController = TextEditingController();
  bool _hasQuery = false;

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() => _hasQuery = value.trim().isNotEmpty);
    ref.read(discoverSearchControllerProvider.notifier).onQueryChanged(value);
  }

  void _retry() {
    ref
        .read(discoverSearchControllerProvider.notifier)
        .onQueryChanged(_searchTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(discoverSearchControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchTextController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: context.l10n.t('discover_search_hint'),
            border: InputBorder.none,
            suffixIcon: _hasQuery
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchTextController.clear();
                      _onQueryChanged('');
                    },
                  )
                : null,
          ),
          onChanged: _onQueryChanged,
        ),
      ),
      body: _Body(
        searchState: searchState,
        hasQuery: _hasQuery,
        query: _searchTextController.text,
        onRetry: _retry,
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.searchState,
    required this.hasQuery,
    required this.query,
    required this.onRetry,
  });

  final AsyncValue<MultiSearchResultModel> searchState;
  final bool hasQuery;
  final String query;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (!hasQuery) {
      return RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(trendingTvShowsProvider(1));
          ref.invalidate(trendingMoviesProvider(1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          child: Column(
            children: [
              TrendingSection(
                title: context.l10n.t('discover_trending_shows'),
                mediaType: MediaType.tv,
              ),
              TrendingSection(
                title: context.l10n.t('discover_trending_movies'),
                mediaType: MediaType.movie,
              ),
            ],
          ),
        ),
      );
    }

    return searchState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.t('discover_search_failed'),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.t(_errorMessageKey(error)),
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onRetry,
                child: Text(context.l10n.t('common_retry')),
              ),
            ],
          ),
        ),
      ),
      data: (result) {
        final rawItems = [
          ...result.movies.map(MediaSearchItem.fromMovie),
          ...result.tvShows.map(MediaSearchItem.fromTvShow),
        ];
        final items = _rankSearchResults(rawItems, query);
        if (items.isEmpty) {
          return Center(
            child: Text(
              context.l10n.t('discover_no_results'),
              style: theme.textTheme.bodyMedium,
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          itemBuilder: (context, index) =>
              MediaSearchResultTile(item: items[index]),
        );
      },
    );
  }
}

String _errorMessageKey(Object error) {
  if (error is ApiException) return error.message;
  return 'common_unknown_error';
}
