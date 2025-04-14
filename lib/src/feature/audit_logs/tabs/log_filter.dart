import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/audit_logs/widgets/filter_container.dart';
import 'package:admin/src/feature/audit_logs/widgets/history_log_source.dart';

class LogFilter extends ConsumerStatefulWidget {
  const LogFilter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogFilterState();
}

class _LogFilterState extends ConsumerState<LogFilter> {
  final source = HistoryLogsSource();
  DateTime? startDate;
  DateTime? endDate;
  String? userRole;
  String? userActivity;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      children: [
        FilterContainer(
          titles: ['Start Date', 'End Date'],
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
                setState(() {
                  endDate = value;
                });
              },
            ),
          ],
        ),
        gap16,
        FilterContainer(
          titles: ['User Role', 'User Activity'],
          widgets: [
            ComboBox(
              value: userRole,
              items:
                  Role.values.map((r) {
                    final role = r.name;
                    return ComboBoxItem(
                      value: role,
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
              items: [
                ComboBoxItem(value: 'admin', child: Text('admin')),
                ComboBoxItem(value: 'doctor', child: Text('doctor')),
                ComboBoxItem(value: 'nurse', child: Text('nurse')),
                ComboBoxItem(value: 'parent', child: Text('parent')),
              ],
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
        SizedBox(
          width: 330,
          child: FilledButton(child: Text('Submit'), onPressed: () {}),
        ),
        gap16,
        SizedBox(
          height: 1100,
          child: AsyncPaginatedDataTable2(
            source: source,
            minWidth: 2000,
            rowsPerPage: 20,
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
        ),
      ],
      // ),
    );
  }
}
