import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:nishflix/bloc/search_movie_bloc/search_movie_event.dart';
import 'package:nishflix/bloc/search_movie_bloc/search_movie_state.dart';
import 'package:nishflix/core/api_service/api_service.dart';
import 'package:nishflix/data/repository/movie_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    final Dio dio = Dio(
      BaseOptions(
        contentType: "application/json",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => print("MovieDetail Dio: $obj"),
      ),
    );

    final ApiService _apiService = ApiService(dio);
    late final MovieRepository movieRepository;
    movieRepository = MovieRepository(_apiService);
    on<SearchMoviesEvent>((event, emit) async {
      emit(SearchLoading());
      try {
        final response = await movieRepository.searchMovies(event.query);

        // ✅ Filter out movies that don’t have posterPath
        final filteredMovies = response.results
            .where((m) => m.posterPath != null && m.posterPath!.isNotEmpty)
            .toList();

        emit(SearchLoaded(filteredMovies));
      } catch (e) {
        emit(SearchError("Failed to search movies: $e"));
      }
    });
  }
}
