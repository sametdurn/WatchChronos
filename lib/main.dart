import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'core/cache/isar_service.dart';
import 'core/config/env_config.dart';
import 'core/localization/app_locale_storage.dart';
import 'core/services/app_launcher.dart';
import 'features/setup/presentation/setup_screen.dart';

/// Masaüstü (Windows/Linux/macOS) mü çalışıyoruz; window_manager sadece
/// bu platformlarda kullanılabiliyor.
bool get _isDesktopPlatform =>
    !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

/// Uygulama penceresini ekranın ortasında, içeriğin rahat sığacağı bir
/// başlangıç boyutuyla açar. Windows runner'ın varsayılanı (1280x720,
/// sol üst köşeye yakın) yerine bunu kullanıyoruz.
Future<void> _setupDesktopWindow() async {
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(900, 600),
    center: true,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (_isDesktopPlatform) {
    await _setupDesktopWindow();
  }
  await IsarService.initialize();
  await AppLocaleStorage.load();

  if (await EnvConfig.isConfigured()) {
    await launchMainApp();
  } else {
    runApp(const ProviderScope(child: SetupApp()));
  }
}
