import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tabs/authentication_tabs.dart';
import 'tabs/user_tabs.dart';

class UserManagement extends ConsumerStatefulWidget {
  const UserManagement({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserManagementState();
}

class _UserManagementState extends ConsumerState<UserManagement> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: TabView(
        currentIndex: currentIndex,
        onChanged: (value) => setState(() => currentIndex = value),
        tabs: [
          Tab(
            icon: Icon(FluentIcons.user_sync),
            text: Text('Account Lifecycle'),
            body: UserTabs(),
          ),
          Tab(
            icon: Icon(FluentIcons.azure_key_vault),
            text: Text('Authentication'),
            body: AuthenticationTabs(),
          ),
        ],
      ),
    );
  }
}
