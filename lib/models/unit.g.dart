// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackingAdapter extends TypeAdapter<Tracking> {
  @override
  final int typeId = 0;

  @override
  Tracking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tracking(
      senderID: fields[0] as int,
      beneficiarieID: fields[1] as int,
      lat: fields[2] as double,
      lng: fields[3] as double,
      distance: fields[4] as double,
      latStartPoint: fields[5] as double,
      lngStartPoint: fields[6] as double,
      latEndPoint: fields[7] as double,
      lngEndPoint: fields[8] as double,
      time: fields[9] as double,
      speed: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Tracking obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.senderID)
      ..writeByte(1)
      ..write(obj.beneficiarieID)
      ..writeByte(2)
      ..write(obj.lat)
      ..writeByte(3)
      ..write(obj.lng)
      ..writeByte(4)
      ..write(obj.distance)
      ..writeByte(5)
      ..write(obj.latStartPoint)
      ..writeByte(6)
      ..write(obj.lngStartPoint)
      ..writeByte(7)
      ..write(obj.latEndPoint)
      ..writeByte(8)
      ..write(obj.lngEndPoint)
      ..writeByte(9)
      ..write(obj.time)
      ..writeByte(10)
      ..write(obj.speed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
