// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userlogin.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLoginAdapter extends TypeAdapter<UserLogin> {
  @override
  final int typeId = 0;

  @override
  UserLogin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLogin(
      userId: fields[0] as String,
      userName: fields[1] as String,
      userEmail: fields[2] as String,
      userPhone: fields[3] as String,
      userToken: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserLogin obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.userEmail)
      ..writeByte(3)
      ..write(obj.userPhone)
      ..writeByte(4)
      ..write(obj.userToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLoginAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
