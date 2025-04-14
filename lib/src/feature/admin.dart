import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/audit_logs/audit_logs.dart';
import 'package:admin/src/feature/roles/tabs/role_assignment.dart';
import 'package:admin/src/feature/roles/tabs/roles_tab.dart';
import 'package:admin/src/feature/settings/settings.dart';
import 'package:admin/src/feature/user_management/tabs/authentication_tabs.dart';
import 'package:admin/src/feature/user_management/tabs/user_tabs.dart';

class Admin extends ConsumerStatefulWidget {
  const Admin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminState();
}

class _AdminState extends ConsumerState<Admin> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: index,
        header: Text("Otoscopia"),
        onItemPressed: (int i) {
          setState(() {
            index = i;
          });
        },
        items: [
          PaneItem(
            icon: Icon(FluentIcons.view_dashboard),
            title: Text("Dashboard"),
            body: Center(child: Text("Dashboard")),
          ),
          PaneItem(
            icon: Icon(FluentIcons.people),
            title: Text("Users Management"),
            body: TabPages(
              icons: [FluentIcons.user_sync, FluentIcons.security_group],
              tabTitles: ['Account Lifecycle', 'Authentication'],
              bodies: [UserTabs(), AuthenticationTabs()],
            ),
          ),
          PaneItem(
            icon: Icon(FluentIcons.cloud_secure),
            title: Text("Access Controll"),
            body: TabPages(
              tabTitles: ['Role Assignment', 'Roles'],
              icons: [FluentIcons.temporary_user, FluentIcons.user_window],
              bodies: [RoleAssignment(), RolesTab()],
            ),
          ),
          PaneItem(
            icon: Icon(FluentIcons.history),
            title: Text("Audit Logs"),
            body: TabPages(
              tabTitles: ['Logs Filter', 'Main Logs'],
              icons: [FluentIcons.filter, FluentIcons.bulleted_list],
              bodies: [LogFilter(), MainLogs()],
            ),
          ),
        ],
        footerItems: [
          PaneItemAction(
            icon: Icon(FluentIcons.rocket),
            title: Text("What's New"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ContentDialog(
                    title: Text("What's New"),
                    content: Text("This is the latest version of Otoscopia."),
                    actions: [
                      Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          PaneItem(
            icon: Icon(FluentIcons.settings),
            title: Text("Settings"),
            body: Settings(),
          ),
          PaneItemAction(
            icon: Icon(FluentIcons.external_build),
            title: Text("Sign-out"),
            onTap: () async {
              await ref.read(authenticationProvider.notifier).signOut();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
