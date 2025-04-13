import 'package:flutter/material.dart' as m3;

import 'package:appwrite/appwrite.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:admin/src/core/index.dart';

class MainLogs extends ConsumerStatefulWidget {
  const MainLogs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainLogsState();
}

class _MainLogsState extends ConsumerState<MainLogs> {
  final source = HistoryLogsSource();
  int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: AsyncPaginatedDataTable2(
        source: source,
        minWidth: 2000,
        rowsPerPage: _rowsPerPage,
        availableRowsPerPage: const [5, 10, 20, 50],
        columns: [
          DataColumn2(label: Text('User ID'), size: ColumnSize.L),
          DataColumn2(label: Text('Name'), size: ColumnSize.L),
          DataColumn2(label: Text('Email'), size: ColumnSize.L),
          DataColumn2(label: Text('Role'), size: ColumnSize.S),
          DataColumn2(label: Text('Activity'), size: ColumnSize.L),
          DataColumn2(label: Text('Date')),
          DataColumn2(label: Text('Time')),
          DataColumn2(label: Text('Resource')),
          DataColumn2(label: Text('Device')),
          DataColumn2(label: Text('Location')),
        ],
        onRowsPerPageChanged: (value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _rowsPerPage = value!;
            });
          });
        },
        loading: Center(child: ProgressBar()),
        empty: Center(child: Text('No data found')),
        errorBuilder:
            (e) => Center(
              child: Text(
                'Error: ${e.toString()}',
                style: TextStyle(color: Colors.red),
              ),
            ),
      ),
    );
  }
}

class HistoryLogsSource extends AsyncDataTableSource {
  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    try {
      final response = await database.listDocuments(
        databaseId: databaseId,
        collectionId: getCollectionId('logs'),
        queries: [Query.offset(startIndex), Query.limit(count)],
      );

      final total = response.total;
      final rows =
          response.documents.map((f) {
            final d = f.data;
            final createdAt = DateFormat(
              "YYYY-MM-DD",
            ).format(DateTime.parse(f.$createdAt));
            final time = DateFormat(
              "HH:MM",
            ).format(DateTime.parse(f.$createdAt));
            return DataRow2(
              cells: [
                m3.DataCell(Text(d['user']['\$id'])),
                m3.DataCell(Text(d['user']['readable_name'])),
                m3.DataCell(Text(d['user']['email'])),
                m3.DataCell(Text(d['user']['role']['key'])),
                m3.DataCell(Text(d['event'])),
                m3.DataCell(Text(createdAt)),
                m3.DataCell(Text(time)),
                m3.DataCell(Text(d['resource'] ?? '')),
                m3.DataCell(Text(d['device'])),
                m3.DataCell(Text(d['location'])),
              ],
            );
          }).toList();

      return AsyncRowsResponse(total, rows);
    } on AppwriteException catch (e) {
      logger.error("Something went wrong ${e.message}");
      return AsyncRowsResponse(0, []);
    }
  }
}
