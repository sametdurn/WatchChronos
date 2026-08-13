import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import 'controllers/auth_controller.dart';
import 'utils/auth_error_translator.dart';

/// Giriş ekranındaki "Şifremi unuttum" bağlantısından açılan, 3 adımlı
/// şifre sıfırlama ekranı.
///
/// Neden bağlantı yerine kod (OTP)? WatchChronos mobil, masaüstü (Windows/
/// Linux/macOS) ve web'de çalışıyor; e-postadaki linke tıklayınca uygulamayı
/// geri açacak bir deep link/URL şeması hiçbir platformda kurulu değil.
/// Supabase'in şifre sıfırlama e-postasında linkle birlikte 6 haneli bir
/// kod ({{ .Token }}) da bulunur — kullanıcı bu kodu doğrudan uygulamaya
/// yapıştırarak platform farkı olmadan aynı akışı tamamlayabilir. (Kodun
/// e-postada görünmesi için Supabase Dashboard > Authentication > Emails >
/// Reset Password şablonunda `{{ .Token }}` değişkeninin de yer aldığından
/// emin ol.)
///
/// Adım 1: e-posta gir, kod gönder.
/// Adım 2: kodu ve yeni şifreyi gir.
/// Adım 3: başarı ekranı, girişe dön.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

enum _Step { requestCode, resetPassword, done }

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _requestFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _Step _step = _Step.requestCode;
  bool _saving = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _requestCode() async {
    if (!(_requestFormKey.currentState?.validate() ?? false)) return;

    setState(() {
      _saving = true;
      _errorText = null;
    });

    await ref
        .read(authControllerProvider.notifier)
        .sendPasswordResetOtp(email: _emailController.text.trim());

    if (!mounted) return;

    // Hesap var/yok bilgisini sızdırmamak için bu adım her zaman
    // başarılıymış gibi bir sonraki adıma geçer; Supabase bu çağrıda
    // hata döndürmez.
    setState(() {
      _saving = false;
      _step = _Step.resetPassword;
    });
  }

  Future<void> _resetPassword() async {
    if (!(_resetFormKey.currentState?.validate() ?? false)) return;

    setState(() {
      _saving = true;
      _errorText = null;
    });

    final success = await ref
        .read(authControllerProvider.notifier)
        .confirmPasswordReset(
          email: _emailController.text.trim(),
          otp: _otpController.text.trim(),
          newPassword: _newPasswordController.text,
        );

    if (!mounted) return;

    if (success) {
      setState(() {
        _saving = false;
        _step = _Step.done;
      });
      return;
    }

    final error = ref.read(authControllerProvider).error;
    setState(() {
      _saving = false;
      _errorText = AuthErrorTranslator.messageKey(error ?? Exception('unknown'));
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
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.t('forgot_password_title'))),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: switch (_step) {
                _Step.requestCode => _buildRequestCodeStep(context),
                _Step.resetPassword => _buildResetPasswordStep(context),
                _Step.done => _buildDoneStep(context),
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCodeStep(BuildContext context) {
    return Form(
      key: _requestFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.t('forgot_password_request_body'),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: context.l10n.t('common_email'),
            ),
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return context.l10n.t('login_email_invalid');
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _requestCode,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.l10n.t('forgot_password_send_code')),
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordStep(BuildContext context) {
    return Form(
      key: _resetFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.tp('forgot_password_reset_body', {
              'email': _emailController.text.trim(),
            }),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: context.l10n.t('forgot_password_otp_label'),
              hintText: '123456',
            ),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _newPasswordController,
            obscureText: _obscureNew,
            decoration: InputDecoration(
              labelText: context.l10n.t('forgot_password_new_password_label'),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return context.l10n.t('login_password_too_short');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              labelText: context.l10n.t(
                'forgot_password_confirm_password_label',
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (value) {
              if (value != _newPasswordController.text) {
                return context.l10n.t('register_passwords_mismatch');
              }
              return null;
            },
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 16),
            Text(
              context.l10n.t(_errorText!),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _resetPassword,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.l10n.t('forgot_password_reset_submit')),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _saving
                ? null
                : () => setState(() {
                    _step = _Step.requestCode;
                    _errorText = null;
                  }),
            child: Text(context.l10n.t('forgot_password_change_email')),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.check_circle_rounded,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.t('forgot_password_done_headline'),
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.t('forgot_password_done_body'),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.t('forgot_password_back_to_login')),
        ),
      ],
    );
  }
}
