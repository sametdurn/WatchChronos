import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_locale.dart';
import '../app_localizations.dart';
import '../locale_controller.dart';

/// Ayarlar sayfasına henüz erişimin olmadığı ekranlarda (giriş, kurulum)
/// dil değiştirmeyi sağlayan, AppBar action'ı olarak kullanılabilen basit
/// bir simge düğmesi. Ayarlar ekranındaki dil seçiciyle aynı diyaloğu
/// açar.
class LanguagePickerButton extends ConsumerWidget {
  const LanguagePickerButton({super.key});

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final currentLocale = ref.read(localeControllerProvider);
    final selected = await showDialog<AppLocale>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.t('settings_language_dialog_title')),
        content: RadioGroup<AppLocale>(
          groupValue: currentLocale,
          onChanged: (value) => Navigator.pop(dialogContext, value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final locale in AppLocale.values)
                RadioListTile<AppLocale>(
                  title: Text(locale.nativeName),
                  value: locale,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(dialogContext.l10n.t('common_cancel')),
          ),
        ],
      ),
    );

    if (selected != null) {
      await ref.read(localeControllerProvider.notifier).setLocale(selected);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeControllerProvider);
    return IconButton(
      onPressed: () => _pickLanguage(context, ref),
      icon: const Icon(Icons.language_rounded),
      tooltip: currentLocale.nativeName,
    );
  }
}
