import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nishflix/core/models/movie_model.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedMovieCarousel extends StatefulWidget {
  final List<MovieModel> movies;
  const FeaturedMovieCarousel({Key? key, required this.movies})
    : super(key: key);

  @override
  State<FeaturedMovieCarousel> createState() => _FeaturedMovieCarouselState();
}

class _FeaturedMovieCarouselState extends State<FeaturedMovieCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % widget.movies.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.60,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.movies.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemBuilder: (context, index) {
          return _animatedMovieCard(index);
        },
      ),
    );
  }

  Widget _animatedMovieCard(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;

        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;

          value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
        } else {
          value = index == 0 ? 1.0 : 0.7;
        }

        return Center(
          child: Transform.scale(
            scale: value,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: value,
              child: _movieCard(widget.movies[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _movieCard(MovieModel movie) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: movie.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 30,
              spreadRadius: -10,
              offset: const Offset(0, 40),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Poster image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl:
                      "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade800,
                    highlightColor: Colors.grey.shade600,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade800,
                    highlightColor: Colors.grey.shade600,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white70,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),

              // Gradient blur overlay (bottom fade)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Title text (bottom-left aligned)
              // Positioned(
              //   left: 8,
              //   right: 8,
              //   bottom: -20,
              //   child: Text(
              //     movie.title.toUpperCase(),
              //     maxLines: 1,
              //     overflow: TextOverflow.fade,
              //     style: const TextStyle(
              //       color: Colors.white,
              //       fontSize: 44,
              //       fontWeight: FontWeight.w700,
              //       shadows: [
              //         Shadow(
              //           blurRadius: 6,
              //           color: Colors.black54,
              //           offset: Offset(0, 2),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
