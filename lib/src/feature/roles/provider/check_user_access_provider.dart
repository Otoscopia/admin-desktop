import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';

part 'check_user_access_provider.g.dart';

@riverpod
FutureOr<Map<String, dynamic>> fetchRole(Ref ref, String id) async {
  final auth = ref.read(authenticationProvider).logDetails('check-user-access');

  final decoded = json.decode(auth) as Map<String, dynamic>;
  final response = await functions.createExecution(
    functionId: getFunctionId('check-user-access'),
    body: json.encode({...decoded, "id": id}),
  );

  return json.decode(response.responseBody);
}
