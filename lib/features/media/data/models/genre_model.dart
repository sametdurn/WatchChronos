import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre_model.freezed.dart';
part 'genre_model.g.dart';

@freezed
sealed class GenreModel with _$GenreModel {
  const factory GenreModel({required int id, required String name}) =
      _GenreModel;

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);
}