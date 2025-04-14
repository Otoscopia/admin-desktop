import 'package:flutter/material.dart' as m3;

import 'package:appwrite/appwrite.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

import 'package:admin/src/core/index.dart';

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
