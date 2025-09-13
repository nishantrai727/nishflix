// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchMovieModel _$SearchMovieModelFromJson(Map<String, dynamic> json) =>
    SearchMovieModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String?,
    );

Map<String, dynamic> _$SearchMovieModelToJson(SearchMovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
    };

SearchMovieResponse _$SearchMovieResponseFromJson(Map<String, dynamic> json) =>
    SearchMovieResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => SearchMovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchMovieResponseToJson(
  SearchMovieResponse instance,
) => <String, dynamic>{'results': instance.results};
