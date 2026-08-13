import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env_config.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/localization/widgets/language_picker_button.dart';
import '../../../core/services/app_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../data/credentials_validator.dart';
import '../data/management_api_service.dart';
import 'qr_scan_screen.dart';

/// İlk kurulum sırasında gösterilen, kendi başına ayakta duran uygulama
/// kabuğu. Gerekli bilgiler kayıtlı olmadığında main() bunu çalıştırır.
class SetupApp extends ConsumerWidget {
  const SetupApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp(
      title: AppLocalizations(locale.toLocale).t('setup_app_title'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: locale.toLocale,
      supportedLocales: AppLocale.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const CredentialsFormScreen(isInitialSetup: true),
    );
  }
}

/// İlk kurulumda kullanıcıya sorulan soru: bu cihaz Supabase projesini
/// SIFIRDAN mı kuruyor (ve bu yüzden veritabanı tablolarının da
/// oluşturulması gerekiyor), yoksa proje daha önce başka bir cihazda
/// kurulup tablolar zaten oluşturulmuş da bu cihaz ona mı bağlanıyor?
///
/// Bu ayrım, Supabase Management API'sinin (migration'ları otomatik
/// uygulamak için gereken) çok yetkili "Personal Access Token"ının SADECE
/// gerçekten gerekliyken istenmesini sağlıyor — ikinci cihazda/kullanıcıda
/// bu token'a hiç ihtiyaç yok.
enum SetupMode {
  /// Supabase projesi yeni; migration'lar Management API ile bu cihazdan
  /// uygulanacak.
  firstTime,

  /// Proje ve tabloları başka bir cihazda zaten kurulmuş; bu cihaz sadece
  /// mevcut bağlantı bilgileriyle (URL + anon key) bağlanıyor.
  existingDevice,
}

/// TMDB ve Supabase bilgilerini toplayan form. İlk kurulumda ve ayarlardan
/// güncelleme yapılırken aynı ekran kullanılır.
class CredentialsFormScreen extends StatefulWidget {
  const CredentialsFormScreen({super.key, required this.isInitialSetup});

  final bool isInitialSetup;

  @override
  State<CredentialsFormScreen> createState() => _CredentialsFormScreenState();
}

