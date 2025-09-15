import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:nishflix/bloc/movie_detail_bloc/movie_detail_event.dart';
import 'package:nishflix/bloc/movie_detail_bloc/movie_detail_state.dart';
import 'package:nishflix/core/api_service/api_service.dart';
import 'package:nishflix/core/models/movie_detail_model.dart';
import 'package:nishflix/data/repository/movie_repository.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  late final MovieRepository movieRepository;
  late final Box<MovieDetailModel> movieDetailBox;

  MovieDetailBloc() : super(MovieDetailInitial()) {
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

    final ApiService apiService = ApiService(dio);
    movieRepository = MovieRepository(apiService);

    movieDetailBox = Hive.box<MovieDetailModel>('movieDetailBox');

    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());

      try {
        final cached = movieDetailBox.get(event.movieId);
        final bookmarkBox = Hive.box<MovieDetailModel>('bookmarkBox');

        MovieDetailModel? movie;

        if (cached != null) {
          movie = cached;
        } else {
          movie = await movieRepository.getMovieDetail(event.movieId);
          await movieDetailBox.put(event.movieId, movie);
        }

        // ✅ check if bookmarked
        final isBookmarked = bookmarkBox.containsKey(event.movieId);

        emit(MovieDetailLoaded(movie, isBookmarked: isBookmarked));
      } catch (e) {
        final cached = movieDetailBox.get(event.movieId);
        if (cached != null) {
          emit(MovieDetailLoaded(cached));
        } else {
          emit(MovieDetailError("Failed to load movie: $e"));
        }
      }
    });

    on<ToggleBookmarkEvent>((event, emit) async {
      final bookmarkBox = Hive.box<MovieDetailModel>('bookmarkBox');

      final alreadyBookmarked = bookmarkBox.containsKey(event.movie.id);

      if (alreadyBookmarked) {
        await bookmarkBox.delete(event.movie.id);
      } else {
        await bookmarkBox.put(event.movie.id, event.movie);
      }

      emit(MovieDetailLoaded(event.movie, isBookmarked: !alreadyBookmarked));
    });
  }
}
