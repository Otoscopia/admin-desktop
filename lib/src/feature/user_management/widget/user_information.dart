import 'package:appwrite/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:admin/src/core/index.dart';

class UserInformation extends ConsumerWidget {
  final Map<String, dynamic> user;
  final DocumentList lastActivity;

  const UserInformation({
    super.key,
    required this.user,
    required this.lastActivity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createdAt = DateTime.parse(user['\$createdAt']);
    final joinedDate = DateFormat('MMM. dd, yyyy, HH:MM').format(createdAt);

    final status = user['data']['account_status']['status']['name'];

    late final String lastActivityDate;
    if (lastActivity.total != 0) {
      final latestLogs = lastActivity.documents.last;
      final latestActivity = DateTime.parse(latestLogs.$createdAt);
      lastActivityDate = DateFormat(
        'MMM. dd, yyyy, HH:MM',
      ).format(latestActivity);
    } else {
      lastActivityDate = 'No activity yet';
    }

    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(Sizes.p12),
        border: Border.all(color: context.theme.inactiveBackgroundColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: Sizes.p24,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: Image.network(
                    "https://picsum.photos/200",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(user['data']['readable_name']).title,
                    StatusPill(getStatus(status)),
                  ],
                ),
              ],
            ),
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(user['data']['email']),
                Text('Joined: $joinedDate'),
                Text('Last Activity: $lastActivityDate'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
