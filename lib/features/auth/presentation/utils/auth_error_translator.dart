import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase hatasını bir çeviri anahtarına çevirir. Çağıran taraf sonucu
/// `context.l10n.t(...)` ile geçirmelidir. Bilinmeyen/ham Supabase
/// mesajları (switch'te eşleşmeyenler) doğrudan döner: `AppLocalizations.t`
/// tanımadığı bir anahtar için zaten kendisini olduğu gibi gösterdiğinden,
/// bu ham metinler de olduğu gibi kullanıcıya yansır.
class AuthErrorTranslator {
  AuthErrorTranslator._();

  static String messageKey(Object error) {
    if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'auth_error_invalid_credentials';
        case 'User already registered':
          return 'auth_error_already_registered';
        case 'Email not confirmed':
          return 'auth_error_email_not_confirmed';
        case 'New password should be different from the old password.':
          return 'auth_error_same_password';
        case 'A user with this email address has already been registered':
          return 'auth_error_email_in_use';
        case 'Token has expired or is invalid':
          return 'auth_error_token_expired';
        default:
          // handle_new_user trigger'ı, profiles.username unique kısıtına
          // takılırsa GoTrue bunu genelde "Database error saving new
          // user" gibi genel bir mesajla sarmalar; kullanıcı adı
          // çakışmasına özgü, anlaşılır bir mesaj gösterelim.
          final lower = error.message.toLowerCase();
          if (lower.contains('database error saving new user') ||
              lower.contains('duplicate key') ||
              lower.contains('username')) {
            return 'auth_error_username_taken';
          }
          return error.message;
      }
    }
    return 'auth_error_unexpected';
  }
}