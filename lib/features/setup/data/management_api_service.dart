import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show AssetManifest, rootBundle;

/// [ManagementApiService.runMigrations] sırasında oluşan, kullanıcıya
/// gösterilecek yerelleştirilmiş bir mesaj anahtarı taşıyan hata.
class ManagementApiException implements Exception {
  ManagementApiException(this.messageKey, {this.detail});

  /// `AppLocalizations.t()` ile gösterilecek çeviri anahtarı.
  final String messageKey;

  /// Sunucudan dönen ham hata metni (varsa); kullanıcıya gösterilmez,
  /// yalnızca hata ayıklama/loglama amaçlıdır.
  final String? detail;

  @override
  String toString() => detail == null ? messageKey : '$messageKey: $detail';
}

/// İlk kurulumda "İlk defa kuruyorum" seçilirse, `supabase/migrations/`
/// altına gömülü SQL dosyalarını Supabase'in Management API'si üzerinden
/// kullanıcının KENDİ Supabase projesine uygular — böylece kullanıcı
/// Supabase CLI kurup `supabase db push` çalıştırmak zorunda kalmaz.
///
/// GÜVENLİK NOTU: Bu akış için istenen "Personal Access Token", normal
/// proje `anon key`'inden ÇOK daha güçlüdür: o hesaptaki TÜM Supabase
/// projeleri üzerinde tam yetki verir (silme dahil). Bu sınıf o token'ı
/// HİÇBİR ZAMAN diske/güvenli depoya yazmaz; token yalnızca migration
/// isteklerinin yapıldığı süre boyunca çağıranın elinde (bellekte) tutulur
/// ve iş bitince (başarılı ya da başarısız) referansı bırakılır. Kalıcı
/// olarak yalnızca normal `Supabase URL` + `anon key` saklanır
/// (bkz. `EnvConfig.save`).
class ManagementApiService {
  ManagementApiService._();

