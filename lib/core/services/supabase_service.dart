import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env_config.dart';

class SupabaseService {
  SupabaseService._();

  static Future<void> initialize() {
    return Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      publishableKey: EnvConfig.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseService.client;
});