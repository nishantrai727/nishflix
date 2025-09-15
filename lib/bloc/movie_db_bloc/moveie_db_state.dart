import 'package:nishflix/core/models/movie_model.dart';

abstract class MoveieDbState {}

class MoveieDbInitial extends MoveieDbState {}

class MoveieDbLoading extends MoveieDbState {
  final List<MovieModel> nowPlayingMovies;
  final List<MovieModel> popularMovies;
  final List<MovieModel> topRatedMovies;
  final List<MovieModel> upcomingMovies;

  MoveieDbLoading({
    this.nowPlayingMovies = const [],
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.upcomingMovies = const [],
  });
}

class MoveieDbLoaded extends MoveieDbState {
  final List<MovieModel> nowPlayingMovies;
  final List<MovieModel> popularMovies;
  final List<MovieModel> topRatedMovies;
  final List<MovieModel> upcomingMovies;

  MoveieDbLoaded({
    required this.nowPlayingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.upcomingMovies,
  });
}

class MoveieDbError extends MoveieDbState {
  final String message;
  MoveieDbError({required this.message});
}
