part of 'movie_detail_model.dart';

MovieDetailModel _$MovieDetailModelFromJson(Map<String, dynamic> json) =>
    MovieDetailModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      runtime: (json['runtime'] as num?)?.toInt(),
      voteAverage: (json['vote_average'] as num).toDouble(),
      genres: (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      tagline: json['tagline'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$MovieDetailModelToJson(MovieDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'release_date': instance.releaseDate,
      'runtime': instance.runtime,
      'vote_average': instance.voteAverage,
      'genres': instance.genres,
      'tagline': instance.tagline,
      'status': instance.status,
    };

Genre _$GenreFromJson(Map<String, dynamic> json) =>
    Genre(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$GenreToJson(Genre instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};
