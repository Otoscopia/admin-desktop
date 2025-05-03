import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/user_management/pages/manage_user_page.dart';
import 'package:admin/src/feature/user_management/pages/user_tab_page.dart';

class UserTabs extends ConsumerStatefulWidget {
  const UserTabs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserTabsState();
}

class _UserTabsState extends ConsumerState<UserTabs> {
  int currentIndex = 0;
  late final List<Tab> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      Tab(
        icon: const Icon(FluentIcons.group),
        text: const Text('Users'),
        body: UserTabPage(
          onUserTabPressed: ({required String name, required String uid}) {
            generateTab(name: name, uid: uid);
          },
        ),
      ),
    ];
  }

  void generateTab({required name, required uid}) {
    late final Tab tab;
    tab = Tab(
      text: Text(name),
      icon: const Icon(FluentIcons.data_management_settings),
      body: ManageUserPage(uid),
      onClosed: () {
        tabs.remove(tab);
        if (currentIndex > 0) currentIndex--;
      },
    );

    tabs.add(tab);
    currentIndex = tabs.length - 1;
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p4),
      content: TabView(
        shortcutsEnabled: false,
        currentIndex: currentIndex,
        tabs: tabs,
        onChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
