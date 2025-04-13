import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/user_management/user_management.dart';

class ManageUserPage extends ConsumerStatefulWidget {
  const ManageUserPage(this.uid, {super.key});
  final String uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageUserPageState();
}

class _ManageUserPageState extends ConsumerState<ManageUserPage> {
  Future<List<Model>> fetchDetails() async {
    final user = database.getDocument(
      databaseId: databaseId,
      collectionId: getCollectionId('users'),
      documentId: widget.uid,
    );

    final logs = database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('logs'),
      queries: [Query.equal('user', widget.uid)],
    );

    return await Future.wait([user, logs]);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: FutureBuilder(
        future: fetchDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ProgressRing());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Something wen't wrong ${snapshot.error}"),
            );
          }

          final user = snapshot.data?[0] as Document;
          final logs = snapshot.data?[1] as DocumentList;

          return Padding(
            padding: const EdgeInsets.all(Sizes.p24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: Sizes.p24,
              children: [
                UserInformation(user: user, lastActivity: logs),
                UserAccountStatus(user),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(child: Text('Save'), onPressed: () {}),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
