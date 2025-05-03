// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appwrite/models.dart';

import 'package:admin/src/core/index.dart';

class UserEntity {
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
  final String roleId;
  final Gender gender;
  final Status activityStatus;
  final Status accountStatus;
  final DateTime createdAt;
  final bool mfaEnabled;
  final bool isVerified;
  final DateTime? passwordExpiration;
  final Map<String, dynamic> collectionIds;
  final Map<String, dynamic> functionIds;
  final Map<String, dynamic> storageIds;
  final Map<String, dynamic> eventIds;
  final DateTime? deactivationTime;
  final String? session;
  final String? location;
  final String? ip;

  UserEntity({
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
    required this.roleId,
    required this.gender,
    required this.activityStatus,
    required this.accountStatus,
    required this.createdAt,
    required this.mfaEnabled,
    required this.isVerified,
    required this.collectionIds,
    required this.functionIds,
    required this.storageIds,
    required this.eventIds,
    this.session,
    this.location,
    this.ip,
    this.deactivationTime,
    this.passwordExpiration,
  });

  UserEntity copyWith({
    String? uid,
    String? readableName,
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? contactNumber,
    String? workAddress,
    bool? isPhoneVerified,
    bool? isEmailVerified,
    DateTime? lastPasswordUpdated,
    Role? role,
    String? roleId,
    Gender? gender,
    Status? activityStatus,
    Status? accountStatus,
    DateTime? createdAt,
    bool? mfaEnabled,
    bool? isVerified,
    DateTime? passwordExpiration,
    Map<String, dynamic>? collectionIds,
    Map<String, dynamic>? functionIds,
    Map<String, dynamic>? storageIds,
    Map<String, dynamic>? eventIds,
    String? session,
    String? location,
    String? ip,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      readableName: readableName ?? this.readableName,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      contactNumber: contactNumber ?? this.contactNumber,
      workAddress: workAddress ?? this.workAddress,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      lastPasswordUpdated: lastPasswordUpdated ?? this.lastPasswordUpdated,
      role: role ?? this.role,
      roleId: roleId ?? this.roleId,
      gender: gender ?? this.gender,
      activityStatus: activityStatus ?? this.activityStatus,
      accountStatus: accountStatus ?? this.accountStatus,
      createdAt: createdAt ?? this.createdAt,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      isVerified: isVerified ?? this.isVerified,
      passwordExpiration: passwordExpiration ?? this.passwordExpiration,
      collectionIds: collectionIds ?? this.collectionIds,
      functionIds: functionIds ?? this.functionIds,
      eventIds: eventIds ?? this.eventIds,
      storageIds: storageIds ?? this.storageIds,
      session: session ?? this.session,
      location: location ?? this.location,
      ip: ip ?? this.ip,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'readable_name': readableName,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'email': email,
      'contact_number': contactNumber,
      'work_address': workAddress,
      'is_phone_verified': isPhoneVerified,
      'is_email_verified': isEmailVerified,
      'last_password_updated': lastPasswordUpdated.millisecondsSinceEpoch,
      'role': role.name,
      'gender': gender.name,
      'activity_status': activityStatus.name,
      'account_status': accountStatus.name,
      'mfa_enabled': mfaEnabled,
      'is_verified': isVerified,
      'password_expiration': passwordExpiration?.millisecondsSinceEpoch,
      'session': session,
      'deactivated_time': deactivationTime,
    };
  }

  factory UserEntity.fromAppwrite({
    required Document user,
    required Session session,
    required Map<String, dynamic> collectionIds,
    required Map<String, dynamic> functionIds,
    required Map<String, dynamic> storageIds,
    required Map<String, dynamic> eventIds,
  }) {
    Map<String, dynamic> data = user.data;
    final role = data['role']['key'];
    final gender = data['gender']['name'];
    final activityStatus = data['activity_status']['status']['name'];
    final accountStatus = data['account_status']['status']['name'];
    final deactivationTime = data['account_status']['deactivation'];

    return UserEntity(
      uid: data['\$id'],
      readableName: user.data['readable_name'],
      firstName: user.data['first_name'],
      middleName: user.data['middle_name'],
      lastName: user.data['last_name'],
      email: user.data['email'],
      contactNumber: data['contact_number'],
      workAddress: data['work_address'],
      role: Role.values.firstWhere((r) => r.name.contains(role)),
      roleId: data['role']['\$id'],
      gender: Gender.values.firstWhere((g) => g.name.contains(gender)),
      mfaEnabled: data['mfa_enabled'],
      isVerified: data['is_verified'],
      isPhoneVerified: data['is_phone_verified'],
      isEmailVerified: data['is_email_verified'],
      lastPasswordUpdated: DateTime.parse(data['last_password_updated']),
      activityStatus: Status.values.firstWhere(
        (s) => s.name.contains(activityStatus),
      ),
      accountStatus: Status.values.firstWhere(
        (status) => status.name.contains(accountStatus),
      ),
      createdAt: DateTime.parse(user.$createdAt),
      passwordExpiration: null, // ! Update Password Expiration
      collectionIds: collectionIds,
      functionIds: functionIds,
      storageIds: storageIds,
      eventIds: eventIds,
      session: session.$id,
      location: session.countryName,
      ip: session.ip,
      deactivationTime:
          deactivationTime != null ? DateTime.tryParse(deactivationTime) : null,
    );
  }

  String toJson() => json.encode(toMap());
}
