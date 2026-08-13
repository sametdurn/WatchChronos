import 'package:dio/dio.dart';

/// TMDB istekleri için temel hata tipleri.
///
/// [message] artık ham metin değil, bir çeviri anahtarıdır (bkz.
/// core/localization); UI katmanı `context.l10n.t(message)` ile gösterir.
/// Bilinmeyen bir anahtar `t()` tarafından olduğu gibi döndürüldüğünden,
/// isteğe bağlı özel (anahtar olmayan) mesajlar da güvenle geçirilebilir.
sealed class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiNetworkException extends ApiException {
  const ApiNetworkException([super.message = 'api_error_network']);
}

class ApiTimeoutException extends ApiException {
  const ApiTimeoutException([super.message = 'api_error_timeout']);
}

class ApiNotFoundException extends ApiException {
  const ApiNotFoundException([super.message = 'api_error_not_found']);
}

class ApiServerException extends ApiException {
  const ApiServerException(this.statusCode, [super.message = 'api_error_server']);

  final int? statusCode;
}

class ApiUnknownException extends ApiException {
  const ApiUnknownException([super.message = 'api_error_unknown']);
}

/// Dio hatalarını uygulama içi [ApiException] tiplerine çevirir.
ApiException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.transformTimeout:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const ApiTimeoutException();
    case DioExceptionType.connectionError:
      return const ApiNetworkException();
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      if (statusCode == 404) return const ApiNotFoundException();
      return ApiServerException(statusCode);
    case DioExceptionType.cancel:
      return const ApiUnknownException('api_error_cancelled');
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return const ApiUnknownException();
  }
}