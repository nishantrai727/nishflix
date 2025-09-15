import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:nishflix/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:nishflix/bloc/movie_detail_bloc/movie_detail_event.dart';
import 'package:nishflix/bloc/movie_detail_bloc/movie_detail_state.dart';
import 'package:nishflix/core/models/movie_detail_model.dart';
import 'package:nishflix/core/utils/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class DetailScreen extends StatelessWidget {
  final int movieId;

  const DetailScreen({super.key, required this.movieId});

  String _formatRuntime(int? minutes) {
    if (minutes == null) return "—";
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return "${hours}h ${mins}m";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailBloc()..add(FetchMovieDetail(movieId)),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoading || state is MovieDetailInitial) {
              return _buildShimmer();
            } else if (state is MovieDetailLoaded) {
              return _buildDetail(
                state.movieDetail,
                state.isBookmarked,
                context,
              );
            } else if (state is MovieDetailError) {
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

  /// 🎬 Actual Detail UI
  Widget _buildDetail(
    MovieDetailModel movie,
    bool isBookmarked,
    BuildContext context,
  ) {
    return CustomScrollView(
      slivers: [
        // Backdrop / Poster
        SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: 280,
          pinned: true,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: movie.backdropPath != null
                      ? "https://image.tmdb.org/t/p/w780${movie.backdropPath}"
                      : movie.posterPath != null
                      ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                      : "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey.shade800),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade900,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white70,
                      size: 40,
                    ),
                  ),
                ),
                // gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),

                // 🔙 Custom back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 12,
                  child: ClipOval(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Details
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? PRIMARY_COLOR : Colors.white70,
                        size: 32,
                      ),
                      onPressed: () {
                        context.read<MovieDetailBloc>().add(
                          ToggleBookmarkEvent(movie),
                        );
                      },
                    ),
                  ],
                ),

                // Tagline + Bookmark button
                if (movie.tagline != null && movie.tagline!.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          movie.tagline!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 12),

                // Year • Runtime • Rating
                Row(
                  children: [
                    Text(
                      (movie.releaseDate != null &&
                              movie.releaseDate!.isNotEmpty)
                          ? movie.releaseDate!.split("-")[0]
                          : "—",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.circle, size: 4, color: Colors.white54),
                    const SizedBox(width: 12),
                    Text(
                      _formatRuntime(movie.runtime),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.circle, size: 4, color: Colors.white54),
                    const SizedBox(width: 12),
                    Text(
                      "${movie.voteAverage.toStringAsFixed(1)} ★",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Genres
                if (movie.genres.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: movie.genres
                        .map(
                          (genre) => Chip(
                            label: Text(
                              genre.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: PRIMARY_COLOR,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Colors.white24),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                const SizedBox(height: 16),

                // Overview
                Text(
                  movie.overview,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                // Status
                if (movie.status != null)
                  Text(
                    "Status: ${movie.status}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 🔥 Shimmer UI (Loading)
  Widget _buildShimmer() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: 280,
          pinned: true,
          flexibleSpace: Shimmer.fromColors(
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.grey.shade600,
            child: Container(color: Colors.grey.shade800),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade800,
                  highlightColor: Colors.grey.shade600,
                  child: Container(height: 24, width: 200, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(
                    3,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade600,
                        child: Container(
                          height: 14,
                          width: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(
                    3,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade600,
                        child: Container(
                          height: 24,
                          width: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: List.generate(
                    3,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade600,
                        child: Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
