import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/cached_media.dart';
import 'models/cached_season.dart';

class IsarService {
  IsarService._();

  static Isar? _instance;

  static Future<Isar> initialize() async {
    if (_instance != null) return _instance!;

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [CachedMediaSchema, CachedSeasonSchema],
      directory: dir.path,
    );
    return _instance!;
  }

  static Isar get instance {
    if (_instance == null) {
      throw StateError('IsarService.initialize() henüz çağrılmadı.');
    }
    return _instance!;
  }
}

final isarProvider = Provider<Isar>((ref) => IsarService.instance);