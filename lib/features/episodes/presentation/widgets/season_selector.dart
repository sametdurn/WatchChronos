import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

/// Sezonlar arasında yatay kaydırmalı chip seçici.
class SeasonSelector extends StatelessWidget {
  const SeasonSelector({
    required this.numberOfSeasons,
    required this.selectedSeason,
    required this.onSeasonSelected,
    super.key,
  });

  final int numberOfSeasons;
  final int selectedSeason;
  final ValueChanged<int> onSeasonSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: numberOfSeasons,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final seasonNumber = index + 1;
          final isSelected = seasonNumber == selectedSeason;
          return ChoiceChip(
            label: Text(
              context.l10n.tp('season_selector_label', {
                'number': '$seasonNumber',
              }),
            ),
            selected: isSelected,
            onSelected: (_) {
              if (!isSelected) onSeasonSelected(seasonNumber);
            },
          );
        },
      ),
    );
  }
}
