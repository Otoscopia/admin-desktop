import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';

part 'fetch_users_provider.g.dart';

@Riverpod()
FutureOr<Map<String, dynamic>> fetchUsers(Ref ref) async {
  final auth = ref.read(authenticationProvider);
  final response = await functions.createExecution(
    functionId: getFunctionId('fetch-users'),
    body: auth.logDetails('fetch-users'),
  );

  return json.decode(response.responseBody);
}
