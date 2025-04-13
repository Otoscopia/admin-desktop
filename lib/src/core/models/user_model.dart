import 'dart:convert';

import 'package:isar/isar.dart';

import 'package:admin/src/core/index.dart';

part 'user_model.g.dart';

@collection
@Name('users')
class UserModel {
  late int id;
  final String uid;
  final String readableName;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String workAddress;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final DateTime lastPasswordUpdated;
  final Role role;
  final Gender gender;
  final Status activityStatus;
  final Status accountStatus;
  final DateTime createdAt;
  final bool mfaEnabled;
  final bool isVerified;
  final DateTime? passwordExpiration;
  final String collectionIds;
  final String functionIds;
  final String storageIds;
  final String? session;
  final String? ip;
  final String? location;

  UserModel({
    required this.uid,
    required this.readableName,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.workAddress,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.lastPasswordUpdated,
    required this.role,
    required this.gender,
    required this.activityStatus,
    required this.accountStatus,
    required this.createdAt,
    required this.mfaEnabled,
    required this.isVerified,
    this.passwordExpiration,
    required this.collectionIds,
    required this.functionIds,
    required this.storageIds,
    this.session,
    this.ip,
    this.location,
  });

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      uid: user.uid,
      readableName: user.readableName,
      firstName: user.firstName,
      middleName: user.middleName,
      lastName: user.lastName,
      email: user.email,
      contactNumber: user.contactNumber,
      workAddress: user.workAddress,
      isPhoneVerified: user.isPhoneVerified,
      isEmailVerified: user.isEmailVerified,
      lastPasswordUpdated: user.lastPasswordUpdated,
      role: user.role,
      gender: user.gender,
      activityStatus: user.activityStatus,
      accountStatus: user.accountStatus,
      createdAt: user.createdAt,
      mfaEnabled: user.mfaEnabled,
      isVerified: user.isVerified,
      passwordExpiration: user.passwordExpiration,
      collectionIds: json.encode(user.collectionIds),
      functionIds: json.encode(user.functionIds),
      storageIds: json.encode(user.storageIds),
      session: user.session,
      ip: user.ip,
      location: user.location,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      readableName: readableName,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      email: email,
      contactNumber: contactNumber,
      workAddress: workAddress,
      isPhoneVerified: isPhoneVerified,
      isEmailVerified: isEmailVerified,
      lastPasswordUpdated: lastPasswordUpdated,
      role: role,
      gender: gender,
      activityStatus: activityStatus,
      accountStatus: accountStatus,
      createdAt: createdAt,
      mfaEnabled: mfaEnabled,
      isVerified: isVerified,
      passwordExpiration: passwordExpiration,
      collectionIds: json.decode(collectionIds),
      functionIds: json.decode(functionIds),
      storageIds: json.decode(storageIds),
      session: session,
      ip: ip,
      location: location,
    );
  }
}
