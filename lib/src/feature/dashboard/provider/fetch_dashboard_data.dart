import 'dart:convert';

import 'package:appwrite/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';

part 'fetch_dashboard_data.g.dart';

@Riverpod()
FutureOr<Map<String, dynamic>> dashboard(Ref ref) async {
  final functionId = getFunctionId('dashboard-stats');
  final auth = ref.read(authenticationProvider);

  final response = await functions.createExecution(
    functionId: functionId,
    method: ExecutionMethod.gET,
    body: auth.logDetails('dashboard-stats'),
  );

  return json.decode(response.responseBody);
}
