import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/widgets/language_picker_button.dart';
import 'controllers/auth_controller.dart';
import 'utils/auth_error_translator.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authControllerProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!success && mounted) {
      final error = ref.read(authControllerProvider).error;
      _showError(
        context.l10n.t(
          AuthErrorTranslator.messageKey(error ?? Exception('unknown')),
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [LanguagePickerButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'WatchChronos',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.t('login_subtitle'),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.t('common_password'),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return context.l10n.t('login_password_too_short');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.l10n.t('login_submit')),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => context.push(AppRoutes.forgotPassword),
                  child: Text(context.l10n.t('login_forgot_password')),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed:
                      isLoading ? null : () => context.push(AppRoutes.register),
                  child: Text(context.l10n.t('login_no_account')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}