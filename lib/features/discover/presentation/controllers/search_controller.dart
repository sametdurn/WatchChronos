import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../media/data/models/multi_search_result_model.dart';
import '../../../media/data/tmdb_repository.dart';

/// Arama kutusundaki her tuş vuruşunda TMDB'ye istek atmamak için ~400ms
/// debounce uygulayan controller. Sorgu boşsa boş sonuç döner.
class DiscoverSearchController extends AsyncNotifier<MultiSearchResultModel> {
  Timer? _debounce;
  int _requestId = 0;

  @override
  Future<MultiSearchResultModel> build() async {
    ref.onDispose(() => _debounce?.cancel());
    return const MultiSearchResultModel();
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = const AsyncData(MultiSearchResultModel());
      return;
    }

    state = const AsyncLoading<MultiSearchResultModel>();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      unawaited(_search(trimmed));
    });
  }

  Future<void> _search(String query) async {
    final currentRequestId = ++_requestId;

    AsyncValue<MultiSearchResultModel> result;
    try {
      result = await AsyncValue.guard(() {
        final repository = ref.read(tmdbRepositoryProvider);
        return repository.searchMulti(query);
      });
    } catch (error, stackTrace) {
      // AsyncValue.guard normalde her hatayı yakalar; bu blok sadece
      // beklenmedik bir durumda state'in sonsuza kadar "loading" takılı
      // kalmaması için son bir güvenlik ağı.
      result = AsyncError(error, stackTrace);
    }

    // Kullanıcı yazmaya devam ettiyse eski sonuç UI'a yansımasın.
    if (currentRequestId != _requestId) return;
    state = result;
  }
}

final discoverSearchControllerProvider = AsyncNotifierProvider<
    DiscoverSearchController, MultiSearchResultModel>(
  DiscoverSearchController.new,
);
