import 'package:freezed_annotation/freezed_annotation.dart';

import 'movie_model.dart';
import 'tv_show_model.dart';

part 'multi_search_result_model.freezed.dart';

@freezed
sealed class MultiSearchResultModel with _$MultiSearchResultModel {
  const factory MultiSearchResultModel({
    @Default(1) int page,
    @Default(0) int totalPages,
    @Default(0) int totalResults,
    @Default(<MovieModel>[]) List<MovieModel> movies,
    @Default(<TvShowModel>[]) List<TvShowModel> tvShows,
  }) = _MultiSearchResultModel;
}