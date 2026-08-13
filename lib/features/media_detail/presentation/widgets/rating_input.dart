import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

/// 0-5 arası puanlamayı 5 yıldız üzerinden gösteren girdi. Her yıldız
/// 1 puana denk gelir (yıldız sayısı = puan). [rating] `null` ise henüz
/// puanlanmadığı gösterilir.
///
/// Puan verilmişse yıldızların sağında "Puanı Geri Al" butonu gösterilir;
/// basılınca [onChanged] `null` ile çağrılır ve puan tamamen kaldırılır.
///
/// [enabled] `false` ise (ör. henüz izlendi olarak işaretlenmemiş içerik)
/// yıldızlar soluk gösterilir ve [disabledHint] varsa altında uyarı
/// metni olarak gösterilir; dokunma yine [onChanged] üzerinden iletilir
/// ki çağıran taraf uygun bir uyarı (SnackBar vb.) gösterebilsin.
class RatingInput extends StatelessWidget {
  const RatingInput({
    required this.rating,
    required this.onChanged,
    this.enabled = true,
    this.disabledHint,
    super.key,
  });

  final double? rating;
  final ValueChanged<double?> onChanged;
  final bool enabled;
  final String? disabledHint;

  @override
  Widget build(BuildContext context) {
    final filledStars = rating == null ? 0 : rating!.round();
    final starColor = enabled ? Colors.amber : Theme.of(context).disabledColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(5, (index) {
              final starValue = index + 1;
              final isFilled = starValue <= filledStars;
              return IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                  color: starColor,
                ),
                onPressed: () => onChanged(starValue.toDouble()),
              );
            }),
            if (rating != null) ...[
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => onChanged(null),
                icon: const Icon(Icons.close_rounded, size: 16),
                label: Text(context.l10n.t('rating_input_remove_rating')),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          rating == null
              ? context.l10n.t('rating_input_not_rated_yet')
              : context.l10n.tp('rating_input_stars_out_of_5', {
                  'count': '$filledStars',
                }),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (!enabled && disabledHint != null) ...[
          const SizedBox(height: 4),
          Text(
            disabledHint!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).disabledColor),
          ),
        ],
      ],
    );
  }
}