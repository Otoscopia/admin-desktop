import 'package:flutter/material.dart' as m3;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';

class MyAccess extends ConsumerWidget {
  const MyAccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAssignmentCount = 1;
    final deniedPermission = 0;
    return ScaffoldPage.scrollable(
      padding: EdgeInsets.all(Sizes.p24),
      children: [
        Text("My Access").titleSmallBold,
        gap12,
        Text("Role assignment ($roleAssignmentCount)"),
        gap12,
        ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.p12),
          child: m3.Material(
            child: m3.DataTable(
              columns: [
                m3.DataColumn(label: Text("Role")),
                m3.DataColumn(label: Text("Description")),
                m3.DataColumn(label: Text("Group Assignment")),
                m3.DataColumn(label: Text("Conditions")),
              ],
              rows: [
                m3.DataRow(
                  cells: [
                    m3.DataCell(Text("IAM Administrator")),
                    m3.DataCell(
                      Text("Manage user access to Otoscopia resources"),
                    ),
                    m3.DataCell(Text("N/A")),
                    m3.DataCell(Text("None")),
                  ],
                ),
              ],
            ),
          ),
        ),
        gap12,
        Text("Denied Permission ($deniedPermission)"),
        gap12,
        ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.p12),
          child: m3.Material(
            child: m3.DataTable(
              columns: [
                m3.DataColumn(label: Text("Role")),
                m3.DataColumn(label: Text("Description")),
                m3.DataColumn(label: Text("Group Assignment")),
                m3.DataColumn(label: Text("Conditions")),
              ],
              rows: [
                m3.DataRow(
                  cells: [
                    m3.DataCell(Text("-")),
                    m3.DataCell(Text("-")),
                    m3.DataCell(Text("-")),
                    m3.DataCell(Text("-")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
