import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app.dart';
import '../config/env_config.dart';
import 'supabase_service.dart';

/// Kurulum ekranı tamamlandığında ya da main() içinde bilgiler zaten
/// kayıtlıysa çağrılır: değerleri yükler, Supabase'i başlatır ve
/// uygulama ağacını asıl uygulamayla değiştirir.
Future<void> launchMainApp() async {
  await EnvConfig.load();
  await SupabaseService.initialize();
  runApp(const ProviderScope(child: WatchChronosApp()));
}
