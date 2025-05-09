import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/audit_logs/audit_logs.dart';
import 'package:admin/src/feature/authentication/sign_in.dart';
import 'package:admin/src/feature/dashboard/dashboard.dart';
import 'package:admin/src/feature/roles/tabs/role_assignment.dart';
import 'package:admin/src/feature/roles/tabs/roles_tab.dart';
import 'package:admin/src/feature/settings/settings.dart';
import 'package:admin/src/feature/user_management/user_management.dart';

class Admin extends ConsumerStatefulWidget {
  const Admin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminState();
}

class _AdminState extends ConsumerState<Admin> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Listener(
      child: NavigationView(
        pane: NavigationPane(
          selected: index,
          header: const Text("Otoscopia"),
          onItemPressed: (int i) => setState(() => index = i),
          items: [
            PaneItem(
              icon: const Icon(FluentIcons.view_dashboard),
              title: const Text("Dashboard"),
              body: const Dashboard(),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.people),
              title: const Text("Users Management"),
              body: const UserManagement(),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.cloud_secure),
              title: const Text("Access Control List"),
              body: const TabPages(
                tabTitles: ['Role Assignment', 'Roles'],
                icons: [FluentIcons.temporary_user, FluentIcons.user_window],
                bodies: [RoleAssignment(), RolesTab()],
              ),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.history),
              title: const Text("Audit Logs"),
              body: const AuditLogs(),
            ),
          ],
          footerItems: [
            PaneItemAction(
              icon: const Icon(FluentIcons.rocket),
              title: const Text("What's New"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ContentDialog(
                      title: const Text("What's New"),
                      content: const Text(
                        "This is the latest version of Otoscopia.",
                      ),
                      actions: [
                        Button(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text("Settings"),
              body: const Settings(),
            ),
            PaneItemAction(
              icon: const Icon(FluentIcons.external_build),
              title: const Text("Sign-out"),
              onTap: () async {
                final user = ref.read(authenticationProvider);
                if (user.user != null) {
                  await ref.read(authenticationProvider.notifier).signOut();
                }

                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    FluentPageRoute(
                      builder: (context) {
                        if (!kIsWeb) {
                          PageContainer(content: SignIn());
                        }

                        return AppContainer(
                          onLoaded: (context) {
                            return const PageContainer(content: SignIn());
                          },
                        );
                      },
                    ),
                    (route) => false,
                  );
                }

                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
