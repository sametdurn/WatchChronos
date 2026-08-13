import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/discover/presentation/discover_screen.dart';
import '../../features/discover/presentation/trending_grid_screen.dart';
import '../../features/episodes/presentation/episode_tracking_screen.dart';
import '../../features/home/presentation/home_shell_screen.dart';
import '../../features/library/presentation/completed_grid_screen.dart';
import '../../features/library/presentation/favorites_grid_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/media_detail/presentation/media_detail_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/change_email_screen.dart';
import '../../features/settings/presentation/change_password_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/tv_time_import_screen.dart';
import '../../features/settings/presentation/watchchronos_import_screen.dart';
import '../../features/setup/presentation/setup_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/watch_entries/data/models/media_type.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges),
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final location = state.matchedLocation;

      final isSplash = location == AppRoutes.splash;
      final isLoginOrRegister =
          location == AppRoutes.login || location == AppRoutes.register;
      final isForgotPassword = location == AppRoutes.forgotPassword;

      if (isSplash) return null;
      if (!isLoggedIn && !isLoginOrRegister && !isForgotPassword) {
        return AppRoutes.login;
      }
      // "Şifremi unuttum" akışı, kodu doğrularken kullanıcıyı kısa süreliğine
      // geçici bir kurtarma oturumuyla (isLoggedIn = true) oturum açmış hale
      // getirir. Bu ekranı normal "girişliyken login/register'a girme"
      // kuralının dışında tutuyoruz; aksi halde akış tam ortasında Ana
      // Sayfa'ya fırlatılır. Ekran, yeni şifre kaydedilince kendi içinde
      // oturumu kapatıp kullanıcıyı bilinçli olarak girişe döndürüyor.
      if (isLoggedIn && isLoginOrRegister) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.library,
                name: 'library',
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.discover,
                name: 'discover',
                builder: (context, state) => const DiscoverScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.tvTimeImport,
        name: 'tvTimeImport',
        builder: (context, state) => const TvTimeImportScreen(),
      ),
      GoRoute(
        path: AppRoutes.watchChronosImport,
        name: 'watchChronosImport',
        builder: (context, state) => const WatchChronosImportScreen(),
      ),
      GoRoute(
        path: AppRoutes.connectionSettings,
        name: 'connectionSettings',
        builder: (context, state) =>
            const CredentialsFormScreen(isInitialSetup: false),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        name: 'changePassword',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.changeEmail,
        name: 'changeEmail',
        builder: (context, state) => const ChangeEmailScreen(),
      ),
      GoRoute(
        path: '/home/discover/trending/:mediaType',
        name: 'trendingGrid',
        builder: (context, state) {
          final mediaType = MediaType.values.byName(
            state.pathParameters['mediaType']!,
          );
          return TrendingGridScreen(mediaType: mediaType);
        },
      ),
      GoRoute(
        path: '/home/library/completed/:mediaType',
        name: 'completedGrid',
        builder: (context, state) {
          final mediaType = MediaType.values.byName(
            state.pathParameters['mediaType']!,
          );
          return CompletedGridScreen(mediaType: mediaType);
        },
      ),
      GoRoute(
        path: '/home/library/favorites/:mediaType',
        name: 'favoritesGrid',
        builder: (context, state) {
          final mediaType = MediaType.values.byName(
            state.pathParameters['mediaType']!,
          );
          return FavoritesGridScreen(mediaType: mediaType);
        },
      ),
      GoRoute(
        path: '/media/:mediaType/:tmdbId',
        name: 'mediaDetail',
        builder: (context, state) {
          final mediaType = MediaType.values.byName(
            state.pathParameters['mediaType']!,
          );
          final tmdbId = int.parse(state.pathParameters['tmdbId']!);
          return MediaDetailScreen(mediaType: mediaType, tmdbId: tmdbId);
        },
        routes: [
          GoRoute(
            path: 'episodes',
            name: 'episodeTracking',
            builder: (context, state) {
              final mediaType = MediaType.values.byName(
                state.pathParameters['mediaType']!,
              );
              final tmdbId = int.parse(state.pathParameters['tmdbId']!);
              return EpisodeTrackingScreen(
                mediaType: mediaType,
                tmdbId: tmdbId,
              );
            },
          ),
        ],
      ),
    ],
  );
});