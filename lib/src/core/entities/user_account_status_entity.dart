import 'package:appwrite/models.dart';

class AccountStatusEntity {
  final Document user;
  final DocumentList logs;
  final DateTime? activationDate;
  final DateTime? deactivationDate;
  final bool? deactivateImmediately;
  final bool? activateImmediately;

  AccountStatusEntity({
    required this.user,
    required this.logs,
    this.activationDate,
    this.deactivationDate,
    this.deactivateImmediately,
    this.activateImmediately,
  });

  AccountStatusEntity copyWith({
    Document? user,
    DocumentList? logs,
    DateTime? activationDate,
    DateTime? deactivationDate,
    bool? deactivateImmediately,
    bool? activateImmediately,
  }) {
    return AccountStatusEntity(
      user: user ?? this.user,
      logs: logs ?? this.logs,
      activationDate: activationDate ?? activationDate,
      deactivationDate: deactivationDate ?? deactivationDate,
      deactivateImmediately: deactivateImmediately ?? deactivateImmediately,
      activateImmediately: activateImmediately ?? activateImmediately,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activation_date': activationDate?.toIso8601String(),
      'deactivation_date': deactivationDate?.toIso8601String(),
      'activateImmediately': activateImmediately,
      'deactivateImmediately': deactivateImmediately,
    };
  }
}
