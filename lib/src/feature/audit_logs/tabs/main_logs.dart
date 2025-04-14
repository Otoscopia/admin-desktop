import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/feature/audit_logs/widgets/history_log_source.dart';

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
