import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nishflix/core/models/movie_model.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedHorizontalList extends StatefulWidget {
  final List<MovieModel> movies;
  const AnimatedHorizontalList({Key? key, required this.movies})
    : super(key: key);

  @override
  _AnimatedHorizontalListState createState() => _AnimatedHorizontalListState();
}

class _AnimatedHorizontalListState extends State<AnimatedHorizontalList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _firstBuildDone = false;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Play animation only once on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_firstBuildDone) {
        _controller.forward();
        _firstBuildDone = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        scrollDirection: Axis.horizontal,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          final movie = widget.movies[index];

          // First card with animation
          if (index == 0 && !_controller.isCompleted) {
            return ScaleTransition(
              scale: _scaleAnimation,
              child: _movieCard(movie, leftMargin: 16),
            );
          }

          // Normal cards
          return _movieCard(movie, leftMargin: 16);
        },
      ),
    );
  }

  Widget _movieCard(MovieModel movie, {double leftMargin = 0}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: movie);
      },
      child: Container(
        margin: EdgeInsets.only(left: leftMargin),
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card with shadow + gradient overlay
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.4),
                //     blurRadius: 12,
                //     offset: const Offset(0, 6),
                //   ),
                //   BoxShadow(
                //     color: Colors.red.withOpacity(0.2), // subtle glow
                //     blurRadius: 16,
                //     spreadRadius: -4,
                //     offset: const Offset(0, 0),
                //   ),
                // ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
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
                        errorWidget: (context, url, error) =>
                            Shimmer.fromColors(
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
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black54,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
