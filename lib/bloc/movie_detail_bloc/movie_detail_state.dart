import 'package:nishflix/core/models/movie_detail_model.dart';

abstract class MovieDetailState {}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetailModel movieDetail;
  final bool isBookmarked;

  MovieDetailLoaded(this.movieDetail, {this.isBookmarked = false});
}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);
}
