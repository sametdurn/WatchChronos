class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String library = '/home/library';
  static const String discover = '/home/discover';
  static const String profile = '/home/profile';
  static const String home = library;

  static const String settings = '/settings';
  static const String connectionSettings = '/settings/connection';
  static const String tvTimeImport = '/settings/tv-time-import';
  static const String watchChronosImport = '/settings/watchchronos-import';
  static const String changePassword = '/settings/change-password';
  static const String changeEmail = '/settings/change-email';

  static String mediaDetail({required String mediaType, required int tmdbId}) =>
      '/media/$mediaType/$tmdbId';

  static String episodeTracking({
    required String mediaType,
    required int tmdbId,
  }) => '/media/$mediaType/$tmdbId/episodes';

  static String trendingGrid({required String mediaType}) =>
      '/home/discover/trending/$mediaType';

  static String completedGrid({required String mediaType}) =>
      '/home/library/completed/$mediaType';

  static String favoritesGrid({required String mediaType}) =>
      '/home/library/favorites/$mediaType';
}
