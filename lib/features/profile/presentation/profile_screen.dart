import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/responsive_grid.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/utils/sign_out_confirmation.dart';
import '../../watch_entries/data/watch_entries_repository.dart';
import '../data/models/profile.dart';
import '../data/profile_error_translator.dart';
import '../data/profile_repository.dart';

/// Profil sekmesi: kapak fotoğrafı + avatar (ikisi de değiştirilebilir),
/// kayıt sırasında seçilen ve sonradan değiştirilebilen kullanıcı adı
/// (sadece görüntü amaçlı; girişte kullanılmaz) ve `user_watch_stats`
/// view'inden gelen izleme istatistikleri.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _uploadingAvatar = false;
  bool _uploadingCover = false;

  void _showError(String messageKey) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.t(messageKey))));
  }

  String _resolveErrorMessageKey(Object error, String fallbackKey) {
    if (error is ProfileException) {
      return ProfileErrorTranslator.messageKey(error);
    }
    return fallbackKey;
  }

  Future<void> _pickAndUpload({required bool isAvatar}) async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) {
      _showError('profile_error_photo_read_failed');
      return;
    }
    final extension = (file.extension ?? 'jpg').toLowerCase();

    final repository = ref.read(profileRepositoryProvider);
    setState(() {
      if (isAvatar) {
        _uploadingAvatar = true;
      } else {
        _uploadingCover = true;
      }
    });
    try {
      if (isAvatar) {
        await repository.uploadAvatar(bytes: bytes, fileExtension: extension);
      } else {
        await repository.uploadCover(bytes: bytes, fileExtension: extension);
      }
    } catch (e) {
      _showError(_resolveErrorMessageKey(e, 'profile_error_photo_upload_failed'));
    } finally {
      if (mounted) {
        setState(() {
          if (isAvatar) {
            _uploadingAvatar = false;
          } else {
            _uploadingCover = false;
          }
        });
      }
    }
  }

  Future<void> _editUsername(String? current) async {
    final controller = TextEditingController(text: current ?? '');
    final newUsername = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.t('profile_edit_username_title')),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: dialogContext.l10n.t('register_username_label'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(dialogContext.l10n.t('common_cancel')),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(dialogContext.l10n.t('common_save')),
          ),
        ],
      ),
    );

    if (newUsername == null || newUsername.isEmpty || newUsername == current) {
      return;
    }
    if (newUsername.length < 3) {
      _showError('register_username_too_short');
      return;
    }

    try {
      await ref.read(profileRepositoryProvider).setUsername(newUsername);
    } catch (e) {
      _showError(_resolveErrorMessageKey(e, 'profile_error_username_update_failed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(profileStreamProvider);
    final email = ref.watch(authRepositoryProvider).currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.push(AppRoutes.settings),
          icon: const Icon(Icons.settings_rounded),
          tooltip: context.l10n.t('settings_title'),
        ),
        title: Text(context.l10n.t('nav_profile')),
        actions: [
          IconButton(
            onPressed: () => confirmSignOut(context, ref),
            icon: const Icon(Icons.logout_rounded),
            tooltip: context.l10n.t('settings_sign_out'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          ref.refresh(profileStreamProvider.future),
          ref.refresh(watchEntryStatsProvider.future),
        ]),
        child: profileAsync.when(
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(
                height: 400,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
          error: (error, stackTrace) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 400,
                child: Center(
                  child: Text(
                    context.l10n.t('profile_load_failed'),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
          data: (profile) {
            final isDesktopWidth = MediaQuery.sizeOf(context).width >= 900;
            final gapAfterCover = isDesktopWidth ? 6.0 : 12.0;
            final gapBeforeStats = isDesktopWidth ? 12.0 : 24.0;
            final gapAfterStatsTitle = isDesktopWidth ? 4.0 : 8.0;
            final gapAtEnd = isDesktopWidth ? 12.0 : 24.0;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _CoverAndAvatar(
                  profile: profile,
                  compact: isDesktopWidth,
                  uploadingAvatar: _uploadingAvatar,
                  uploadingCover: _uploadingCover,
                  onEditAvatar: () => _pickAndUpload(isAvatar: true),
                  onEditCover: () => _pickAndUpload(isAvatar: false),
                ),
                SizedBox(height: gapAfterCover),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (profile.username?.isNotEmpty ?? false)
                            ? profile.username!
                            : context.l10n.t('profile_unnamed_user'),
                        style: theme.textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () => _editUsername(profile.username),
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        tooltip: context.l10n.t('profile_edit_username_title'),
                      ),
                    ],
                  ),
                ),
                if (email != null)
                  Center(
                    child: Text(
                      email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                SizedBox(height: gapBeforeStats),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.l10n.t('profile_your_stats'),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                SizedBox(height: gapAfterStatsTitle),
                const _StatsSection(),
                SizedBox(height: gapAtEnd),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Kapak fotoğrafı + üzerine binen dairesel avatar. İkisinin de sağ
/// altında küçük bir kamera ikonu, dokununca [FilePicker] açar.
class _CoverAndAvatar extends StatelessWidget {
  const _CoverAndAvatar({
    required this.profile,
    required this.uploadingAvatar,
    required this.uploadingCover,
    required this.onEditAvatar,
    required this.onEditCover,
    this.compact = false,
  });

  final Profile profile;
  final bool uploadingAvatar;
  final bool uploadingCover;
  final VoidCallback onEditAvatar;
  final VoidCallback onEditCover;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverHeight = compact ? 160.0 : 160.0;
    final avatarRadius = compact ? 48.0 : 48.0;

    return SizedBox(
      height: coverHeight + avatarRadius,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: coverHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                profile.coverUrl == null
                    ? Container(color: theme.colorScheme.surfaceContainerHighest)
                    : CachedNetworkImage(
                        imageUrl: profile.coverUrl!,
                        fit: BoxFit.cover,
                      ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: _EditImageButton(
                    loading: uploadingCover,
                    onPressed: onEditCover,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: theme.colorScheme.surface,
                  child: CircleAvatar(
                    radius: avatarRadius - 4,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    backgroundImage: profile.avatarUrl == null
                        ? null
                        : CachedNetworkImageProvider(profile.avatarUrl!),
                    child: profile.avatarUrl == null
                        ? const Icon(Icons.person_rounded, size: 40)
                        : null,
                  ),
                ),
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: _EditImageButton(
                    loading: uploadingAvatar,
                    onPressed: onEditAvatar,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditImageButton extends StatelessWidget {
  const _EditImageButton({
    required this.loading,
    required this.onPressed,
    this.size = 32,
  });

  final bool loading;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: size,
        height: size,
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(6),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : IconButton(
                padding: EdgeInsets.zero,
                iconSize: size * 0.55,
                icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                onPressed: onPressed,
              ),
      ),
    );
  }
}

/// `user_watch_stats` view'inden (bkz. WatchEntriesRepository.getStats)
/// gelen özet sayılar; 2 sütunlu bir kart grid'i olarak gösterilir.
class _StatsSection extends ConsumerWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(watchEntryStatsProvider);
    return statsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(context.l10n.t('profile_stats_load_failed')),
        ),
      ),
      data: (stats) {
        final items = <_StatItem>[
          _StatItem(
            icon: Icons.tv_rounded,
            label: context.l10n.t('profile_stat_completed_shows'),
            value: '${stats?.completedTvCount ?? 0}',
          ),
          _StatItem(
            icon: Icons.movie_rounded,
            label: context.l10n.t('profile_stat_completed_movies'),
            value: '${stats?.completedMoviesCount ?? 0}',
          ),
          _StatItem(
            icon: Icons.play_circle_outline_rounded,
            label: context.l10n.t('library_section_watching'),
            value: '${stats?.watchingCount ?? 0}',
          ),
          _StatItem(
            icon: Icons.schedule_rounded,
            label: context.l10n.t('profile_stat_planned'),
            value: '${stats?.plannedCount ?? 0}',
          ),
          _StatItem(
            icon: Icons.favorite_rounded,
            label: context.l10n.t('media_detail_favorite'),
            value: '${stats?.favoritesCount ?? 0}',
          ),
          _StatItem(
            icon: Icons.checklist_rounded,
            label: context.l10n.t('profile_stat_episodes_watched'),
            value: '${stats?.episodesWatchedCount ?? 0}',
          ),
          _StatItem(
            icon: Icons.star_rounded,
            label: context.l10n.t('profile_stat_average_rating'),
            value: stats?.averageRating == null
                ? '—'
                : stats!.averageRating!.toStringAsFixed(1),
          ),
        ];

        final width = MediaQuery.sizeOf(context).width;
        final crossAxisCount = width >= 900 ? 4 : 2;
        final scale = posterStripScaleFactor(context);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: crossAxisCount == 4 ? 2.4 : 2.6,
            children: items
                .map((item) => _StatCard(item: item, scale: scale))
                .toList(),
          ),
        );
      },
    );
  }
}

class _StatItem {
  const _StatItem({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item, this.scale = 1.0});

  final _StatItem item;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueStyle = theme.textTheme.titleMedium;
    final labelStyle = theme.textTheme.bodySmall;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10 * scale,
          vertical: 8 * scale,
        ),
        child: Row(
          children: [
            Icon(item.icon, color: theme.colorScheme.primary, size: 20 * scale),
            SizedBox(width: 8 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.value,
                    style: valueStyle?.copyWith(
                      fontSize: (valueStyle.fontSize ?? 16) * scale,
                    ),
                  ),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle?.copyWith(
                      fontSize: (labelStyle.fontSize ?? 12) * scale,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}