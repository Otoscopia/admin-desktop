import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';

class AsyncTable extends ConsumerStatefulWidget {
  final List<DataColumn2> columns;
  final AsyncDataTableSource source;
  final bool showCheckboxColumn;
  final double minWidth;

  const AsyncTable({
    super.key,
    required this.columns,
    required this.source,
    this.showCheckboxColumn = false,
    this.minWidth = 1200,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AsyncTableState();
}

class _AsyncTableState extends ConsumerState<AsyncTable> {
  int _rowsPerPage = 10;
  bool? selectAll = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: AsyncPaginatedDataTable2(
        fit: FlexFit.loose,
        columns: widget.columns,
        source: widget.source,
        rowsPerPage: _rowsPerPage,
        minWidth: widget.minWidth,
        showCheckboxColumn: widget.showCheckboxColumn,
        showFirstLastButtons: true,
        autoRowsToHeight: false,
        loading: const Center(child: ProgressBar()),
        empty: const Center(child: Text('No data found')),
        onSelectAll: (value) {
          logger.info("select all $value");
          setState(() => selectAll = value);
        },
        availableRowsPerPage: const [5, 10, 20, 50],
        onRowsPerPageChanged: (value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _rowsPerPage = value!;
            });
          });
        },
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
