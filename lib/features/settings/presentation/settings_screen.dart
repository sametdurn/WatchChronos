import 'dart:io' show File;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_controller.dart';
import '../../auth/presentation/utils/sign_out_confirmation.dart';
import '../../setup/presentation/qr_credentials_screen.dart';
import '../data/export_service.dart';

/// Profil sekmesindeki çark ikonundan açılan basit ayarlar sayfası.
/// Hesap işlemlerinin (çıkış yap) yanı sıra TV Time'dan veri aktarımı,
/// kendi verilerini dışa aktarma ve uygulama dilini değiştirme gibi
/// tercihler burada yer alır.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isExporting = false;

  Future<void> _exportData() async {
    if (_isExporting) return;
    final dialogTitle = context.l10n.t('settings_export_dialog_title');
    setState(() => _isExporting = true);

    try {
      final service = ref.read(watchChronosExportServiceProvider);
      final bytes = await service.exportToJsonBytes();
      final fileName = service.suggestedFileName();

      final savedPath = await FilePicker.saveFile(
        dialogTitle: dialogTitle,
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: bytes,
      );

      if (!mounted) return;
      if (savedPath == null) {
        // Kullanıcı kayıt diyaloğunu iptal etti; sessizce geç.
        return;
      }

      // ÖNEMLİ: file_picker'ın `bytes` parametresi SADECE Android/iOS/Web'de
      // dosyayı otomatik yazar. Masaüstünde (Windows/Linux/macOS) saveFile
      // sadece bir kayıt konumu/isim diyaloğu açıp seçilen yolu döner; asıl
      // yazma işini YAPMAZ (bilinen bir plugin davranışı). Bunu yapmazsak
      // kullanıcıya "başarıyla dışa aktarıldı" denir ama disk üzerinde
      // dosya hiç oluşmaz. Bu yüzden web dışında yolu kendimiz yazıyoruz;
      // Android/iOS'ta zaten aynı içerik olduğundan zararsız bir tekrar
      // yazma olur.
      if (!kIsWeb) {
        await File(savedPath).writeAsBytes(bytes, flush: true);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('settings_export_success'))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.tp('settings_export_error', {'error': '$e'}),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _pickLanguage() async {
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
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.t('settings_title'))),
      body: ListView(
        children: [
          _SectionHeader(context.l10n.t('settings_section_general')),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(context.l10n.t('settings_language')),
            subtitle: Text(currentLocale.nativeName),
            onTap: _pickLanguage,
          ),
          _SectionHeader(context.l10n.t('settings_section_data')),
          ListTile(
            leading: const Icon(Icons.upload_file_rounded),
            title: Text(context.l10n.t('settings_tv_time_import_title')),
            subtitle: Text(context.l10n.t('settings_tv_time_import_subtitle')),
            onTap: () => context.push(AppRoutes.tvTimeImport),
          ),
          ListTile(
            leading: _isExporting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_rounded),
            title: Text(context.l10n.t('settings_export_title')),
            subtitle: Text(context.l10n.t('settings_export_subtitle')),
            onTap: _isExporting ? null : _exportData,
          ),
          ListTile(
            leading: const Icon(Icons.settings_backup_restore_rounded),
            title: Text(context.l10n.t('settings_import_title')),
            subtitle: Text(context.l10n.t('settings_import_subtitle')),
            onTap: () => context.push(AppRoutes.watchChronosImport),
          ),
          _SectionHeader(context.l10n.t('settings_section_connection')),
          ListTile(
            leading: const Icon(Icons.vpn_key_rounded),
            title: Text(context.l10n.t('settings_connection_title')),
            subtitle: Text(context.l10n.t('settings_connection_subtitle')),
            onTap: () => context.push(AppRoutes.connectionSettings),
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_rounded),
            title: Text(context.l10n.t('settings_qr_show_title')),
            subtitle: Text(context.l10n.t('settings_qr_show_subtitle')),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const QrCredentialsScreen()),
            ),
          ),
          _SectionHeader(context.l10n.t('settings_section_account')),
          ListTile(
            leading: const Icon(Icons.lock_reset_rounded),
            title: Text(context.l10n.t('change_password_title')),
            onTap: () => context.push(AppRoutes.changePassword),
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email_rounded),
            title: Text(context.l10n.t('change_email_title')),
            subtitle: Text(context.l10n.t('settings_change_email_subtitle')),
            onTap: () => context.push(AppRoutes.changeEmail),
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: Text(context.l10n.t('settings_sign_out')),
            onTap: () => confirmSignOut(context, ref),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
