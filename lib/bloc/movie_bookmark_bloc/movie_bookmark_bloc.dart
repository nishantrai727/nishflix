import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:nishflix/bloc/movie_bookmark_bloc/movie_bookmark_event.dart';
import 'package:nishflix/bloc/movie_bookmark_bloc/movie_bookmark_state.dart';
import 'package:nishflix/core/models/movie_detail_model.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  late final Box<MovieDetailModel> bookmarkBox;

  BookmarkBloc() : super(BookmarkInitial()) {
    bookmarkBox = Hive.box<MovieDetailModel>('bookmarkBox');

    on<LoadBookmarks>((event, emit) async {
      emit(BookmarkLoading());

      try {
        final movies = bookmarkBox.values.toList();

        if (movies.isEmpty) {
          emit(BookmarkEmpty());
        } else {
          emit(BookmarkLoaded(movies));
        }
      } catch (e) {
        emit(BookmarkError("Failed to load bookmarks: $e"));
      }
    });
  }
}
