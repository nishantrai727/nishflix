import 'package:json_annotation/json_annotation.dart';

part 'movie_detail_model.g.dart';

@JsonSerializable()
class MovieDetailModel {
  final int id;
  final String title;
  final String overview;

  @JsonKey(name: "poster_path")
  final String? posterPath;

  @JsonKey(name: "backdrop_path")
  final String? backdropPath;

  @JsonKey(name: "release_date")
  final String? releaseDate;

  final int? runtime;

  @JsonKey(name: "vote_average")
  final double voteAverage;

  final List<Genre> genres;

  final String? tagline;
  final String? status;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.runtime,
    required this.voteAverage,
    required this.genres,
    this.tagline,
    this.status,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailModelToJson(this);
}

@JsonSerializable()
class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}
