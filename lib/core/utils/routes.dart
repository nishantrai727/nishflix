import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nishflix/core/models/movie_detail_model.dart';
import 'package:nishflix/view/bookmark_screen.dart';
import 'package:nishflix/view/details_screen.dart';
import 'package:nishflix/view/home_screen.dart';
import 'package:nishflix/view/search_screen.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings) {
    switch (RouteSettings.name) {
      case "/home":
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case "/detail":
        return MaterialPageRoute(
          builder: (context) => DetailScreen(
            movie: MovieDetailModel(
              id: 1038392,
              title: "The Conjuring: Last Rites",
              overview:
                  "Paranormal investigators Ed and Lorraine Warren take on one last terrifying case involving mysterious entities they must confront.",
              posterPath: "/29ES27icY5CzTcMhlz1H4SdQRod.jpg",
              backdropPath: "/fq8gLtrz1ByW3KQ2IM3RMZEIjsQ.jpg",
              releaseDate: "2025-09-03",
              runtime: 135,
              voteAverage: 6.9,
              genres: [Genre(id: 27, name: "Horror")],
              tagline: "The case that ended it all.",
              status: "Released",
            ),
          ),
        );

      case "/search":
        return MaterialPageRoute(builder: (context) => SearchScreen());

      case "/bookmark":
        return MaterialPageRoute(builder: (context) => BookmarkScreen());

      default:
        return null;
    }
  }
}
