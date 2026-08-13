import 'package:dio/dio.dart';

/// Kurulum formunda girilen değerlerin geçerliliğini doğrulama başarısız
/// olduğunda kullanıcıya gösterilecek okunabilir mesajı taşır.
class CredentialsValidationException implements Exception {
  CredentialsValidationException(this.messageKey);

  /// Bir çeviri anahtarı (bkz. core/localization) — ham metin değil,
  /// böylece arayüz katmanı hatayı kullanıcının seçtiği dilde gösterebilir.
  final String messageKey;

  @override
  String toString() => messageKey;
}

/// Kaydetmeden önce TMDB ve Supabase bilgilerinin gerçekten çalıştığını
/// test eder; böylece geçersiz bir anahtar/URL uygulamaya kaydedilip daha
/// sonra anlaşılmaz bir ağ hatasına yol açmaz.
class CredentialsValidator {
  CredentialsValidator._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );

  static Future<void> validateTmdbApiKey(String tmdbApiKey) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/authentication',
        options: Options(
          headers: {'Authorization': 'Bearer $tmdbApiKey'},
        ),
      );
      if (response.statusCode != 200) {
        throw CredentialsValidationException('setup_error_invalid_tmdb_key');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CredentialsValidationException('setup_error_invalid_tmdb_key');
      }
      throw CredentialsValidationException('setup_error_tmdb_unreachable');
    }
  }

  static Future<void> validateSupabase(
    String supabaseUrl,
    String supabaseAnonKey,
  ) async {
    final uri = Uri.tryParse(supabaseUrl);
    if (uri == null || !uri.isScheme('https') || uri.host.isEmpty) {
      throw CredentialsValidationException('setup_error_invalid_supabase_url');
    }

    try {
      final response = await _dio.get(
        '$supabaseUrl/auth/v1/settings',
        options: Options(headers: {'apikey': supabaseAnonKey}),
      );
      if (response.statusCode != 200) {
        throw CredentialsValidationException('setup_error_invalid_supabase_credentials');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403 || status == 404) {
        throw CredentialsValidationException('setup_error_invalid_supabase_credentials');
      }
      throw CredentialsValidationException('setup_error_supabase_unreachable');
    }
  }
}
