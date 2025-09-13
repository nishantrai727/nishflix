import 'package:dio/dio.dart';
import 'package:nishflix/core/models/movie_detail_model.dart';
import 'package:nishflix/core/models/movie_model.dart';
import 'package:nishflix/core/models/search_movie_model.dart';
import 'package:nishflix/core/utils/constants/app_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: API_URL)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(NOW_PLAYING_MOVIES_URL)
  Future<MovieResponse> getNowPlayingMovies(
    @Header("Authorization") String bearer,
  );

  @GET(POPULAR_MOVIES_URL)
  Future<MovieResponse> getPopularMovies(
    @Header("Authorization") String bearer,
  );

  @GET(TOP_RATED_MOVIES_URL)
  Future<MovieResponse> getTopRatedMovies(
    @Header("Authorization") String bearer,
  );

  @GET(UPCOMING_MOVIES_URL)
  Future<MovieResponse> getUpcomingMovies(
    @Header("Authorization") String bearer,
  );

  // Movie Detail
  @GET("$MOVIE_DETAILS_URL/{id}")
  Future<MovieDetailModel> getMovieDetail(
    @Header("Authorization") String bearer,
    @Path("id") int movieId,
  );
  // Search
  @GET(SEARCH_MOVIES_URL)
  Future<SearchMovieResponse> searchMovies(
    @Header("Authorization") String bearer,
    @Query("query") String query,
    @Query("page") int page,
    @Query("include_adult") bool includeAdult,
    @Query("language") String language,
  );
}
