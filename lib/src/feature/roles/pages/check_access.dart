import 'package:flutter/material.dart' as m3;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/roles/provider/check_user_access_provider.dart';
import 'package:admin/src/feature/roles/provider/fetch_users_provider.dart';

class CheckAccess extends ConsumerStatefulWidget {
  const CheckAccess({super.key});

  @override
  ConsumerState<CheckAccess> createState() => _CheckAccessState();
}

class _CheckAccessState extends ConsumerState<CheckAccess> {
  bool search = false;
  String searchUser = '';
  String searchUserName = '';
  final deniedPermission = 0;
  final controller = TextEditingController();

  loadingFn() {
    return ScaffoldPage(content: Center(child: ProgressBar()));
  }

  errorFn(error, stackTrace) {
    return ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Something went wrong: ${error.toString()}"),
            gap16,
            FilledButton(child: Text("Retry"), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(fetchUsersProvider);

    return users.when(
      data: (data) {
        final users = List.from(data['users']);

        final items =
            users.map((u) {
              final value = u['id'] as String;
              final label = u['name'] as String;
              return AutoSuggestBoxItem(value: value, label: label);
            }).toList();

        return ScaffoldPage.scrollable(
          children: [
            Text("Check Access").titleSmallBold,
            gap24,
            SizedBox(
              width: 330,
              child: AutoSuggestBox(
                placeholder: "Search by name",
                items: items,
                onSelected: (value) {
                  if (value.value != null) {
                    setState(() {
                      search = true;
                      searchUser = value.value!;
                      searchUserName = value.label;
                    });
                  }
                },
              ),
            ),
            gap24,
            if (search)
              ref
                  .watch(FetchRoleProvider(searchUser))
                  .when(
                    data: (data) {
                      final role = data['user']['role'];
                      final roleName = role['key'] as String;
                      final permissions = List.from(role['permissions']);

                      final permissionTypes = [
                        {'type': 'read', 'label': 'Read Permission'},
                        {'type': 'create', 'label': 'Write Permission'},
                        {'type': 'update', 'label': 'Update Permission'},
                        {'type': 'delete', 'label': 'Delete Permission'},
                      ];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${roleName.uppercaseFirst()} - $searchUserName",
                          ).titleSmallBold,
                          gap12,
                          ...permissionTypes.map((permType) {
                            final permList =
                                permissions
                                    .where((p) => p['type'] == permType['type'])
                                    .toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expander(
                                  header: Text(
                                    "${permType['label']} (${permList.length})",
                                  ),
                                  content: m3.Material(
                                    child: m3.DataTable(
                                      columns: [
                                        m3.DataColumn(label: Text("Name")),
                                        m3.DataColumn(
                                          label: Text("Description"),
                                        ),
                                      ],
                                      rows:
                                          permList.map((e) {
                                            return m3.DataRow(
                                              cells: [
                                                m3.DataCell(Text(e['name'])),
                                                m3.DataCell(
                                                  Text(e['description']),
                                                ),
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
                    error:
                        (error, stackTrace) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Something went wrong: ${error.toString()}"),
                              gap16,
                              FilledButton(
                                child: Text("Retry"),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                    loading: () => Center(child: ProgressBar()),
                  ),
          ],
        );
      },
      error: (error, stackTrace) => errorFn(error, stackTrace),
      loading: () => loadingFn(),
    );
  }
}
