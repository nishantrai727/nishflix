import 'package:nishflix/core/models/movie_detail_model.dart';

abstract class BookmarkState {}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<MovieDetailModel> movies;
  BookmarkLoaded(this.movies);
}

class BookmarkEmpty extends BookmarkState {}

class BookmarkError extends BookmarkState {
  final String message;
  BookmarkError(this.message);
}
