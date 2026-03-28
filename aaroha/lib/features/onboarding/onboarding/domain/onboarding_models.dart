// lib/features/onboarding/domain/onboarding_models.dart

enum UserType { privateUser, familyMember, supportCommunity }

enum SupportFor { self, someoneElse }

class PrivateUserData {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String location;
  final String password;
  final SupportFor supportFor;
  final List<String> areasOfConcern;

  PrivateUserData({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.location,
    required this.password,
    required this.supportFor,
    required this.areasOfConcern,
  });
}

class FamilyMemberData {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String location;
  final String password;
  final String relationship;
  final String notes;

  FamilyMemberData({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.location,
    required this.password,
    required this.relationship,
    required this.notes,
  });
}

class SupportCommunityData {
  final String organizationName;
  final String orgType;
  final String address;
  final String contactNumber;
  final String email;
  final String password;
  final List<String> servicesProvided;

  SupportCommunityData({
    required this.organizationName,
    required this.orgType,
    required this.address,
    required this.contactNumber,
    required this.email,
    required this.password,
    required this.servicesProvided,
  });
}

class AwarenessProgram {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final String contactInfo;

  AwarenessProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.contactInfo,
  });
}
