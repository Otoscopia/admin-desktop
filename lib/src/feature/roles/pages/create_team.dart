import 'package:flutter/material.dart' as m3;

import 'package:appwrite/appwrite.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';

class CreateTeam extends ConsumerStatefulWidget {
  const CreateTeam({super.key});

  @override
  ConsumerState<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends ConsumerState<CreateTeam> {
  final source = TeamMemberSource();
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: Sizes.p8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Team Name").titleSmallBold,
                SizedBox(width: 400, child: TextBox(placeholder: 'Team')),
              ],
            ),
            Column(
              spacing: Sizes.p8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Team Description").titleSmallBold,
                SizedBox(width: 400, child: TextBox(placeholder: 'Team')),
              ],
            ),
          ],
        ),
        gap16,
        Text("Select Role Assignment").titleSmallBold,
        gap8,
        ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.p12),
          child: m3.Material(
            child: m3.DataTable(
              showCheckboxColumn: true,
              columns: [
                m3.DataColumn(label: Text("Role")),
                m3.DataColumn(label: Text("Description")),
                m3.DataColumn(label: Text("Type")),
              ],
              rows: [
                m3.DataRow(
                  cells: [
                    m3.DataCell(Text("IAM Administrator")),
                    m3.DataCell(
                      Text(
                        "Can view, create, and update selected resources, but doesn't allow you to del...",
                      ),
                    ),
                    m3.DataCell(Text("Built-in-Role")),
                  ],
                  onSelectChanged: (value) {},
                ),
                m3.DataRow(
                  cells: [
                    m3.DataCell(Text("Nurse")),
                    m3.DataCell(
                      Text(
                        "Can view, create, and update selected resources, but doesn't allow you to del...",
                      ),
                    ),
                    m3.DataCell(Text("Built-in-Role")),
                  ],
                  onSelectChanged: (value) {},
                ),
                m3.DataRow(
                  cells: [
                    m3.DataCell(Text("Doctor")),
                    m3.DataCell(
                      Text(
                        "Can view, create, and update selected resources, but doesn't allow you to del...",
                      ),
                    ),
                    m3.DataCell(Text("Built-in-Role")),
                  ],
                  onSelectChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
        gap16,
        Text("Select Team Member"),
        Row(
          children: [
            SizedBox(width: 330, child: TextBox(placeholder: "Search by Name")),
            SizedBox(
              height: 300,
              width: 500,
              child: AsyncPaginatedDataTable2(
                columns: [
                  DataColumn2(label: Text("Name")),
                  DataColumn2(label: Text("Email")),
                  DataColumn2(label: Text("Role")),
                ],
                source: source,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TeamMemberSource extends AsyncDataTableSource {
  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    try {
      final response = await database.listDocuments(
        databaseId: databaseId,
        collectionId: getCollectionId('users'),
        queries: [Query.offset(startIndex), Query.limit(count)],
      );

      final total = response.total;
      final rows =
          response.documents.map((f) {
            final d = f.data;
            return DataRow2(
              cells: [
                m3.DataCell(Text(d['user']['readable_name'])),
                m3.DataCell(Text(d['user']['email'])),
                m3.DataCell(Text(d['user']['role']['key'])),
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
