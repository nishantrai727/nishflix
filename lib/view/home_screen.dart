import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nishflix/bloc/movie_db_bloc/moveie_db_state.dart';
import 'package:nishflix/bloc/movie_db_bloc/movie_db_bloc.dart';
import 'package:nishflix/bloc/movie_db_bloc/movie_db_event.dart';
import 'package:nishflix/core/models/movie_model.dart';
import 'package:nishflix/core/utils/constants/colors.dart';
import 'package:nishflix/view/widgets/custom_featured_movie_carousel.dart';
import 'package:nishflix/view/widgets/custome_horizontal_animated_movie_list.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Temporary mock data ---

  late ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // opacity goes 0 → 1 as you scroll 200px
    final double opacity = (_scrollOffset / 200).clamp(0, 1);

    return BlocProvider(
      create: (context) => MovieDbBloc()..add(FetchMovieDbEvent()),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black,
                Colors.black54,
                Colors.black26,
                Color(0xFFFFF3E0),
              ],
              stops: [0.3, 0.6, 0.8, 1.0],
            ),
          ),
          child: BlocBuilder<MovieDbBloc, MoveieDbState>(
            builder: (context, state) {
              if (state is MoveieDbLoading) {
                return _buildShimmer(context, 1);
              } else if (state is MoveieDbLoaded) {
                return RefreshIndicator(
                  color: Colors.red,
                  backgroundColor: BLACK_COLOR,
                  onRefresh: () async {
                    context.read<MovieDbBloc>().add(FetchMovieDbEvent());
                    await Future.delayed(const Duration(seconds: 1));
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        elevation: 0,
                        backgroundColor: Colors.black54.withOpacity(
                          opacity,
                        ), // 👈 fade in
                        centerTitle: false,
                        title: Image.asset(
                          "assets/netflix_logo.png",
                          width: 30,
                        ),
                        actions: [
                          Container(
                            height: 40,
                            width: 60,
                            child: IconButton(
                              icon: const Icon(
                                fontWeight: FontWeight.w500,
                                Icons.search,
                                color: PRIMARY_COLOR,
                              ),
                              iconSize: 38,
                              onPressed: () {
                                Navigator.pushNamed(context, "/search");
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 60,
                            child: IconButton(
                              icon: const Icon(
                                fontWeight: FontWeight.w500,
                                Icons.bookmark,
                                color: PRIMARY_COLOR,
                              ),
                              iconSize: 38,
                              onPressed: () {
                                Navigator.pushNamed(context, "/bookmark");
                              },
                            ),
                          ),
                        ],
                      ),

                      ..._loadedSlivers(
                        state.nowPlayingMovies,
                        state.popularMovies,
                        state.topRatedMovies,
                        state.upcomingMovies,
                        context,
                      ),
                    ],
                  ),
                );
              } else if (state is MoveieDbError) {
                return RefreshIndicator(
                  color: Colors.red,
                  backgroundColor: BLACK_COLOR,
                  onRefresh: () async {
                    context.read<MovieDbBloc>().add(FetchMovieDbEvent());
                  },
                  child: SingleChildScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(), // 👈 required
                    child: SizedBox(
                      height: MediaQuery.of(
                        context,
                      ).size.height, // fill screen for pull
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
              return Container();
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _loadedSlivers(
    List<MovieModel> nowPlayingMovies,
    List<MovieModel> popularMovies,
    List<MovieModel> topRatedMovies,
    List<MovieModel> upcomingMovies,
    BuildContext context,
  ) {
    return [
      SliverToBoxAdapter(child: _sectionTitle("Now Playing")),
      SliverToBoxAdapter(
        child: FeaturedMovieCarousel(movies: nowPlayingMovies),
      ),

      SliverToBoxAdapter(child: _dividerTop()),
      SliverToBoxAdapter(child: _sectionTitle("Popular")),
      SliverToBoxAdapter(child: const SizedBox(height: 4)),
      SliverToBoxAdapter(child: AnimatedHorizontalList(movies: popularMovies)),

      SliverToBoxAdapter(child: _divider()),
      SliverToBoxAdapter(child: _sectionTitle("Top Rated")),
      SliverToBoxAdapter(child: AnimatedHorizontalList(movies: topRatedMovies)),

      SliverToBoxAdapter(child: _divider()),
      SliverToBoxAdapter(child: _sectionTitle("Upcoming")),
      SliverToBoxAdapter(child: AnimatedHorizontalList(movies: upcomingMovies)),
    ];
  }

  Widget _loadedScreen(
    List<MovieModel> nowPlayingMovies,
    List<MovieModel> popularMovies,
    List<MovieModel> topRatedMovies,
    List<MovieModel> upcomingMovies,
    BuildContext context,
  ) {
    return RefreshIndicator(
      color: Colors.red, // Netflix vibe
      backgroundColor: BLACK_COLOR,
      onRefresh: () async {
        // Trigger BLoC fetch again
        context.read<MovieDbBloc>().add(FetchMovieDbEvent());
        await Future.delayed(const Duration(seconds: 1)); // smooth UX
      },
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // required for pull-to-refresh
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Now Playing"),
            FeaturedMovieCarousel(movies: nowPlayingMovies),

            _dividerTop(),
            _sectionTitle("Popular"),
            const SizedBox(height: 4),
            AnimatedHorizontalList(movies: popularMovies),

            _divider(),
            _sectionTitle("Top Rated"),
            AnimatedHorizontalList(movies: topRatedMovies),

            _divider(),
            _sectionTitle("Upcoming"),
            AnimatedHorizontalList(movies: upcomingMovies),
          ],
        ),
      ),
    );
  }

  /// --- Shimmer Placeholder with Pull to Refresh ---
  Widget _buildShimmer(BuildContext context, double opacity) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MovieDbBloc>().add(FetchMovieDbEvent());
        await Future.delayed(const Duration(seconds: 1)); // smooth UX
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Same SliverAppBar as in loaded state
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title: Image.asset("assets/netflix_logo.png", width: 30),
          ),

          // Now Playing shimmer
          SliverToBoxAdapter(child: _sectionTitle("Now Playing")),
          SliverToBoxAdapter(child: _featuredMovieShimmer(context)),

          // Popular shimmer
          SliverToBoxAdapter(child: _divider()),
          SliverToBoxAdapter(child: _sectionTitle("Popular")),
          SliverToBoxAdapter(child: _horizontalListShimmer()),

          // Top Rated shimmer
          SliverToBoxAdapter(child: _divider()),
          SliverToBoxAdapter(child: _sectionTitle("Top Rated")),
          SliverToBoxAdapter(child: _horizontalListShimmer()),

          // Upcoming shimmer
          SliverToBoxAdapter(child: _divider()),
          SliverToBoxAdapter(child: _sectionTitle("Upcoming")),
          SliverToBoxAdapter(child: _horizontalListShimmer()),
        ],
      ),
    );
  }

  // --- Shimmer Widgets ---
  // --- Featured Carousel Shimmer ---
  Widget _featuredMovieShimmer(BuildContext context) => SizedBox(
    height: MediaQuery.of(context).size.height * 0.60, // match carousel height
    child: PageView.builder(
      itemCount: 3, // show 2-3 shimmer slides
      controller: PageController(viewportFraction: 1),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade800,
              highlightColor: Colors.grey.shade600,
              child: Container(color: Colors.grey.shade800),
            ),
          ),
        );
      },
    ),
  );

  // --- Horizontal List Shimmer ---
  Widget _horizontalListShimmer() => SizedBox(
    height: 230, // match _horizontalList container
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      itemBuilder: (context, _) {
        return Container(
          margin: const EdgeInsets.only(left: 16),
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster shimmer (match height 180, radius 12)
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade800,
                    highlightColor: Colors.grey.shade600,
                    child: Container(color: Colors.grey.shade800),
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // Title shimmer (match style height)
              Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade600,
                child: Container(
                  height: 16,
                  width: 120,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  // --- UI helpers ---
  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child: Text(
      title,
      style: TextStyle(
        color: WHITE_COLOR,
        fontSize: 32,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child: Divider(color: Colors.grey, thickness: 2),
  );

  Widget _dividerTop() => const Padding(
    padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 8),
    child: Divider(color: Colors.grey, thickness: 2),
  );

  Widget _featuredMovie(MovieModel movie) => Container(
    height: 200,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      image: DecorationImage(
        image: NetworkImage(
          "https://image.tmdb.org/t/p/w500${movie.posterPath}",
        ),
        fit: BoxFit.cover,
      ),
    ),
  );

  Widget _horizontalList(List<MovieModel> movies) => SizedBox(
    height: 230,
    child: ListView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Container(
          margin: const EdgeInsets.only(left: 16),
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card with shadow + gradient overlay
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2), // subtle glow
                      blurRadius: 16,
                      spreadRadius: -4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
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

                      // Bottom gradient overlay (makes it feel alive & cinematic)
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

              // Title below poster
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
        );
      },
    ),
  );
}
