import 'package:nishflix/core/api_service/api_service.dart';
import 'package:nishflix/core/models/movie_detail_model.dart';
import 'package:nishflix/core/models/movie_model.dart';
import 'package:nishflix/core/models/search_movie_model.dart';
import 'package:nishflix/core/utils/constants/app_constants.dart';

class MovieRepository {
  final ApiService apiService;

  String bearerToken = API_READ_BEARER;

  MovieRepository(this.apiService);

  Future<MovieResponse> getNowPlaying() =>
      apiService.getNowPlayingMovies(bearerToken);
  Future<MovieResponse> getPopular() =>
      apiService.getPopularMovies(bearerToken);
  Future<MovieResponse> getTopRated() =>
      apiService.getTopRatedMovies(bearerToken);
  Future<MovieResponse> getUpcoming() =>
      apiService.getUpcomingMovies(bearerToken);
  Future<MovieDetailModel> getMovieDetail(int movieId) =>
      apiService.getMovieDetail(bearerToken, movieId);
  Future<SearchMovieResponse> searchMovies(
    String query, {
    int page = 1,
    bool includeAdult = true,
    String language = "en-US",
  }) =>
      apiService.searchMovies(bearerToken, query, page, includeAdult, language);
}
