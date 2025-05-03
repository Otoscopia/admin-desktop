// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/models.dart';

class UserAuthConfigEntity {
  final String id;
  final Document configuration;
  final DocumentList passwordExpiration;
  final DocumentList passwordGracePeriod;
  final DocumentList idleSessionTimeout;

  UserAuthConfigEntity({
    required this.id,
    required this.configuration,
    required this.passwordExpiration,
    required this.passwordGracePeriod,
    required this.idleSessionTimeout,
  });

  UserAuthConfigEntity copyWith({
    String? id,
    Document? configuration,
    DocumentList? passwordExpiration,
    DocumentList? passwordGracePeriod,
    DocumentList? idleSessionTimeout,
  }) {
    return UserAuthConfigEntity(
      id: id ?? this.id,
      configuration: configuration ?? this.configuration,
      passwordExpiration: passwordExpiration ?? this.passwordExpiration,
      passwordGracePeriod: passwordGracePeriod ?? this.passwordGracePeriod,
      idleSessionTimeout: idleSessionTimeout ?? this.idleSessionTimeout,
    );
  }
}
