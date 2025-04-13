import 'dart:convert';

import 'package:flutter/material.dart' as m3;

import 'package:appwrite/enums.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:admin/src/core/index.dart';

class UserTabPage extends ConsumerStatefulWidget {
  const UserTabPage({super.key, required this.onUserTabPressed});
  final Function({required String name, required String uid}) onUserTabPressed;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserTabPageState();
}

class _UserTabPageState extends ConsumerState<UserTabPage> {
  int rowsPerPage = defaultRowsPerPage;
  int offset = 0;
  final controller = PaginatorController();

  Future<Map<String, dynamic>> fetchUsers(String fnBody) async {
    final functionId = getFunctionId('users-account-lifecycle');

    final response = await functions.createExecution(
      functionId: functionId,
      method: ExecutionMethod.gET,
      body: fnBody,
    );

    return json.decode(response.responseBody);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authenticationProvider);

    return FutureBuilder(
      future: fetchUsers(auth.logDetails("User Management")),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: ProgressRing());
        }
        if (snapshot.hasError) {}

        final response = snapshot.data!;

        final source = UserDataSource(
          users: List.castFrom(response['users']),
          onUserTabPressed: widget.onUserTabPressed,
        );

        return PaginatedDataTable2(
          source: source,
          controller: controller,
          rowsPerPage: 20,
          minWidth: 1000,
          columns: [
            DataColumn2(label: Text('Name')),
            DataColumn2(label: Text('Role'), size: ColumnSize.S),
            DataColumn2(label: Text('Created At')),
            DataColumn2(label: Text('Activity Status'), size: ColumnSize.M),
            DataColumn2(label: Text('Account Status'), size: ColumnSize.S),
          ],
        );
      },
    );
  }
}

class UserDataSource extends m3.DataTableSource {
  final List<Map<String, dynamic>> users;
  final Function({required String name, required String uid}) onUserTabPressed;

  UserDataSource({required this.users, required this.onUserTabPressed}) {
    logger.info("User Data Source has been created");
  }

  @override
  DataRow2 getRow(int index) {
    final user = users[index];
    final date = DateTime.parse(user['created_at']);
    final activityStatus = getStatus(user['activity_status']);
    final accountStatus = getStatus(user['account_status']);

    return DataRow2(
      cells: [
        m3.DataCell(Text(user['name'])),
        m3.DataCell(Text((user['role'] as String).uppercaseFirst())),
        m3.DataCell(Text(DateFormat('MMM dd, yyyy HH:MM').format(date))),
        m3.DataCell(StatusPill(activityStatus)),
        m3.DataCell(StatusPill(accountStatus)),
      ],
      onTap: () {
        onUserTabPressed(
          name: user['name'], // Replace with actual user name
          uid: user['id'], // Replace with actual user ID
        );
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
