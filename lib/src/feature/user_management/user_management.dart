import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/user_management/pages/authentication_configuration.dart';
import 'package:admin/src/feature/user_management/tabs/user_tabs.dart';

export './pages/manage_user_page.dart';
export './pages/user_tab_page.dart';
export './widget/account_status.dart';
export './widget/user_account_status.dart';
export './widget/user_information.dart';

class UserManagement extends ConsumerWidget {
  const UserManagement({super.key});

  Future<DocumentList> getConfiguration() async {
    final response = await database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('admin_users_account_configuration'),
      queries: [Query.limit(1)],
    );

    return response;
  }

  Future<DocumentList> getPasswordExpiration() async {
    final response = await database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('dropdown_selections'),
      queries: [Query.equal('key', 'password-expiration')],
    );

    return response;
  }

  Future<DocumentList> getIdleSessionTimeout() async {
    final response = await database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('dropdown_selections'),
      queries: [Query.equal('key', 'idle-session-timout')],
    );

    return response;
  }

  Future<DocumentList> getPasswordGracePeriod() async {
    final response = await database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('dropdown_selections'),
      queries: [Query.equal('key', 'password-grace-period')],
    );

    return response;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future.wait([
        getConfiguration(),
        getPasswordExpiration(),
        getIdleSessionTimeout(),
        getPasswordGracePeriod(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: ProgressBar());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Something wen't wrong ${snapshot.error.toString()}"),
          );
        }

        final configuration = snapshot.data![0];
        final getPasswordExpiration = snapshot.data![1];
        final getIdleSessionTimeout = snapshot.data![2];
        final getPasswordGracePeriod = snapshot.data![3];

        return TabPages(
          icons: [FluentIcons.user_sync, FluentIcons.data_management_settings],
          tabTitles: ['Account Lifecycle', 'Configuration'],
          bodies: [
            UserTabs(),
            AuthenticationConfiguration(
              configuration: configuration,
              passwordExpiration: getPasswordExpiration,
              idleSessionTimeout: getIdleSessionTimeout,
              passwordGracePeriod: getPasswordGracePeriod,
            ),
          ],
        );
      },
    );
  }
}
