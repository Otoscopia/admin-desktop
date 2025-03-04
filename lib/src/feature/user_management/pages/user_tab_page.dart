import 'package:flutter/material.dart' as m3;

import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:admin/src/core/index.dart';

class UserTabPage extends ConsumerStatefulWidget {
  const UserTabPage({super.key, required this.onUserTabPressed});
  final Function({
    required String name,
    required String uid,
  }) onUserTabPressed;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserTabPageState();
}

class _UserTabPageState extends ConsumerState<UserTabPage> {
  late final UserDataSource source;
  int rowsPerPage = 15;

  @override
  void initState() {
    super.initState();
    source = UserDataSource(onUserTabPressed: widget.onUserTabPressed);
  }

  static final List<DataColumn2> columns = [
    DataColumn2(label: Text('Name')),
    DataColumn2(label: Text('Role'), size: ColumnSize.M),
    DataColumn2(label: Text('Created At')),
    DataColumn2(label: Text('Status')),
  ];

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      columns: columns,
      source: source,
      wrapInCard: true,
      rowsPerPage: rowsPerPage,
      availableRowsPerPage: [5, 10, 15, 25, 50],
      onRowsPerPageChanged: (value) {
        if (value != null) {
          setState(() {
            rowsPerPage = value;
          });
        }
      },
    );
  }
}

class UserDataSource extends m3.DataTableSource {
  final Function({required String name, required String uid}) onUserTabPressed;

  UserDataSource({required this.onUserTabPressed});

  @override
  DataRow2 getRow(int index) {
    final date = DateFormat('MMM. dd, yyyy, HH:mm').format(DateTime.now());
    return DataRow2.byIndex(
      index: index,
      cells: [
        m3.DataCell(Text('John Doe')),
        m3.DataCell(Text('Admin')),
        m3.DataCell(Text(date)),
        m3.DataCell(StatusPill(Status.deactivated)),
      ],
      onTap: () {
        onUserTabPressed(
          name: 'John Doe', // Replace with actual user name
          uid: 'user_$index', // Replace with actual user ID
        );
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => 15;

  @override
  int get selectedRowCount => 0;
}
