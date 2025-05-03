import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';

part 'user_account_status_provider.g.dart';

@Riverpod(keepAlive: true)
class UserAccStatus extends _$UserAccStatus {
  @override
  FutureOr<AccountStatusEntity> build(String id) async {
    return await fetchDetails(id);
  }

  Future<AccountStatusEntity> fetchDetails(String id) async {
    final fetchUser = database.getDocument(
      databaseId: databaseId,
      collectionId: getCollectionId('users'),
      documentId: id,
    );

    final fetchLogs = database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('logs'),
      queries: [Query.equal('user', id)],
    );

    final response = await Future.wait([fetchUser, fetchLogs]);

    return convertedData(response);
  }

  AccountStatusEntity convertedData(List<Model> data) {
    final user = data[0] as Document;
    final logs = data[1] as DocumentList;

    final accountStatus = user.data['account_status'];
    final String? activationDate = accountStatus['activation_date'];
    final String? deactivationDate = accountStatus['deactivation_date'];

    return AccountStatusEntity(
      user: user,
      logs: logs,
      activateImmediately: false,
      activationDate:
          activationDate != null ? DateTime.parse(activationDate) : null,
      deactivateImmediately: false,
      deactivationDate:
          deactivationDate != null ? DateTime.parse(deactivationDate) : null,
    );
  }

  Future<void> saveData(Map<dynamic, dynamic> body) async {
    state = const AsyncLoading();
    await functions.createExecution(
      functionId: getFunctionId('user-account-status'),
      body: json.encode(body),
      method: ExecutionMethod.pOST,
    );

    final data = await build(body['id']);

    state = AsyncData(data);
  }

  void updateAccountStatus({
    DateTime? activationDate,
    DateTime? deactivationDate,
    bool? activateImmediately,
    bool? deactivateImmediately,
  }) {
    if (!state.hasValue) return;

    final current = state.value!;

    final updated = AccountStatusEntity(
      user: current.user,
      logs: current.logs,
      activationDate: activationDate ?? current.activationDate,
      deactivationDate: deactivationDate ?? current.deactivationDate,
      activateImmediately: activateImmediately ?? current.activateImmediately,
      deactivateImmediately:
          deactivateImmediately ?? current.deactivateImmediately,
    );

    state = AsyncData(updated);

    logger.info("User account status updated: ${updated.toMap()}");
  }
}
