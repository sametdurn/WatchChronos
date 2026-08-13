import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env_config.dart';
import '../localization/app_locale_storage.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.tmdbBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Authorization': 'Bearer ${EnvConfig.tmdbApiKey}',
          'Accept': 'application/json',
        },
      ),
    );

    // TMDB'ye gönderilen `language` parametresi, isteğin atıldığı ANDAKİ
    // uygulama diline göre belirlenir (`AppLocaleStorage.current` senkron
    // ve her zaman güncel). Bunu `BaseOptions` içine SABİT olarak koymak
    // yerine bir interceptor'a almamızın sebebi: `Dio` örneği uygulama
    // açılışında BİR KEZ oluşturuluyor; kullanıcı ayarlardan dili
    // değiştirdiğinde `Dio`'yu yeniden oluşturmadan da her yeni isteğin
    // doğru dille gitmesi gerekiyor.
    // `putIfAbsent` kullanılıyor ki bir çağrı `language` parametresini
    // kendisi (örn. fragman için orijinal dile düşüş yaparken) elle
    // verdiğinde interceptor bunun üzerine yazmasın.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters.putIfAbsent(
            'language',
            () => AppLocaleStorage.current.tmdbLanguageCode,
          );
          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false),
      );
    }

    return dio;
  }
}

final tmdbDioProvider = Provider<Dio>((ref) => DioClient.create());