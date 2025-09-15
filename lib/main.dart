import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:nishflix/bloc/movie_db_bloc/movie_db_bloc.dart';
import 'package:nishflix/core/api_service/api_service.dart';
import 'package:nishflix/core/models/movie_detail_model.dart';
import 'package:nishflix/core/models/movie_detail_model_adapter.dart';
import 'package:nishflix/core/models/movie_model.dart';
import 'package:nishflix/core/models/movie_model_adapter.dart';
import 'package:nishflix/core/utils/routes.dart';

import 'package:nishflix/data/repository/movie_repository.dart';

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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NishFlix',
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
