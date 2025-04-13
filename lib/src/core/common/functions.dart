import 'package:admin/src/core/index.dart';

String get databaseId => collectionIds['database'];

String getCollectionId(String name) {
  return List.from(
    collectionIds['collections'],
  ).firstWhere((e) => e['name'] == name)['id'];
}

String getFunctionId(String name) {
  return List.from(
    functionIds['functions'],
  ).firstWhere((e) => e['name'] == name)['id'];
}

Status getStatus(String status) {
  return Status.values.firstWhere((e) => e.name == status);
}
