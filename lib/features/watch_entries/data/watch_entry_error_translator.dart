import 'package:supabase_flutter/supabase_flutter.dart';

class WatchEntryException implements Exception {
  WatchEntryException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'WatchEntryException: $message';
}

class WatchEntryErrorTranslator {
  WatchEntryErrorTranslator._();

  /// Bir çeviri anahtarı döner (bkz. core/localization); çağıran taraf
  /// `context.l10n.t(...)` ile gösterir.
  static String messageKey(WatchEntryException error) {
    if (error.message.contains('episode_logs sadece media_type = tv')) {
      return 'watch_entry_error_episode_logs_tv_only';
    }
    switch (error.code) {
      case '23505':
        return 'watch_entry_error_already_exists';
      case '23514':
        return 'watch_entry_error_value_out_of_range';
      default:
        return 'auth_error_unexpected';
    }
  }

  static WatchEntryException fromPostgrestException(PostgrestException error) {
    return WatchEntryException(error.message, code: error.code);
  }
}