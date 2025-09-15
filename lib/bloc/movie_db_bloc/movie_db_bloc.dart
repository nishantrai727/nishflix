import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nishflix/bloc/movie_db_bloc/moveie_db_state.dart';
import 'package:nishflix/bloc/movie_db_bloc/movie_db_event.dart';
import 'package:nishflix/core/api_service/api_service.dart';
import 'package:nishflix/core/models/movie_model.dart';
import 'package:nishflix/data/repository/movie_repository.dart';

class MovieDbBloc extends Bloc<MovieDbEvent, MoveieDbState> {
  MovieDbBloc() : super(MoveieDbInitial()) {
    final Dio _dio = Dio(
      BaseOptions(
        contentType: "application/json",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => print("🔗 Dio Log: $obj"),
      ),
    );

    final ApiService _apiService = ApiService(_dio);
    late final MovieRepository movieRepository;
    movieRepository = MovieRepository(_apiService);

    on<FetchMovieDbEvent>((event, emit) async {
      final nowPlayingBox = Hive.box<MovieModel>('nowPlayingBox');
      final popularBox = Hive.box<MovieModel>('popularBox');
      final topRatedBox = Hive.box<MovieModel>('topRatedBox');
      final upcomingBox = Hive.box<MovieModel>('upcomingBox');

      try {
        // 1. Now Playing
        final nowPlaying = await movieRepository.getNowPlaying();
        await nowPlayingBox.clear();
        await nowPlayingBox.addAll(nowPlaying.results);
        emit(MoveieDbLoading(nowPlayingMovies: nowPlaying.results));

        // 2. Popular
        final popular = await movieRepository.getPopular();
        await popularBox.clear();
        await popularBox.addAll(popular.results);
        emit(
          MoveieDbLoading(
            nowPlayingMovies: nowPlaying.results,
            popularMovies: popular.results,
          ),
        );

        // 3. Top Rated
        final topRated = await movieRepository.getTopRated();
        await topRatedBox.clear();
        await topRatedBox.addAll(topRated.results);
        emit(
          MoveieDbLoading(
            nowPlayingMovies: nowPlaying.results,
            popularMovies: popular.results,
            topRatedMovies: topRated.results,
          ),
        );

        // 4. Upcoming
        final upcoming = await movieRepository.getUpcoming();
        await upcomingBox.clear();
        await upcomingBox.addAll(upcoming.results);

        // ✅ Final Loaded State
        emit(
          MoveieDbLoaded(
            nowPlayingMovies: nowPlaying.results,
            popularMovies: popular.results,
            topRatedMovies: topRated.results,
            upcomingMovies: upcoming.results,
          ),
        );
      } catch (e) {
        // 🔄 Fallback to cache if API fails
        if (nowPlayingBox.isNotEmpty ||
            popularBox.isNotEmpty ||
            topRatedBox.isNotEmpty ||
            upcomingBox.isNotEmpty) {
          emit(
            MoveieDbLoaded(
              nowPlayingMovies: nowPlayingBox.values.toList(),
              popularMovies: popularBox.values.toList(),
              topRatedMovies: topRatedBox.values.toList(),
              upcomingMovies: upcomingBox.values.toList(),
            ),
          );
        } else {
          emit(MoveieDbError(message: e.toString()));
        }
      }
    });

    // on<FetchMovieDbEvent>((event, emit) async {
    //   emit(MoveieDbLoading());

    //   final nowPlaying = await movieRepository.getNowPlaying();
    //   final popular = await movieRepository.getPopular();
    //   final topRated = await movieRepository.getTopRated();
    //   final upcoming = await movieRepository.getUpcoming();

    //   emit(
    //     MoveieDbLoaded(
    //       nowPlayingMovies: nowPlaying.results,
    //       popularMovies: popular.results,
    //       topRatedMovies: topRated.results,
    //       upcomingMovies: upcoming.results,
    //     ),
    //   );
    // });

    // on<FetchMovieDbEvent>((event, emit) async {
    //   emit(MoveieDbLoading());

    //   try {
    //     // Fetch from API
    //     final nowPlaying = await movieRepository.getNowPlaying();
    //     final popular = await movieRepository.getPopular();
    //     final topRated = await movieRepository.getTopRated();
    //     final upcoming = await movieRepository.getUpcoming();

    //     // Hive boxes
    //     final nowPlayingBox = Hive.box<MovieModel>('nowPlayingBox');
    //     final popularBox = Hive.box<MovieModel>('popularBox');
    //     final topRatedBox = Hive.box<MovieModel>('topRatedBox');
    //     final upcomingBox = Hive.box<MovieModel>('upcomingBox');

    //     // Clear old data
    //     await nowPlayingBox.clear();
    //     await popularBox.clear();
    //     await topRatedBox.clear();
    //     await upcomingBox.clear();

    //     // Store new data (convert API model → MovieModel)
    //     await nowPlayingBox.addAll(
    //       nowPlaying.results.map(
    //         (m) => MovieModel(
    //           id: m.id,
    //           title: m.title,
    //           overview: m.overview,
    //           posterPath: m.posterPath,
    //         ),
    //       ),
    //     );

    //     await popularBox.addAll(
    //       popular.results.map(
    //         (m) => MovieModel(
    //           id: m.id,
    //           title: m.title,
    //           overview: m.overview,
    //           posterPath: m.posterPath,
    //         ),
    //       ),
    //     );

    //     await topRatedBox.addAll(
    //       topRated.results.map(
    //         (m) => MovieModel(
    //           id: m.id,
    //           title: m.title,
    //           overview: m.overview,
    //           posterPath: m.posterPath,
    //         ),
    //       ),
    //     );

    //     await upcomingBox.addAll(
    //       upcoming.results.map(
    //         (m) => MovieModel(
    //           id: m.id,
    //           title: m.title,
    //           overview: m.overview,
    //           posterPath: m.posterPath,
    //         ),
    //       ),
    //     );

    //     emit(
    //       MoveieDbLoaded(
    //         nowPlayingMovies: nowPlaying.results,
    //         popularMovies: popular.results,
    //         topRatedMovies: topRated.results,
    //         upcomingMovies: upcoming.results,
    //       ),
    //     );
    //   } catch (e) {
    //     // Fallback to cached Hive data
    //     final nowPlayingBox = Hive.box<MovieModel>('nowPlayingBox');
    //     final popularBox = Hive.box<MovieModel>('popularBox');
    //     final topRatedBox = Hive.box<MovieModel>('topRatedBox');
    //     final upcomingBox = Hive.box<MovieModel>('upcomingBox');

    //     if (nowPlayingBox.isNotEmpty ||
    //         popularBox.isNotEmpty ||
    //         topRatedBox.isNotEmpty ||
    //         upcomingBox.isNotEmpty) {
    //       emit(
    //         MoveieDbLoaded(
    //           nowPlayingMovies: nowPlayingBox.values.toList(),
    //           popularMovies: popularBox.values.toList(),
    //           topRatedMovies: topRatedBox.values.toList(),
    //           upcomingMovies: upcomingBox.values.toList(),
    //         ),
    //       );
    //     } else {
    //       emit(MoveieDbError(message: e.toString()));
    //     }
    //   }
    // });
  }
}
