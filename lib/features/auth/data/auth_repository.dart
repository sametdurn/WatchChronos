import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUpWithPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  Future<void> signOut() => _client.auth.signOut();

  /// Hassas hesap işlemlerinden (şifre/e-posta değişikliği) önce mevcut
  /// şifreyle yeniden kimlik doğrulaması yapar. Oturum çalınmış olsa bile
  /// bu adımlar için gerçek şifrenin bilinmesini zorunlu kılar.
  Future<void> reauthenticateWithPassword({
    required String email,
    required String password,
  }) => signInWithPassword(email: email, password: password);

  /// Hesap şifresini değiştirir. Supabase tarafında oturum zaten geçerli
  /// olduğundan ek bir onay adımı gerekmez.
  Future<void> updatePassword({required String newPassword}) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  /// Hesap e-postasını değiştirmeyi talep eder. Supabase projesinde
  /// "Secure email change" AÇIK olduğundan, değişikliğin geçerli olması
  /// için hem eski hem yeni adresteki onay bağlantılarının tıklanması
  /// gerekir. (Bkz. Supabase Dashboard > Authentication > Settings)
  Future<void> updateEmail({required String newEmail}) async {
    await _client.auth.updateUser(UserAttributes(email: newEmail));
  }

  /// Şifremi unuttum akışının 1. adımı: e-postaya 6 haneli bir doğrulama
  /// kodu (OTP) gönderir. Deep link kurulumu gerektirmediğinden mobil,
  /// masaüstü ve web'de aynı şekilde çalışır. Supabase, hesap var/yok
  /// bilgisini sızdırmamak için bu çağrıda e-posta bulunamasa da hata
  /// döndürmez; bu yüzden UI her zaman "gönderildiyse" mesajı gösterir.
  Future<void> sendPasswordResetOtp({required String email}) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Şifremi unuttum akışının 2. adımı: e-postayla gelen kodu doğrulayıp
  /// (bu, kullanıcıyı geçici bir kurtarma oturumuyla giriş yaptırır),
  /// yeni şifreyi kaydeder ve ardından bu geçici oturumdan çıkış yapar.
  /// Böylece kullanıcı her zaman giriş ekranına döner ve yeni şifresiyle
  /// bilinçli olarak tekrar giriş yapar.
  Future<void> confirmPasswordReset({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _client.auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.recovery,
    );
    await _client.auth.updateUser(UserAttributes(password: newPassword));
    await _client.auth.signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(client);
});