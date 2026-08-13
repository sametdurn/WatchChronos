import 'package:flutter/material.dart';

import '../../../../core/cache/models/cached_episode.dart';
import '../../../../core/localization/app_localizations.dart';

/// Bölüm numarası + adı + izlendi checkbox'ı gösteren satır.
class EpisodeTile extends StatelessWidget {
  const EpisodeTile({
    required this.episode,
    required this.isWatched,
    required this.onChanged,
    super.key,
  });

  final CachedEpisode episode;
  final bool isWatched;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(child: Text('${episode.episodeNumber}')),
      title: Text(
        episode.name?.isNotEmpty == true
            ? episode.name!
            : context.l10n.tp('episode_tile_default_title', {
                'number': '${episode.episodeNumber}',
              }),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: episode.airDate == null
          ? null
          : Text(
              '${episode.airDate!.year}-${episode.airDate!.month.toString().padLeft(2, '0')}-${episode.airDate!.day.toString().padLeft(2, '0')}',
              style: theme.textTheme.bodyMedium,
            ),
      trailing: Checkbox(
        value: isWatched,
        onChanged: (value) => onChanged(value ?? false),
      ),
      onTap: () => onChanged(!isWatched),
    );
  }
}
