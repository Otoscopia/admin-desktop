import 'dart:convert';

import 'package:appwrite/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';

part 'fetch_team_roles.g.dart';

@Riverpod()
FutureOr<Map<String, dynamic>> fetchTeamsRoles(Ref ref) async {
  final auth = ref.read(authenticationProvider).logDetails('fetch-team-roles');
  final response = await functions.createExecution(
    functionId: getFunctionId('fetch-team-roles'),
    body: auth,
    method: ExecutionMethod.gET,
  );

  return json.decode(response.responseBody);
}
