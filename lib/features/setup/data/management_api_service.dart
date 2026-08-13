import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    final migrationAssetPaths = await _listMigrationAssetPaths();
    if (migrationAssetPaths.isEmpty) {
      // Uygulama paketine migration dosyaları gömülmemiş; bu bir
      // paketleme/derleme hatasıdır, sessizce atlanmamalı.
      throw ManagementApiException('setup_error_no_migrations_found');
    }

    for (final assetPath in migrationAssetPaths) {
      final sql = await rootBundle.loadString(assetPath);
      await _runSql(
        projectRef: projectRef,
        personalAccessToken: personalAccessToken,
        sql: sql,
      );
    }
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
  /// için, derleme sırasında otomatik üretilen `AssetManifest.json`
  /// dosyası okunup içindeki tüm asset yolları arasından bu klasöre ait
  /// olanlar (ve yalnızca `.sql` uzantılılar) süzülüyor.
  static Future<List<String>> _listMigrationAssetPaths() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestJson) as Map<String, dynamic>;

    final paths =
        manifestMap.keys
            .where(
              (key) =>
                  key.startsWith('supabase/migrations/') &&
                  key.endsWith('.sql'),
            )
            .toList()
          ..sort();
    return paths;
  }
}
