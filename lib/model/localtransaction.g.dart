// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localtransaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalTransactionAdapter extends TypeAdapter<LocalTransaction> {
  @override
  final int typeId = 1;

  @override
  LocalTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalTransaction(
      userId: fields[0] as String,
      tID: fields[1] as String,
      tNote: fields[2] as String,
      tPaymentMode: fields[3] as String,
      tAmount: fields[4] as int,
      tCategory: fields[5] as int,
      tSubcategory: fields[6] as int,
      tSubcategoryIndex: fields[7] as int,
      tDateTime: fields[8] as DateTime,
      tCreatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LocalTransaction obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.tID)
      ..writeByte(2)
      ..write(obj.tNote)
      ..writeByte(3)
      ..write(obj.tPaymentMode)
      ..writeByte(4)
      ..write(obj.tAmount)
      ..writeByte(5)
      ..write(obj.tCategory)
      ..writeByte(6)
      ..write(obj.tSubcategory)
      ..writeByte(7)
      ..write(obj.tSubcategoryIndex)
      ..writeByte(8)
      ..write(obj.tDateTime)
      ..writeByte(9)
      ..write(obj.tCreatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
