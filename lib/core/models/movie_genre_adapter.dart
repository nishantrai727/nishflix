// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:hive/hive.dart';
import 'movie_detail_model.dart';

class GenreAdapter extends TypeAdapter<Genre> {
  @override
  final int typeId = 3; // make sure this is unique

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

  @override
  // equality based on typeId (important for Hive)
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
