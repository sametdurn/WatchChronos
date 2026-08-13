/// TMDB `/credits` uç noktasından dönen oyuncu bilgisi. Detay ekranında
/// içeriğin oyuncu kadrosunu göstermek için kullanılır; önbelleğe alınmaz,
/// detay ekranı her açıldığında TMDB'den taze çekilir.
class CastMemberModel {
  const CastMemberModel({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
  });

  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    return CastMemberModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      character: json['character'] as String?,
      profilePath: json['profile_path'] as String?,
    );
  }

  final int id;
  final String name;
  final String? character;
  final String? profilePath;
}
