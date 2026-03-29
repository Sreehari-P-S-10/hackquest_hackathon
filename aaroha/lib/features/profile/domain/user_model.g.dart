// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'user_model.dart';

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 10;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      name: fields[0] as String,
      quitting: fields[1] as String,
      userType: fields[2] as String,
      soberStartDate: fields[3] as DateTime,
      morningCheckIn: fields[4] as String,
      eveningCheckIn: fields[5] as String,
      improvementGoals: (fields[6] as List).cast<String>(),
      sobrietyImportance: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quitting)
      ..writeByte(2)
      ..write(obj.userType)
      ..writeByte(3)
      ..write(obj.soberStartDate)
      ..writeByte(4)
      ..write(obj.morningCheckIn)
      ..writeByte(5)
      ..write(obj.eveningCheckIn)
      ..writeByte(6)
      ..write(obj.improvementGoals)
      ..writeByte(7)
      ..write(obj.sobrietyImportance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
