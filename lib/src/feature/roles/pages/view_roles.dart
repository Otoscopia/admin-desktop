import 'package:flutter/material.dart' as m3;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/roles/provider/fetch_team_roles.dart';

class ViewRoles extends ConsumerStatefulWidget {
  const ViewRoles({super.key});

  @override
  ConsumerState<ViewRoles> createState() => _ViewRolesState();
}

class _ViewRolesState extends ConsumerState<ViewRoles> {
  // Instead of a single boolean, we'll keep track of which item is being viewed
  String? selectedItemId;
  List<dynamic> permissions = [];

  @override
  Widget build(BuildContext context) {
    final teamsRoles = ref.watch(fetchTeamsRolesProvider);

    return teamsRoles.when(
      data: (data) {
        final roles = List.from(data['roles']);
        final teams = List.from(data['teams']);

        final merge = [...roles, ...teams];

        return ScaffoldPage.scrollable(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.p12),
              child: m3.Material(
                child: m3.DataTable(
                  columns: const [
                    m3.DataColumn(label: Text("Role/Team")),
                    m3.DataColumn(label: Text("Description")),
                    m3.DataColumn(label: Text("Details")),
                  ],
                  rows:
                      merge.map((e) {
                        final String name = e['name'] ?? e['key'];
                        // Generate a unique ID for each row
                        final itemId = e['key'] ?? e['id'] ?? name;
                        final isSelected = selectedItemId == itemId;

                        return m3.DataRow(
                          cells: [
                            m3.DataCell(Text(name.uppercaseFirst())),
                            m3.DataCell(Text(e['description'])),
                            m3.DataCell(
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  child: Text(isSelected ? "Close" : "View"),
                                  onTap:
                                      () => setState(() {
                                        if (isSelected) {
                                          // If this row is already selected, clear the selection
                                          selectedItemId = null;
                                          permissions = [];
                                        } else {
                                          // Otherwise, select this row and load its permissions
                                          selectedItemId = itemId;

                                          if (e['key'] != null) {
                                            // It's a role
                                            final perms = List.from(
                                              e['permissions'],
                                            );
                                            permissions = perms;
                                          } else {
                                            // It's a team
                                            final members = List.from(
                                              e['members'],
                                            );
                                            if (members.isEmpty) {
                                              permissions = [];
                                              return;
                                            }

                                            final role =
                                                members.first['role']['key']
                                                    as String;
                                            final filter = roles.firstWhere((
                                              r,
                                            ) {
                                              final key = r['key'] as String;
                                              return key == role;
                                            });

                                            permissions = filter['permissions'];
                                          }
                                        }
                                      }),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
            gap24,
            if (selectedItemId != null)
              ...permissionTypes.map((permType) {
                final permList =
                    permissions
                        .where((p) => p['type'] == permType['type'])
                        .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expander(
                      header: Text("${permType['label']} (${permList.length})"),
                      content: m3.Material(
                        child: m3.DataTable(
                          columns: const [
                            m3.DataColumn(label: Text("Name")),
                            m3.DataColumn(label: Text("Description")),
                          ],
                          rows:
                              permList.map((e) {
                                return m3.DataRow(
                                  cells: [
                                    m3.DataCell(Text(e['name'])),
                                    m3.DataCell(Text(e['description'])),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    if (permType['type'] != 'delete') gap24,
                  ],
                );
              }),
          ],
        );
      },
      error: (error, stackTrace) {
        return ErrorPage(erorrMessage: error.toString());
      },
      loading: () => const LoadingPage(),
    );
  }
}
