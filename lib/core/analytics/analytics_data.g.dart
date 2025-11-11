// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalyticsDataAdapter extends TypeAdapter<AnalyticsData> {
  @override
  final int typeId = 0;

  @override
  AnalyticsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyticsData(
      id: fields[0] as String,
      eventType: fields[1] as String,
      data: fields[2] as String,
      isSuccess: fields[3] as bool,
      createTime: fields[4] as int,
      uploadTime: fields[5] as int?,
      isUploaded: fields[6] as bool,
      sequenceId: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AnalyticsData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventType)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.isSuccess)
      ..writeByte(4)
      ..write(obj.createTime)
      ..writeByte(5)
      ..write(obj.uploadTime)
      ..writeByte(6)
      ..write(obj.isUploaded)
      ..writeByte(7)
      ..write(obj.sequenceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
