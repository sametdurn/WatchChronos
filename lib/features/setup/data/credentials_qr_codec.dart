import 'dart:convert';

/// PC ile mobil arasında (veya herhangi iki cihaz arasında) TMDB/Supabase
/// bağlantı bilgilerini QR kod üzerinden aktarmak için kullanılan basit
/// JSON encode/decode.
///
/// ÖNEMLİ: Burada ŞİFRELEME YAPILMAZ. QR kod, elle daktilo etmeyi önleyen
/// bir kolaylıktır; içeriği çözüldüğünde anahtarlar düz metin olarak
/// görünür. Bu yüzden QR ekranı yalnızca güvenilen cihaz/kişilerle
/// paylaşılmalı, ekran görüntüsü olarak saklanmamalıdır.
class CredentialsQrCodec {
  const CredentialsQrCodec._();

  static const _keySupabaseUrl = 'supabaseUrl';
  static const _keySupabaseAnonKey = 'supabaseAnonKey';
  static const _keyTmdbApiKey = 'tmdbApiKey';

  static String encode({
    required String supabaseUrl,
    required String supabaseAnonKey,
    required String tmdbApiKey,
  }) {
    return jsonEncode({
      _keySupabaseUrl: supabaseUrl,
      _keySupabaseAnonKey: supabaseAnonKey,
      _keyTmdbApiKey: tmdbApiKey,
    });
  }

  /// Geçersiz/eksik veri durumunda `null` döner; çağıran taraf bunu
  /// "tanınmayan QR kodu" olarak ele almalı.
  static ({String supabaseUrl, String supabaseAnonKey, String tmdbApiKey})?
  decode(String raw) {
    try {
      final data = jsonDecode(raw);
      if (data is! Map) return null;

      final supabaseUrl = data[_keySupabaseUrl];
      final supabaseAnonKey = data[_keySupabaseAnonKey];
      final tmdbApiKey = data[_keyTmdbApiKey];

      if (supabaseUrl is! String ||
          supabaseAnonKey is! String ||
          tmdbApiKey is! String ||
          supabaseUrl.isEmpty ||
          supabaseAnonKey.isEmpty ||
          tmdbApiKey.isEmpty) {
        return null;
      }

      return (
        supabaseUrl: supabaseUrl,
        supabaseAnonKey: supabaseAnonKey,
        tmdbApiKey: tmdbApiKey,
      );
    } catch (_) {
      return null;
    }
  }
}
