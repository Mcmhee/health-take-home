// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthEntryModelAdapter extends TypeAdapter<HealthEntryModel> {
  @override
  final int typeId = 1;

  @override
  HealthEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthEntryModel(
      id: fields[0] as String?,
      userId: fields[1] as String,
      date: fields[2] as DateTime,
      mood: fields[3] as String,
      note: fields[4] as String?,
      isSynced: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HealthEntryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.mood)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
