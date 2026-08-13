import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Kullanıcının kurulum ekranında girdiği TMDB/Supabase bilgilerini
/// cihazda güvenli şekilde (Keychain/Keystore) saklar ve uygulama
/// genelinde erişime açar. Hardcoded anahtar kullanılmaz.
class EnvConfig {
  EnvConfig._();

  static const _storage = FlutterSecureStorage();

  static const _keySupabaseUrl = 'SUPABASE_URL';
  static const _keySupabaseAnonKey = 'SUPABASE_ANON_KEY';
  static const _keyTmdbApiKey = 'TMDB_API_KEY';

  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/';

  static String? _supabaseUrl;
  static String? _supabaseAnonKey;
  static String? _tmdbApiKey;

  /// Gerekli üç değer de kayıtlı mı kontrol eder (kurulum ekranı kararı için).
  static Future<bool> isConfigured() async {
    final values = await Future.wait([
      _storage.read(key: _keySupabaseUrl),
      _storage.read(key: _keySupabaseAnonKey),
      _storage.read(key: _keyTmdbApiKey),
    ]);
    return values.every((v) => v != null && v.isNotEmpty);
  }

  /// Kayıtlı değerleri güvenli depodan belleğe yükler.
  static Future<void> load() async {
    _supabaseUrl = await _storage.read(key: _keySupabaseUrl);
    _supabaseAnonKey = await _storage.read(key: _keySupabaseAnonKey);
    _tmdbApiKey = await _storage.read(key: _keyTmdbApiKey);
  }

  /// Kurulum veya ayarlar ekranından gelen değerleri güvenli şekilde kaydeder.
  static Future<void> save({
    required String supabaseUrl,
    required String supabaseAnonKey,
    required String tmdbApiKey,
  }) async {
    await _storage.write(key: _keySupabaseUrl, value: supabaseUrl.trim());
    await _storage.write(
      key: _keySupabaseAnonKey,
      value: supabaseAnonKey.trim(),
    );
    await _storage.write(key: _keyTmdbApiKey, value: tmdbApiKey.trim());
    _supabaseUrl = supabaseUrl.trim();
    _supabaseAnonKey = supabaseAnonKey.trim();
    _tmdbApiKey = tmdbApiKey.trim();
  }

  static String get supabaseUrl => _require(_supabaseUrl, _keySupabaseUrl);

  static String get supabaseAnonKey =>
      _require(_supabaseAnonKey, _keySupabaseAnonKey);

  static String get tmdbApiKey => _require(_tmdbApiKey, _keyTmdbApiKey);

  static String _require(String? value, String key) {
    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing required configuration value: $key. '
        'Run setup screen first.',
      );
    }
    return value;
  }
}
