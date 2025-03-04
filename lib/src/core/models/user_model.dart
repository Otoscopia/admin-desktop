import 'package:isar/isar.dart';

import 'package:admin/src/core/index.dart';

part 'user_model.g.dart';

@collection
@Name('users')
class UserModel {
  late int id;
  final String uid;
  final String name;
  final Role role;
  final Status status;
  final String emailAdress;
  final String workAddress;
  final String contactNumber;
  final DateTime createdAt;
  final bool mfaEnabled;
  final bool isVerified;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final DateTime lastPasswordUpdated;
  final DateTime passwordExpiration;
  final String? session;

  UserModel({
    required this.uid,
    required this.name,
    required this.role,
    required this.status,
    required this.emailAdress,
    required this.workAddress,
    required this.contactNumber,
    required this.createdAt,
    required this.mfaEnabled,
    required this.isVerified,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.lastPasswordUpdated,
    required this.passwordExpiration,
    this.session,
  });

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      uid: user.uid,
      name: user.name,
      role: user.role,
      status: user.status,
      emailAdress: user.emailAdress,
      workAddress: user.workAddress,
      contactNumber: user.contactNumber,
      createdAt: user.createdAt,
      mfaEnabled: user.mfaEnabled,
      isVerified: user.isVerified,
      isPhoneVerified: user.isPhoneVerified,
      isEmailVerified: user.isEmailVerified,
      lastPasswordUpdated: user.lastPasswordUpdated,
      passwordExpiration: user.passwordExpiration,
      session: user.session,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      name: name,
      role: role,
      status: status,
      emailAdress: emailAdress,
      workAddress: workAddress,
      contactNumber: contactNumber,
      createdAt: createdAt,
      mfaEnabled: mfaEnabled,
      isVerified: isVerified,
      isPhoneVerified: isPhoneVerified,
      isEmailVerified: isEmailVerified,
      lastPasswordUpdated: lastPasswordUpdated,
      passwordExpiration: passwordExpiration,
      session: session,
    );
  }
}
