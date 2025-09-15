import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:nishflix/core/models/movie_model.dart';
import 'package:nishflix/core/models/movie_model_adapter.dart';
import 'package:nishflix/core/models/movie_detail_model.dart';
import 'package:nishflix/core/models/movie_detail_model_adapter.dart';
import 'package:nishflix/core/utils/routes.dart';
import 'package:nishflix/view/details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MovieModelAdapter());
  Hive.registerAdapter(MovieDetailModelAdapter());
  Hive.registerAdapter(GenreAdapter());

  await Hive.openBox<MovieModel>('nowPlayingBox');
  await Hive.openBox<MovieModel>('popularBox');
  await Hive.openBox<MovieModel>('topRatedBox');
  await Hive.openBox<MovieModel>('upcomingBox');
  await Hive.openBox<MovieDetailModel>('movieDetailBox');
  await Hive.openBox<MovieDetailModel>('bookmarkBox');

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    // 🔹 Handle initial link
    _appLinks.getInitialLink().then(_handleLink);

    // 🔹 Listen for incoming links
    _linkSubscription = _appLinks.uriLinkStream.listen(_handleLink);
  }

  void _handleLink(Uri? uri) {
    if (uri == null) return;
    debugPrint("Deep link received: $uri");

    if (uri.scheme == "nishflix" && uri.host == "movie") {
      final id = int.tryParse(uri.pathSegments.first);
      if (id != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => DetailScreen(movieId: id)),
        );
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NishFlix',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: "/home",
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
