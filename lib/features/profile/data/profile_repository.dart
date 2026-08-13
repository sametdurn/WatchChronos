import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import 'models/profile.dart';
import 'profile_error_translator.dart';

/// Avatar/kapak fotoğrafları için kullanılan public storage bucket (bkz.
/// supabase/migrations/20260713120000_profile_cover_and_images.sql).
const _profileImagesBucket = 'profile-images';

class ProfileRepository {
  ProfileRepository(this._client);

  final SupabaseClient _client;

  String _requireUserId() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('ProfileRepository: kullanıcı giriş yapmamış.');
    }
    return userId;
  }

  Future<Profile> getProfile() async {
    final userId = _requireUserId();
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return Profile.fromJson(response);
    } on PostgrestException catch (e) {
      throw ProfileErrorTranslator.fromPostgrestException(e);
    }
  }

  /// Profil sayfasında kullanıcı adı/avatar/kapak değişince ekranın anlık
  /// güncellenmesi için realtime stream.
  Stream<Profile> profileStream() {
    final userId = _requireUserId();
    return _client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((rows) => Profile.fromJson(rows.first));
  }

  /// Kayıt sırasında seçilen ad sadece görüntü amaçlıdır (giriş e-posta
  /// ile yapılır); burada sonradan değiştirilir.
  Future<void> setUsername(String username) async {
    final userId = _requireUserId();
    try {
      await _client
          .from('profiles')
          .update({'username': username})
          .eq('id', userId);
    } on PostgrestException catch (e) {
      throw ProfileErrorTranslator.fromPostgrestException(e);
    }
  }

  /// [bytes] içeriğini `profile-images` bucket'ında
  /// `{user_id}/avatar.<ext>` veya `{user_id}/cover.<ext>` yoluna yükler
  /// (üzerine yazar) ve public URL'ini döner. RLS politikaları bu
  /// klasöre sadece ilgili kullanıcının yazabilmesini sağlar (bkz.
  /// migration dosyası).
  Future<String> _uploadImage({
    required String fileName,
    required List<int> bytes,
  }) async {
    final userId = _requireUserId();
    final path = '$userId/$fileName';
    await _client.storage
        .from(_profileImagesBucket)
        .uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(upsert: true),
        );
    // Public bucket olduğundan sabit URL değişmez; CachedNetworkImage'ın
    // eski görseli önbellekten göstermemesi için sona bir "cache buster"
    // (zaman damgası) ekleniyor.
    final publicUrl = _client.storage
        .from(_profileImagesBucket)
        .getPublicUrl(path);
    return '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> uploadAvatar({
    required List<int> bytes,
    required String fileExtension,
  }) async {
    final url = await _uploadImage(
      fileName: 'avatar.$fileExtension',
      bytes: bytes,
    );
    final userId = _requireUserId();
    try {
      await _client
          .from('profiles')
          .update({'avatar_url': url})
          .eq('id', userId);
    } on PostgrestException catch (e) {
      throw ProfileErrorTranslator.fromPostgrestException(e);
    }
  }

  Future<void> uploadCover({
    required List<int> bytes,
    required String fileExtension,
  }) async {
    final url = await _uploadImage(
      fileName: 'cover.$fileExtension',
      bytes: bytes,
    );
    final userId = _requireUserId();
    try {
      await _client
          .from('profiles')
          .update({'cover_url': url})
          .eq('id', userId);
    } on PostgrestException catch (e) {
      throw ProfileErrorTranslator.fromPostgrestException(e);
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProfileRepository(client);
});

/// Profil ekranının izlediği tek realtime stream instance'ı. Önceden
/// `profileStream()` doğrudan `build()` içinde çağrılıyordu; bu da her
/// rebuild'de (ör. avatar/kapak yükleme sonrası `setState`) yeni bir
/// Realtime kanalı açılmasına ve eskisinin kapatılmamasına, dolayısıyla
/// "Profil yüklenemedi" hatasına yol açıyordu. `autoDispose` sayesinde
/// ekran dinlediği sürece tek bir kanal açık kalır, ekran kapanınca kanal
/// düzgünce kapatılır.
final profileStreamProvider = StreamProvider.autoDispose<Profile>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.profileStream();
});
