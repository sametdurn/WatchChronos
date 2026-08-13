import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../controllers/auth_controller.dart';

/// Hesaptan çıkış yapmadan önce kullanıcıya soran ORTAK onay diyaloğu.
///
/// Ayarlar, Profil ve Kütüphane ekranlarındaki "Çıkış Yap" aksiyonlarının
/// hepsi bunu kullanır. Daha önce her ekran kendi diyaloğunu (farklı
/// başlık/metin/stil ile) ayrı ayrı tanımlıyordu; tek bir yerden
/// yönetilerek üçünün de birebir aynı görünmesi sağlanıyor.
Future<void> confirmSignOut(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(dialogContext.l10n.t('settings_sign_out')),
      content: Text(dialogContext.l10n.t('settings_sign_out_confirm')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(dialogContext.l10n.t('common_cancel')),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(dialogContext.l10n.t('settings_sign_out')),
        ),
      ],
    ),
  );

  if (confirmed ?? false) {
    await ref.read(authControllerProvider.notifier).signOut();
  }
}