  static const _baseUrl = 'https://api.supabase.com/v1/projects';
  static const _urlSuffix = '.supabase.co';

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      // İstek gövdesinin (SQL sorgusunun) sunucuya yüklenmesi sırasında
      // bağlantı yavaşlar/askıda kalırsa `connectTimeout` (yalnızca TCP+TLS
      // el sıkışmasını kapsar) ve `receiveTimeout` (yalnızca gönderim
      // TAMAMLANDIKTAN sonra yanıt beklemeyi kapsar) bunu YAKALAYAMAZ;
      // istek süresiz askıda kalabilir. `sendTimeout` bu boşluğu kapatır.
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {'Content-Type': 'application/json'},
    ),
  );

  /// Kurulum ekranında girilen Supabase URL'sinden proje referansını
  /// (ör. `https://abcdefgh.supabase.co` -> `abcdefgh`) çıkarır.
  ///
  /// Sadece Supabase'in standart bulut alan adını (`*.supabase.co`)
  /// destekler; kendi sunucusunda (self-hosted) barındıranlar için `null`
  /// döner — bu durumda migration'lar Supabase CLI ile elle uygulanmalıdır.
  static String? projectRefFromUrl(String supabaseUrl) {
    final uri = Uri.tryParse(supabaseUrl.trim());
    final host = uri?.host ?? '';
    if (host.isEmpty || !host.endsWith(_urlSuffix)) return null;

    final ref = host.substring(0, host.length - _urlSuffix.length);
    if (ref.isEmpty || ref.contains('.')) return null;
    return ref;
  }

  /// `supabase/migrations/` altındaki tüm `.sql` dosyalarını, dosya
  /// adlarındaki zaman damgasına göre (eskiden yeniye, ne zaman
  /// oluşturulduysa o sırayla) [projectRef] ile belirtilen Supabase
  /// projesine tek tek uygular.
  ///
  /// Migration dosyaları `CREATE TABLE IF NOT EXISTS` gibi idempotent
  /// ifadeler kullandığından, aynı projede tekrar çalıştırılması (ör.
  /// kullanıcı yanlışlıkla "İlk defa kuruyorum"u ikinci kez seçerse) hataya
  /// yol açmaz.
  static Future<void> runMigrations({
    required String projectRef,
    required String personalAccessToken,
  }) async {
    debugPrint('[Migration] Başladı. projectRef=$projectRef');
    final migrationAssetPaths = await _listMigrationAssetPaths();
    debugPrint('[Migration] ${migrationAssetPaths.length} dosya bulundu: $migrationAssetPaths');
    if (migrationAssetPaths.isEmpty) {
      // Uygulama paketine migration dosyaları gömülmemiş; bu bir
      // paketleme/derleme hatasıdır, sessizce atlanmamalı.
      throw ManagementApiException('setup_error_no_migrations_found');
    }

    for (final assetPath in migrationAssetPaths) {
      debugPrint('[Migration] Okunuyor: $assetPath');
      final sql = await rootBundle.loadString(assetPath);
      debugPrint('[Migration] Gönderiliyor: $assetPath (${sql.length} karakter)');
      final stopwatch = Stopwatch()..start();
      // Tek bir isteğin `sendTimeout`/`receiveTimeout` dışında, öngörülmemiş
      // bir sebeple (ör. bağlantı kurulduktan sonra platform seviyesinde
      // askıda kalması) süresiz beklemesine karşı ek bir güvenlik ağı:
      // hiçbir migration isteği 45 saniyeyi geçmesin, aksi halde kurulum
      // ekranı sonsuza kadar "hazırlanıyor" durumunda kalmasın.
      await _runSql(
        projectRef: projectRef,
        personalAccessToken: personalAccessToken,
        sql: sql,
      ).timeout(
        const Duration(seconds: 45),
        onTimeout: () {
          debugPrint('[Migration] ZAMAN AŞIMI (45sn): $assetPath');
          throw ManagementApiException(
            'setup_error_migration_failed',
            detail: 'Request timed out after 45s ($assetPath)',
          );
        },
      );
      debugPrint('[Migration] Tamamlandı: $assetPath (${stopwatch.elapsedMilliseconds}ms)');
    }
    debugPrint('[Migration] Tüm migration'
        'lar tamamlandı.');
  }

  static Future<void> _runSql({
    required String projectRef,
    required String personalAccessToken,
    required String sql,
  }) async {
    try {
      await _dio.post<dynamic>(
        '$_baseUrl/$projectRef/database/query',
        options: Options(
          headers: {'Authorization': 'Bearer $personalAccessToken'},
        ),
        data: jsonEncode({'query': sql}),
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        throw ManagementApiException('setup_error_invalid_access_token');
      }
      if (status == 404) {
        throw ManagementApiException('setup_error_invalid_project_ref');
      }

      final responseData = e.response?.data;
      final serverMessage = responseData is Map
          ? responseData['message']?.toString()
          : e.message;
      throw ManagementApiException(
        'setup_error_migration_failed',
        detail: serverMessage,
      );
    }
  }

  /// `pubspec.yaml`'da `assets: [supabase/migrations/]` olarak tanımlı
  /// klasördeki `.sql` dosyalarının asset yollarını bulur.
  ///
  /// Flutter, asset klasörlerini doğrudan listeleyen bir API sunmadığı
  /// için, güncel `AssetManifest` API'si kullanılarak (bkz.
  /// https://docs.flutter.dev/release/breaking-changes/asset-manifest-dot-json)
  /// derleme sırasında üretilen manifest okunup içindeki tüm asset
  /// yolları arasından bu klasöre ait olanlar (ve yalnızca `.sql`
  /// uzantılılar) süzülüyor. ESKİ `rootBundle.loadString('AssetManifest.json')`
  /// yaklaşımı KULLANILMAMALI: güncel Flutter sürümlerinde bu dosya artık
  /// üretilmiyor (yerine `AssetManifest.bin` var) ve çağrı
  /// "Unable to load asset: AssetManifest.json" hatasıyla başarısız olur.
  static Future<List<String>> _listMigrationAssetPaths() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = assetManifest
        .listAssets()
        .where(
          (key) =>
              key.startsWith('supabase/migrations/') && key.endsWith('.sql'),
        )
        .toList()
          ..sort();
    return paths;
  }
}
