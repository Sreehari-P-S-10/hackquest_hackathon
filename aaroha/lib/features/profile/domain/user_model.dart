import 'package:hive/hive.dart';

part 'user_model.g.dart';

/// Stores the local user profile — name, substance being tracked, and
/// the type of support role they selected during onboarding.
@HiveType(typeId: 10)
class UserModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String quitting; // e.g. 'Alcohol'

  @HiveField(2)
  String userType; // 'privateUser' | 'familyMember' | 'supportCommunity'

  @HiveField(3)
  DateTime soberStartDate;

  @HiveField(4)
  String morningCheckIn; // '08:00'

  @HiveField(5)
  String eveningCheckIn; // '20:00'

  @HiveField(6)
  List<String> improvementGoals;

  @HiveField(7)
  String sobrietyImportance;

  UserModel({
    required this.name,
    required this.quitting,
    required this.userType,
    required this.soberStartDate,
    this.morningCheckIn = '08:00',
    this.eveningCheckIn = '20:00',
    List<String>? improvementGoals,
    this.sobrietyImportance = 'Very',
  }) : improvementGoals = improvementGoals ?? [];
}
