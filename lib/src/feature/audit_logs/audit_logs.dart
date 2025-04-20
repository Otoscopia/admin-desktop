import 'package:appwrite/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/audit_logs/tabs/log_filter.dart';
import 'package:admin/src/feature/audit_logs/tabs/main_logs.dart';

export 'tabs/log_filter.dart';
export 'tabs/main_logs.dart';

class AuditLogs extends ConsumerWidget {
  const AuditLogs({super.key});

  Future<List<Document>> fetchRoles() async {
    final response = await database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('roles'),
    );

    return response.documents;
  }

  Future<List<Document>> fetchEvents() async {
    final response = await database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('events'),
    );

    return response.documents;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future.wait([fetchRoles(), fetchEvents()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ProgressBar();
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final roles = snapshot.data?[0];
        final events = snapshot.data?[1];

        return TabPages(
          tabTitles: ['Logs Filter', 'Main Logs'],
          icons: [FluentIcons.filter, FluentIcons.bulleted_list],
          bodies: [LogFilter(events: events, roles: roles), MainLogs()],
        );
      },
    );
  }
}
