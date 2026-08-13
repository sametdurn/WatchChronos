import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../watch_entries/data/watch_entries_repository.dart';
import '../../data/auth_repository.dart';

class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(
      () => repository.signInWithPassword(email: email, password: password),
    );
    state = result;
    return !result.hasError;
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(
      () => repository.signUpWithPassword(
        email: email,
        password: password,
        username: username,
      ),
    );
    state = result;
    return !result.hasError;
  }

  Future<void> signOut() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.signOut();
    // `libraryEntriesStreamProvider` bilinçli olarak `ref.keepAlive()`
    // kullanıyor (sekmeler arası tek abonelik paylaşılsın diye), bu yüzden
    // ekranlar unmount olsa bile kendiliğinden dispose OLMUYOR. Çıkış
    // yapılınca elle invalidate etmezsek, bir sonraki hesapla girişte
    // hâlâ önceki kullanıcının `user_id` filtresiyle açılmış eski akış
    // gösterilmeye devam eder. Yeni girişte provider sıfırdan, o anki
    // (yeni) kullanıcıya göre yeniden kurulur.
    ref.invalidate(libraryEntriesStreamProvider);
  }

  /// Mevcut şifreyle yeniden doğrulama yaptıktan sonra hesap şifresini
  /// günceller. Mevcut şifre yanlışsa değişiklik uygulanmaz.
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(() async {
      final email = repository.currentUser?.email;
      if (email == null) {
        throw StateError('Aktif bir oturum bulunamadı.');
      }
      await repository.reauthenticateWithPassword(
        email: email,
        password: currentPassword,
      );
      await repository.updatePassword(newPassword: newPassword);
    });
    state = result;
    return !result.hasError;
  }

  /// Mevcut şifreyle yeniden doğrulama yaptıktan sonra e-posta değişikliği
  /// talebi gönderir. Gerçek değişiklik, Supabase'in yeni adrese gönderdiği
  /// bağlantı onaylanana kadar geçerli olmaz.
  Future<bool> updateEmail({
    required String currentPassword,
    required String newEmail,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(() async {
      final email = repository.currentUser?.email;
      if (email == null) {
        throw StateError('Aktif bir oturum bulunamadı.');
      }
      await repository.reauthenticateWithPassword(
        email: email,
        password: currentPassword,
      );
      await repository.updateEmail(newEmail: newEmail);
    });
    state = result;
    return !result.hasError;
  }

  /// Şifremi unuttum: e-postaya doğrulama kodu gönderir. Hesap var/yok
  /// bilgisini sızdırmamak için repository katmanı Supabase hatasını
  /// olduğu gibi yansıtır; ekran her durumda aynı "gönderildi" mesajını
  /// gösterir.
  Future<bool> sendPasswordResetOtp({required String email}) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(
      () => repository.sendPasswordResetOtp(email: email),
    );
    state = result;
    return !result.hasError;
  }

  /// Şifremi unuttum: kodu doğrulayıp yeni şifreyi kaydeder.
  Future<bool> confirmPasswordReset({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(
      () => repository.confirmPasswordReset(
        email: email,
        otp: otp,
        newPassword: newPassword,
      ),
    );
    state = result;
    return !result.hasError;
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);