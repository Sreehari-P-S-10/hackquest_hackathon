// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'app_stats_model.dart';

class AppStatsModelAdapter extends TypeAdapter<AppStatsModel> {
  @override
  final int typeId = 11;

  @override
  AppStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppStatsModel(
      goalsCompleted: fields[0] as int,
      streakRestarts: fields[1] as int,
      chatMessagesSent: fields[2] as int,
      moodCheckins: fields[3] as int,
      breathworkSessions: fields[4] as int,
      cravingJournalEntries: fields[5] as int,
      soundscapesPlayed: fields[6] as int,
      quotesLiked: fields[7] as int,
      hopeWallPosts: fields[8] as int,
      storiesRead: fields[9] as int,
      centreCallsMade: fields[10] as int,
      eventsJoined: fields[11] as int,
      resourcesViewed: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AppStatsModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.goalsCompleted)
      ..writeByte(1)
      ..write(obj.streakRestarts)
      ..writeByte(2)
      ..write(obj.chatMessagesSent)
      ..writeByte(3)
      ..write(obj.moodCheckins)
      ..writeByte(4)
      ..write(obj.breathworkSessions)
      ..writeByte(5)
      ..write(obj.cravingJournalEntries)
      ..writeByte(6)
      ..write(obj.soundscapesPlayed)
      ..writeByte(7)
      ..write(obj.quotesLiked)
      ..writeByte(8)
      ..write(obj.hopeWallPosts)
      ..writeByte(9)
      ..write(obj.storiesRead)
      ..writeByte(10)
      ..write(obj.centreCallsMade)
      ..writeByte(11)
      ..write(obj.eventsJoined)
      ..writeByte(12)
      ..write(obj.resourcesViewed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppStatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
