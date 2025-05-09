import 'package:appwrite/appwrite.dart' as ap;
import 'package:appwrite/models.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/audit_logs/widgets/filter_container.dart';
import 'package:admin/src/feature/audit_logs/widgets/history_log_source.dart';
import 'package:admin/src/feature/roles/provider/fetch_users_provider.dart';

class LogFilter extends ConsumerStatefulWidget {
  final List<Document>? roles;
  final List<Document>? events;

  const LogFilter({super.key, this.roles, this.events});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogFilterState();
}

class _LogFilterState extends ConsumerState<LogFilter> {
  late HistoryLogsSource source;
  String searchUser = '';
  String searchUserName = '';
  DateTime? startDate;
  DateTime? endDate;
  String? userRole;
  String? userActivity;
  DateTime? startTime;
  DateTime? endTime;
  bool isSubmitted = false;

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
            FilterContainer(
              titles: const ['Start Date', 'End Date'],
              widgets: [
                DatePicker(
                  selected: startDate,
                  onChanged: (value) {
                    setState(() {
                      startDate = value;
                    });
                  },
                ),
                DatePicker(
                  selected: endDate,
                  onChanged: (value) {
                    setState(() => endDate = value);
                  },
                ),
              ],
            ),
            gap16,
            FilterContainer(
              titles: const ['User Role ', 'User Activity'],
              widgets: [
                ComboBox(
                  value: userRole,
                  items:
                      widget.roles?.map((e) {
                        final id = e.$id;
                        final role = e.data['key'] as String;
                        return ComboBoxItem(
                          value: id,
                          child: Text(role.uppercaseFirst()),
                        );
                      }).toList(),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      userRole = value;
                    });
                  },
                ),
                ComboBox(
                  value: userActivity,
                  items:
                      widget.events?.map((e) {
                        final id = e.$id;
                        final event = e.data;
                        final method =
                            (event['method'] as String).uppercaseFirst();
                        final resource =
                            (event['resource'] as String).uppercaseFirst();
                        final activity =
                            (event['activity'] as String).uppercaseFirst();
                        return ComboBoxItem(
                          value: id,
                          child: Text("$method - $resource - $activity"),
                        );
                      }).toList(),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      userActivity = value;
                    });
                  },
                ),
                DatePicker(
                  selected: endDate,
                  onChanged: (value) {
                    setState(() {
                      endDate = value;
                    });
                  },
                ),
              ],
            ),
            gap16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Users           '),
                    SizedBox(
                      width: 330,
                      child: AutoSuggestBox(
                        placeholder: "Search by name",
                        items: items,

                        onSelected: (value) {
                          if (value.value != null) {
                            setState(() {
                              searchUser = value.value!;
                              searchUserName = value.label;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                // Row(
                //   spacing: Sizes.p12,
                //   children: [
                //     Text('Time'),
                //     TimePicker(
                //       selected: startTime,
                //       hourFormat: HourFormat.HH,
                //       onChanged: (value) => setState(() => startTime = value),
                //     ),

                //     TimePicker(
                //       selected: endTime,
                //       hourFormat: HourFormat.HH,
                //       onChanged: (value) => setState(() => endTime = value),
                //     ),
                //   ],
                // ),
              ],
            ),
            gap16,
            SizedBox(
              width: 330,
              child: FilledButton(
                child: const Text('Submit'),
                onPressed: () async {
                  source = HistoryLogsSource(
                    queries: [
                      if (startDate != null && endDate != null)
                        ap.Query.between(
                          '\$createdAt',
                          startDate?.toIso8601String(),
                          endDate?.toIso8601String(),
                        ),
                      if (userRole != null) ap.Query.equal('role', userRole),
                      if (userActivity != null)
                        ap.Query.equal('event', userActivity),
                      if (searchUser.isNotEmpty)
                        ap.Query.equal('user', searchUser),
                    ],
                  );

                  setState(() => isSubmitted = true);
                },
              ),
            ),
            if (isSubmitted) gap16,
            if (isSubmitted)
              SizedBox(
                height: 700,
                child: AsyncTable(
                  source: source,
                  minWidth: 2000,
                  columns: const [
                    DataColumn2(label: Text('User ID'), size: ColumnSize.L),
                    DataColumn2(label: Text('Name'), size: ColumnSize.L),
                    DataColumn2(label: Text('Email'), size: ColumnSize.L),
                    DataColumn2(label: Text('Role'), size: ColumnSize.S),
                    DataColumn2(label: Text('Activity'), size: ColumnSize.L),
                    DataColumn2(label: Text('Date'), size: ColumnSize.S),
                    DataColumn2(label: Text('Time'), size: ColumnSize.S),
                    DataColumn2(label: Text('Device')),
                    DataColumn2(label: Text('Location')),
                  ],
                ),
              ),
          ],
        );
      },
      error: (error, stackTrace) => ErrorPage(erorrMessage: error.toString()),
      loading: () => LoadingPage(),
    );
  }
}
