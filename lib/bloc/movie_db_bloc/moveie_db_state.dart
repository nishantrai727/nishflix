import 'package:nishflix/core/models/movie_model.dart';

abstract class MoveieDbState {}

class MoveieDbInitial extends MoveieDbState {}

class MoveieDbLoading extends MoveieDbState {}

class MoveieDbLoaded extends MoveieDbState {
  List<MovieModel> nowPlayingMovies;
  List<MovieModel> popularMovies;
  List<MovieModel> topRatedMovies;
  List<MovieModel> upcomingMovies;

  MoveieDbLoaded({
    required this.nowPlayingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.upcomingMovies,
  });
}

class MoveieDbError extends MoveieDbState {
  String message;
  MoveieDbError({required this.message});
}
