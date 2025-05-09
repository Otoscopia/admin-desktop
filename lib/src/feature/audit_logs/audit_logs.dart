import 'package:admin/src/feature/audit_logs/provider/fetch_audit_logs.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/audit_logs/tabs/log_filter.dart';
import 'package:admin/src/feature/audit_logs/tabs/main_logs.dart';

export 'tabs/log_filter.dart';
export 'tabs/main_logs.dart';

class AuditLogs extends ConsumerWidget {
  const AuditLogs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(fetchAuditLogsProvider);

    return logs.when(
      data: (data) {
        final roles = data[0];
        final events = data[1];

        return TabPages(
          tabTitles: ['Logs Filter', 'Main Logs'],
          icons: [FluentIcons.filter, FluentIcons.bulleted_list],
          bodies: [LogFilter(events: events, roles: roles), const MainLogs()],
        );
      },
      error: (error, stackTrace) => ErrorPage(erorrMessage: error.toString()),
      loading: () => LoadingPage(),
    );
  }
}
