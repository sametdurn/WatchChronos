import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../data/models/media_type.dart';
import '../../data/watch_entries_repository.dart';

/// Bir [mediaType] için kütüphanedeki tüm `tmdbId`'lerin kümesi.
///
/// Keşfet ekranındaki arama sonuçları ve gündem listelerinde aynı anda
/// birden çok [AddToLibraryButton] gösterildiği için üyelik kontrolü
/// kart başına ayrı bir sorgu yerine `mediaType` başına TEK bir
/// stream üzerinden yapılır (Riverpod aynı parametreyle watch eden tüm
/// widget'lar arasında bu stream'i otomatik olarak paylaşır/tekilleştirir).
/// Böylece 20 sonuçluk bir arama ekranı 20 yerine tek bir sorgu atar.
final _libraryTmdbIdsProvider = StreamProvider.autoDispose
    .family<Set<int>, MediaType>((ref, mediaType) {
      final repository = ref.watch(watchEntriesRepositoryProvider);
      return repository.libraryTmdbIds(mediaType: mediaType);
    });

/// Keşfet/gündem listelerinde kullanılan yuvarlak "+" (kütüphaneye ekle)
/// butonu. Zaten kütüphanede olan bir kayıt için dokununca hiçbir şey
/// yapmaz, sadece "eklendi" (tik) ikonu gösterir.
class AddToLibraryButton extends ConsumerStatefulWidget {
  const AddToLibraryButton({
    required this.tmdbId,
    required this.mediaType,
    this.size = 34,
    super.key,
  });

  final int tmdbId;
  final MediaType mediaType;
  final double size;

  @override
  ConsumerState<AddToLibraryButton> createState() =>
      _AddToLibraryButtonState();
}

class _AddToLibraryButtonState extends ConsumerState<AddToLibraryButton> {
  bool _busy = false;
  bool? _justAdded;

  Future<void> _add() async {
    if (_busy) return;
    setState(() => _busy = true);
    final repository = ref.read(watchEntriesRepositoryProvider);
    try {
      await repository.addToLibrary(
        tmdbId: widget.tmdbId,
        mediaType: widget.mediaType,
      );
      // `libraryTmdbIds` gerçek zamanlı (realtime) bir stream olduğu için
      // normalde kendiliğinden güncellenir; `_justAdded` sadece realtime
      // güncellemesi gelene kadar anlık bir geri bildirim sağlar.
      if (mounted) setState(() => _justAdded = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.l10n.t('media_detail_error_add_failed')),
            ),
          );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tmdbIdsAsync = ref.watch(_libraryTmdbIdsProvider(widget.mediaType));
    final inLibrary =
        _justAdded ?? (tmdbIdsAsync.value?.contains(widget.tmdbId) ?? false);

    return Material(
      color: inLibrary ? Colors.green.shade600 : Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: inLibrary ? null : _add,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: _busy
              ? Padding(
                  padding: EdgeInsets.all(widget.size * 0.26),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  inLibrary ? Icons.check_rounded : Icons.add_rounded,
                  color: Colors.white,
                  size: widget.size * 0.62,
                ),
        ),
      ),
    );
  }
}
