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
        final movieId = RouteSettings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => DetailScreen(movieId: movieId),
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
