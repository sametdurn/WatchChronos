/// `public.profiles` tablosunun karşılığı. Kayıt sırasında seçilen
/// [username] sadece görüntü amaçlıdır (giriş e-posta ile yapılır) ve
/// profil sayfasından sonradan değiştirilebilir.
///
/// Diğer modellerin aksine (bkz. watch_entry.dart) elle yazıldı; freezed/
/// json_serializable code generation bu projede `build_runner` ile
/// üretiliyor ve bu ortamda çalıştırılamadığından basit bir sınıf tercih
/// edildi. İstersen sonradan @freezed'e çevirip `flutter pub run
/// build_runner build` çalıştırabilirsin.
class Profile {
  const Profile({
    required this.id,
    this.username,
    this.avatarUrl,
    this.coverUrl,
  });

  final String id;
  final String? username;
  final String? avatarUrl;
  final String? coverUrl;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      coverUrl: json['cover_url'] as String?,
    );
  }

  Profile copyWith({String? username, String? avatarUrl, String? coverUrl}) {
    return Profile(
      id: id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }
}