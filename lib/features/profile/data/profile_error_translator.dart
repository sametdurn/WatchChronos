import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileException implements Exception {
  ProfileException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'ProfileException: $message';
}

class ProfileErrorTranslator {
  ProfileErrorTranslator._();

  /// Bir çeviri anahtarı döner (bkz. core/localization); çağıran taraf
  /// `context.l10n.t(...)` ile gösterir.
  static String messageKey(ProfileException error) {
    switch (error.code) {
      case '23505':
        return 'auth_error_username_taken';
      default:
        return 'auth_error_unexpected';
    }
  }

  static ProfileException fromPostgrestException(PostgrestException error) {
    return ProfileException(error.message, code: error.code);
  }
}