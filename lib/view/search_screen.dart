import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nishflix/bloc/search_movie_bloc/search_movie_bloc.dart';
import 'package:nishflix/bloc/search_movie_bloc/search_movie_event.dart';
import 'package:nishflix/bloc/search_movie_bloc/search_movie_state.dart';
import 'package:nishflix/core/utils/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return SearchBloc();
      },
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<SearchBloc>().add(SearchMoviesEvent(query));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLACK_COLOR,
      appBar: AppBar(
        title: const Text(
          "Search",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search movies...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Results
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return _buildShimmerGrid();
                } else if (state is SearchLoaded) {
                  if (state.movies.isEmpty) {
                    return const Center(
                      child: Text(
                        "No results found",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.65,
                        ),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: movie.id,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: movie.posterPath != null
                                ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                                : "",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => _buildShimmerBox(),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is SearchError) {
                  return RefreshIndicator(
                    color: Colors.red,
                    backgroundColor: BLACK_COLOR,
                    onRefresh: () async {
                      context.read<SearchBloc>().add(
                        SearchMoviesEvent(_controller.text),
                      );
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Something went wrong! Pull down page to refresh.",
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    "Start typing to search",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.65,
      ),
      itemCount: 9,
      itemBuilder: (_, __) => _buildShimmerBox(),
    );
  }

  Widget _buildShimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
