import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nishflix/bloc/movie_bookmark_bloc/movie_bookmark_bloc.dart';
import 'package:nishflix/bloc/movie_bookmark_bloc/movie_bookmark_event.dart';
import 'package:nishflix/bloc/movie_bookmark_bloc/movie_bookmark_state.dart';
import 'package:nishflix/core/models/movie_detail_model.dart';
import 'package:nishflix/core/utils/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookmarkBloc()..add(LoadBookmarks()),
      child: Scaffold(
        backgroundColor: BLACK_COLOR,
        appBar: AppBar(
          title: const Text(
            "Bookmarked Movies",
            style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w500),
          ),
          backgroundColor: BLACK_COLOR,
          centerTitle: true,
          leading: ClipOval(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        body: BlocBuilder<BookmarkBloc, BookmarkState>(
          builder: (context, state) {
            if (state is BookmarkLoading || state is BookmarkInitial) {
              return _buildShimmerGrid();
            } else if (state is BookmarkLoaded) {
              return _buildGrid(state.movies);
            } else if (state is BookmarkEmpty) {
              return const Center(
                child: Text(
                  "No bookmarked movies.",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            } else if (state is BookmarkError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// 🎬 Grid of bookmarked movies
  Widget _buildGrid(List<MovieDetailModel> movies) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // same as SearchScreen
        childAspectRatio: 0.65,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: movie.id);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: movie.posterPath != null
                  ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                  : "",
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade600,
                child: Container(color: Colors.grey.shade800),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade900,
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.white70,
                  size: 30,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔥 Shimmer grid
  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade600,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
