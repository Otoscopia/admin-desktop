// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appwrite/models.dart';

import 'package:admin/src/core/index.dart';

class UserEntity {
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

  UserEntity({
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

  UserEntity copyWith({
    String? uid,
    String? name,
    Role? role,
    Status? status,
    String? emailAdress,
    String? workAddress,
    String? contactNumber,
    DateTime? createdAt,
    bool? mfaEnabled,
    bool? isVerified,
    bool? isPhoneVerified,
    bool? isEmailVerified,
    DateTime? lastPasswordUpdated,
    DateTime? passwordExpiration,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      role: role ?? this.role,
      status: status ?? this.status,
      emailAdress: emailAdress ?? this.emailAdress,
      workAddress: workAddress ?? this.workAddress,
      contactNumber: contactNumber ?? this.contactNumber,
      createdAt: createdAt ?? this.createdAt,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      isVerified: isVerified ?? this.isVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      lastPasswordUpdated: lastPasswordUpdated ?? this.lastPasswordUpdated,
      passwordExpiration: passwordExpiration ?? this.passwordExpiration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'role': role.name,
      'status': status.name,
      'emailAdress': emailAdress,
      'workAddress': workAddress,
      'contactNumber': contactNumber,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'mfaEnabled': mfaEnabled,
      'isVerified': isVerified,
      'isPhoneVerified': isPhoneVerified,
      'isEmailVerified': isEmailVerified,
      'lastPasswordUpdated': lastPasswordUpdated.millisecondsSinceEpoch,
      'passwordExpiration': passwordExpiration.millisecondsSinceEpoch,
    };
  }

  factory UserEntity.fromUser({
    required Document user,
    required String session,
    required User account,
  }) {
    Map<String, dynamic> data = user.data;
    Role role = account.labels
        .map((e) => Role.values.firstWhere((role) => role.name.contains(e)))
        .first;

    return UserEntity(
      uid: user.$id,
      name: account.name,
      role: role,
      status: Status.online, // ! Update Status
      emailAdress: account.email,
      workAddress: "Secret",
      contactNumber: data['phone'],
      createdAt: DateTime.parse(account.$createdAt),
      mfaEnabled: account.mfa,
      isEmailVerified: account.emailVerification,
      isPhoneVerified: account.phoneVerification,
      isVerified: account.emailVerification && account.phoneVerification,
      lastPasswordUpdated: DateTime.parse(account.passwordUpdate),
      passwordExpiration: DateTime.now(), // ! Update Password Expiration
      session: session,
    );
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uid: map['uid'] as String,
      name: map['name'] as String,
      role: Role.values.firstWhere((role) => role.name.contains(map['role'])),
      status: Status.values
          .firstWhere((status) => status.name.contains(map['status'])),
      emailAdress: map['emailAdress'] as String,
      workAddress: map['workAddress'] as String,
      contactNumber: map['contactNumber'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      mfaEnabled: map['mfaEnabled'] as bool,
      isVerified: map['isVerified'] as bool,
      isPhoneVerified: map['isPhoneVerified'] as bool,
      isEmailVerified: map['isEmailVerified'] as bool,
      lastPasswordUpdated: DateTime.fromMillisecondsSinceEpoch(
          map['lastPasswordUpdated'] as int),
      passwordExpiration:
          DateTime.fromMillisecondsSinceEpoch(map['passwordExpiration'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) =>
      UserEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserEntity(uid: $uid, name: $name, role: $role, status: $status, emailAdress: $emailAdress, workAddress: $workAddress, contactNumber: $contactNumber, createdAt: $createdAt, mfaEnabled: $mfaEnabled, isVerified: $isVerified, isPhoneVerified: $isPhoneVerified, isEmailVerified: $isEmailVerified, lastPasswordUpdated: $lastPasswordUpdated, passwordExpiration: $passwordExpiration)';
  }

  @override
  bool operator ==(covariant UserEntity other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.role == role &&
        other.status == status &&
        other.emailAdress == emailAdress &&
        other.workAddress == workAddress &&
        other.contactNumber == contactNumber &&
        other.createdAt == createdAt &&
        other.mfaEnabled == mfaEnabled &&
        other.isVerified == isVerified &&
        other.isPhoneVerified == isPhoneVerified &&
        other.isEmailVerified == isEmailVerified &&
        other.lastPasswordUpdated == lastPasswordUpdated &&
        other.passwordExpiration == passwordExpiration;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        role.hashCode ^
        status.hashCode ^
        emailAdress.hashCode ^
        workAddress.hashCode ^
        contactNumber.hashCode ^
        createdAt.hashCode ^
        mfaEnabled.hashCode ^
        isVerified.hashCode ^
        isPhoneVerified.hashCode ^
        isEmailVerified.hashCode ^
        lastPasswordUpdated.hashCode ^
        passwordExpiration.hashCode;
  }
}
