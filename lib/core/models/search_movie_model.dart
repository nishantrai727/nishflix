import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_movie_model.g.dart';

@HiveType(
  typeId: 1,
) // ⚡ Make sure this ID is unique (different from MovieModel's 0)
@JsonSerializable()
class SearchMovieModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  @JsonKey(name: "poster_path")
  final String? posterPath;

  SearchMovieModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
  });

  factory SearchMovieModel.fromJson(Map<String, dynamic> json) =>
      _$SearchMovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchMovieModelToJson(this);
}

@JsonSerializable()
class SearchMovieResponse {
  final List<SearchMovieModel> results;

  SearchMovieResponse({required this.results});

  factory SearchMovieResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchMovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchMovieResponseToJson(this);
}
