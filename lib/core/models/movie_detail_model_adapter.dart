import 'package:hive/hive.dart';
import 'movie_detail_model.dart';

class MovieDetailModelAdapter extends TypeAdapter<MovieDetailModel> {
  @override
  final int typeId = 2; // unique ID for this model

  @override
  MovieDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return MovieDetailModel(
      id: fields[0] as int,
      title: fields[1] as String,
      overview: fields[2] as String,
      posterPath: fields[3] as String?,
      backdropPath: fields[4] as String?,
      releaseDate: fields[5] as String?,
      runtime: fields[6] as int?,
      voteAverage: fields[7] as double,
      genres: (fields[8] as List).cast<Genre>(),
      tagline: fields[9] as String?,
      status: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieDetailModel obj) {
    writer
      ..writeByte(11) // number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterPath)
      ..writeByte(4)
      ..write(obj.backdropPath)
      ..writeByte(5)
      ..write(obj.releaseDate)
      ..writeByte(6)
      ..write(obj.runtime)
      ..writeByte(7)
      ..write(obj.voteAverage)
      ..writeByte(8)
      ..write(obj.genres)
      ..writeByte(9)
      ..write(obj.tagline)
      ..writeByte(10)
      ..write(obj.status);
  }
}

class GenreAdapter extends TypeAdapter<Genre> {
  @override
  final int typeId = 3; // unique ID for Genre

  @override
  Genre read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Genre(id: fields[0] as int, name: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, Genre obj) {
    writer
      ..writeByte(2) // number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }
}
