import 'package:flutter/material.dart' as m3;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';

class ViewRoles extends ConsumerStatefulWidget {
  const ViewRoles({super.key});

  @override
  ConsumerState<ViewRoles> createState() => _ViewRolesState();
}

class _ViewRolesState extends ConsumerState<ViewRoles> {
  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      padding: EdgeInsets.all(Sizes.p24),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.p12),
          child: m3.Material(
            child: m3.DataTable(
              columns: [
                m3.DataColumn(label: Text("Role")),
                m3.DataColumn(label: Text("Description")),
                m3.DataColumn(label: Text("Details")),
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
                    m3.DataCell(Text("View")),
                  ],
                ),
                m3.DataRow(
                  cells: [
                    m3.DataCell(Text("Nurse")),
                    m3.DataCell(
                      Text(
                        "Can view, create, and update selected resources, but doesn't allow you to del...",
                      ),
                    ),
                    m3.DataCell(Text("View")),
                  ],
                ),
                m3.DataRow(
                  cells: [
                    m3.DataCell(Text("Doctor")),
                    m3.DataCell(
                      Text(
                        "Can view, create, and update selected resources, but doesn't allow you to del...",
                      ),
                    ),
                    m3.DataCell(
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          child: Text(showDetails ? "Close" : "View"),
                          onTap:
                              () => setState(() {
                                showDetails = !showDetails;
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        gap24,
        if (showDetails)
          Expanded(
            child: Expander(header: Text("Read Permission"), content: Column()),
          ),
        gap24,

        if (showDetails)
          Expanded(
            child: Expander(
              header: Text("Write Permission"),
              content: Column(),
            ),
          ),

        gap24,
        if (showDetails)
          Expanded(
            child: Expander(
              header: Text("Update Permission"),
              content: Column(),
            ),
          ),

        gap24,
        if (showDetails)
          Expanded(
            child: Expander(
              header: Text("Delete Permission"),
              content: Column(),
            ),
          ),
      ],
    );
  }
}
