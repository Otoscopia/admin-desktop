import 'package:flutter/material.dart' as m3;

import 'package:appwrite/appwrite.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

import 'package:admin/src/core/index.dart';

class HistoryLogsSource extends AsyncDataTableSource {
  final List<String>? queries;

  HistoryLogsSource({this.queries});

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    try {
      final mergedQueries = [
        ...?queries,
        Query.offset(startIndex),
        Query.limit(count),
      ];
      logger.info('queries: ${mergedQueries.toString()}');

      final response = await database.listDocuments(
        databaseId: databaseId,
        collectionId: getCollectionId('logs'),
        queries: mergedQueries,
      );

      final total = response.total;
      final rows =
          response.documents.map((f) {
            final d = f.data;
            final createdAt = DateFormat(
              "yyyy-MM-dd",
            ).format(DateTime.parse(f.$createdAt).toLocal());
            final time = DateFormat(
              "HH:MM",
            ).format(DateTime.parse(f.$createdAt).toLocal());

            final event =
                "${d['event']['method']} - ${d['event']['resource']} - ${d['event']['activity']}";
            return DataRow2(
              cells: [
                m3.DataCell(Text(d['user']['\$id'])),
                m3.DataCell(Text(d['user']['readable_name'])),
                m3.DataCell(Text(d['user']['email'])),
                m3.DataCell(Text(d['user']['role']['key'])),
                m3.DataCell(Text(event)),
                m3.DataCell(Text(createdAt)),
                m3.DataCell(Text(time)),
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
