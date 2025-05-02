import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/audit_logs/widgets/history_log_source.dart';

class MainLogs extends ConsumerStatefulWidget {
  const MainLogs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainLogsState();
}

class _MainLogsState extends ConsumerState<MainLogs> {
  final source = HistoryLogsSource();

  @override
  Widget build(BuildContext context) {
    return AsyncTable(
      columns: [
        DataColumn2(label: Text('User ID'), size: ColumnSize.M),
        DataColumn2(label: Text('Name'), size: ColumnSize.L),
        DataColumn2(label: Text('Email'), size: ColumnSize.L),
        DataColumn2(label: Text('Role'), size: ColumnSize.S),
        DataColumn2(label: Text('Activity'), size: ColumnSize.L),
        DataColumn2(label: Text('Date'), size: ColumnSize.S),
        DataColumn2(label: Text('Time'), size: ColumnSize.S),
        DataColumn2(label: Text('Device'), size: ColumnSize.L),
        DataColumn2(label: Text('Location')),
      ],
      source: source,
      minWidth: 2000,
    );
  }
}