class _CredentialsFormScreenState extends State<CredentialsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabaseUrlController = TextEditingController();
  final _supabaseAnonKeyController = TextEditingController();
  final _tmdbApiKeyController = TextEditingController();
  final _accessTokenController = TextEditingController();
  bool _saving = false;
  bool _isMigrating = false;
  bool _obscureAnonKey = true;
  bool _obscureTmdbKey = true;
  bool _obscureAccessToken = true;
  String? _errorTextKey;

  /// İlk kurulumda seçilen mod; kullanıcı henüz seçim yapmadıysa `null`
  /// (bu durumda form yerine seçim ekranı gösterilir). Ayarlar ekranından
  /// mevcut bağlantıyı güncellerken (`isInitialSetup == false`) bu seçim
  /// ekranı hiç gösterilmez, dolayısıyla bu alan da kullanılmaz.
  SetupMode? _setupMode;

  @override
  void initState() {
    super.initState();
    if (!widget.isInitialSetup) {
      // Ayarlar ekranında mevcut değerleri önceden doldur.
      _supabaseUrlController.text = EnvConfig.supabaseUrl;
      _supabaseAnonKeyController.text = EnvConfig.supabaseAnonKey;
      _tmdbApiKeyController.text = EnvConfig.tmdbApiKey;
    }
  }

  @override
  void dispose() {
    _supabaseUrlController.dispose();
    _supabaseAnonKeyController.dispose();
    _tmdbApiKeyController.dispose();
    _accessTokenController.dispose();
    super.dispose();
  }

  bool get _runMigrations =>
      widget.isInitialSetup && _setupMode == SetupMode.firstTime;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final supabaseUrl = _supabaseUrlController.text.trim();
    final supabaseAnonKey = _supabaseAnonKeyController.text.trim();
    final tmdbApiKey = _tmdbApiKeyController.text.trim();
    final accessToken = _accessTokenController.text.trim();
    final shouldRunMigrations = _runMigrations;

    setState(() {
      _saving = true;
      _errorTextKey = null;
    });

    try {
      await CredentialsValidator.validateTmdbApiKey(tmdbApiKey);
      await CredentialsValidator.validateSupabase(
        supabaseUrl,
        supabaseAnonKey,
      );

      if (shouldRunMigrations) {
        final projectRef = ManagementApiService.projectRefFromUrl(
          supabaseUrl,
        );
        if (projectRef == null) {
          throw ManagementApiException('setup_error_invalid_project_ref');
        }

        if (!mounted) return;
        setState(() => _isMigrating = true);
        debugPrint('[Setup] runMigrations çağrılıyor...');

        // ÖNEMLİ: `accessToken` sadece bu çağrı boyunca bellekte tutulur.
        // `ManagementApiService` onu HİÇBİR YERE kaydetmez; işlem bitince
        // (başarılı ya da başarısız) bu fonksiyonun scope'undan çıkar ve
        // atılır. Kalıcı olarak sadece aşağıdaki `EnvConfig.save` ile
        // normal Supabase URL + anon key saklanır.
        await ManagementApiService.runMigrations(
          projectRef: projectRef,
          personalAccessToken: accessToken,
        );
        debugPrint('[Setup] runMigrations tamamlandı.');
      }
    } on CredentialsValidationException catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _isMigrating = false;
        _errorTextKey = e.messageKey;
      });
      return;
    } on ManagementApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _isMigrating = false;
        _errorTextKey = e.messageKey;
      });
      return;
    } catch (e) {
      // Güvenlik ağı: yukarıdaki iki tip dışında, öngörülmemiş herhangi bir
      // hata (ör. ileride tekrar bir asset/platform API değişikliği) UI'ı
      // sonsuza kadar "hazırlanıyor" durumunda bırakmasın; en azından genel
      // bir hata mesajı gösterip kullanıcıyı serbest bırak.
      debugPrint('[Setup] Beklenmedik hata: $e');
      if (!mounted) return;
      setState(() {
        _saving = false;
        _isMigrating = false;
        _errorTextKey = 'setup_error_migration_failed';
      });
      return;
    }

    await EnvConfig.save(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      tmdbApiKey: tmdbApiKey,
    );

    if (!mounted) return;

    if (widget.isInitialSetup) {
      await launchMainApp();
      return;
    }

    setState(() {
      _saving = false;
      _isMigrating = false;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.t('setup_connection_updated'))),
    );
    Navigator.of(context).pop();
  }

  /// Başka bir cihazda "QR Kodu Göster" ile üretilen bağlantı QR kodunu
  /// okutup üç alanı da otomatik doldurur (kaydetmez; kullanıcı yine de
  /// "Kaydet"/"Başla" ile onaylamalıdır).
  Future<void> _scanQr() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute<
        ({String supabaseUrl, String supabaseAnonKey, String tmdbApiKey})
      >(builder: (_) => const QrScanScreen()),
    );
    if (result == null || !mounted) return;

    setState(() {
      _supabaseUrlController.text = result.supabaseUrl;
      _supabaseAnonKeyController.text = result.supabaseAnonKey;
      _tmdbApiKeyController.text = result.tmdbApiKey;
    });
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.t('setup_field_required');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // İlk kurulumda kullanıcı henüz "ilk defa" / "başka cihazda kurulmuştu"
    // seçimini yapmadıysa, kimlik bilgisi formu yerine bu seçim ekranı
    // gösterilir. Ayarlar ekranından mevcut bağlantıyı düzenlerken bu
    // ekran hiç devreye girmez.
    if (widget.isInitialSetup && _setupMode == null) {
      return _SetupModeSelectionScreen(
        onModeSelected: (mode) => setState(() => _setupMode = mode),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: widget.isInitialSetup
            ? null
            : Text(context.l10n.t('setup_connection_title')),
        leading: widget.isInitialSetup
            ? IconButton(
                onPressed: () => setState(() => _setupMode = null),
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        automaticallyImplyLeading: !widget.isInitialSetup,
        backgroundColor: widget.isInitialSetup ? Colors.transparent : null,
        elevation: widget.isInitialSetup ? 0 : null,
        actions: const [LanguagePickerButton()],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.isInitialSetup) ...[
                      Icon(
                        Icons.schedule_rounded,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.t('setup_headline'),
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.t('setup_body'),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                    ],
                    OutlinedButton.icon(
                      onPressed: _saving ? null : _scanQr,
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      label: Text(context.l10n.t('qr_scan_button')),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _supabaseUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Supabase URL',
                        hintText: 'https://xxxxx.supabase.co',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _supabaseAnonKeyController,
                      decoration: InputDecoration(
                        labelText: 'Supabase Anon Key',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureAnonKey
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                          ),
                          onPressed: () => setState(
                            () => _obscureAnonKey = !_obscureAnonKey,
                          ),
                        ),
                      ),
                      obscureText: _obscureAnonKey,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tmdbApiKeyController,
                      decoration: InputDecoration(
                        labelText: 'TMDB API Key (v4 Read Access Token)',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTmdbKey
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                          ),
                          onPressed: () => setState(
                            () => _obscureTmdbKey = !_obscureTmdbKey,
                          ),
                        ),
                      ),
                      obscureText: _obscureTmdbKey,
                      validator: _requiredValidator,
                    ),
                    if (_runMigrations) ...[
                      const SizedBox(height: 32),
                      Text(
                        context.l10n.t(
                          'setup_management_api_section_title',
                        ),
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.t('setup_management_api_section_body'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _accessTokenController,
                        decoration: InputDecoration(
                          labelText: 'Supabase Personal Access Token',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureAccessToken
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                            onPressed: () => setState(
                              () =>
                                  _obscureAccessToken = !_obscureAccessToken,
                            ),
                          ),
                        ),
                        obscureText: _obscureAccessToken,
                        validator: _requiredValidator,
                      ),
                    ],
                    if (_errorTextKey != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.t(_errorTextKey!),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _saving ? null : _submit,
                      child: _saving
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                if (_isMigrating) ...[
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      context.l10n.t(
                                        'setup_running_migrations',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : Text(
                              widget.isInitialSetup
                                  ? context.l10n.t('setup_start')
                                  : context.l10n.t('common_save'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// İlk kurulumda gösterilen "İlk defa mı kuruyorsun, yoksa proje başka
/// bir cihazda zaten kurulu muydu?" seçim ekranı.
class _SetupModeSelectionScreen extends StatelessWidget {
  const _SetupModeSelectionScreen({required this.onModeSelected});

  final ValueChanged<SetupMode> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [LanguagePickerButton()],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.t('setup_mode_headline'),
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.t('setup_mode_body'),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _SetupModeCard(
                    icon: Icons.rocket_launch_rounded,
                    title: context.l10n.t('setup_mode_first_time_title'),
                    subtitle: context.l10n.t(
                      'setup_mode_first_time_subtitle',
                    ),
                    onTap: () => onModeSelected(SetupMode.firstTime),
                  ),
                  const SizedBox(height: 16),
                  _SetupModeCard(
                    icon: Icons.phonelink_rounded,
                    title: context.l10n.t('setup_mode_existing_title'),
                    subtitle: context.l10n.t('setup_mode_existing_subtitle'),
                    onTap: () => onModeSelected(SetupMode.existingDevice),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SetupModeCard extends StatelessWidget {
  const _SetupModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
