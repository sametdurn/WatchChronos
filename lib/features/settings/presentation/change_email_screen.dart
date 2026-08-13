import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/localization/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../auth/presentation/utils/auth_error_translator.dart';

/// Ayarlar > Hesap altından açılan e-posta değiştirme ekranı.
///
/// Akış: kullanıcı mevcut şifresiyle yeniden doğrulanır ve e-posta
/// değişikliği talep edilir. Supabase projesinde Authentication > Settings
/// altındaki "Secure email change" AÇIK olduğu için değişikliğin geçerli
/// olması için hem ESKİ hem YENİ adresin kendi gelen kutusundaki onay
/// bağlantısına tıklaması gerekir; ikisinden biri eksik kalırsa e-posta
/// değişmez ve hesap eski adresle kullanılmaya devam eder.
class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newEmailController = TextEditingController();

  bool _obscurePassword = true;
  bool _saving = false;
  bool _requestSent = false;
  String? _errorText;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final currentEmail = ref.read(authRepositoryProvider).currentUser?.email;
    final newEmail = _newEmailController.text.trim();
    if (currentEmail != null &&
        newEmail.toLowerCase() == currentEmail.toLowerCase()) {
      setState(
        () => _errorText = 'change_email_same_as_current',
      );
      return;
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });

    final success = await ref
        .read(authControllerProvider.notifier)
        .updateEmail(
          currentPassword: _currentPasswordController.text,
          newEmail: newEmail,
        );

    if (!mounted) return;

    if (success) {
      setState(() {
        _saving = false;
        _requestSent = true;
      });
      return;
    }

    final error = ref.read(authControllerProvider).error;
    setState(() {
      _saving = false;
      _errorText = _messageKeyFor(error);
    });
  }

  String _messageKeyFor(Object? error) {
    if (error is AuthException && error.message == 'Invalid login credentials') {
      return 'change_password_current_wrong';
    }
    return AuthErrorTranslator.messageKey(error ?? Exception('unknown'));
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.t('setup_field_required');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = ref.watch(authRepositoryProvider).currentUser?.email;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.t('change_email_title'))),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _requestSent
                  ? _buildSentState(context)
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (currentEmail != null) ...[
                            Text(
                              context.l10n.tp('change_email_current_email', {
                                'email': currentEmail,
                              }),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                          ],
                          Text(
                            context.l10n.t('change_email_body'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _currentPasswordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: context.l10n.t(
                                'change_password_current_label',
                              ),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                            validator: _requiredValidator,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _newEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: context.l10n.t(
                                'change_email_new_label',
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return context.l10n.t('login_email_invalid');
                              }
                              return null;
                            },
                          ),
                          if (_errorText != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              context.l10n.t(_errorText!),
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
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    context.l10n.t('change_email_send_link'),
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

  Widget _buildSentState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.mark_email_read_rounded,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.t('change_email_sent_headline'),
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.tp('change_email_sent_body', {
            'email': _newEmailController.text.trim(),
          }),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.t('common_ok')),
        ),
      ],
    );
  }
}
