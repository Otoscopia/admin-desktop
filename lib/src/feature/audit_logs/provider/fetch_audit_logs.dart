import 'package:admin/src/core/index.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_audit_logs.g.dart';

@riverpod
Future<List<List<Document>>> fetchAuditLogs(Ref ref) async {
  final roles = await database.listDocuments(
    databaseId: databaseId,
    collectionId: getCollectionId('roles'),
  );

  final events = await database.listDocuments(
    databaseId: databaseId,
    collectionId: getCollectionId('events'),
  );

  return [roles.documents, events.documents];
}