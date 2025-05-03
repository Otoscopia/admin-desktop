import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/user_management/pages/authentication_configuration.dart';
import 'package:admin/src/feature/user_management/tabs/user_tabs.dart';

export './pages/manage_user_page.dart';
export './pages/user_tab_page.dart';
export './widget/account_status.dart';
export './widget/user_information.dart';

class UserManagement extends ConsumerWidget {
  const UserManagement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabPages(
      icons: [FluentIcons.user_sync, FluentIcons.data_management_settings],
      tabTitles: ['Account Lifecycle', 'Configuration'],
      bodies: [UserTabs(), AuthenticationConfiguration()],
    );
  }
}
