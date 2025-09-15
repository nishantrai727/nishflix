import 'package:nishflix/core/models/movie_detail_model.dart';

abstract class MovieDetailEvent {}

class FetchMovieDetail extends MovieDetailEvent {
  final int movieId;

  FetchMovieDetail(this.movieId);
}

class ToggleBookmarkEvent extends MovieDetailEvent {
  final MovieDetailModel movie;
  ToggleBookmarkEvent(this.movie);
}
