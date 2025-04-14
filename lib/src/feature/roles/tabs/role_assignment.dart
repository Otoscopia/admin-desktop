import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/roles/pages/create_team.dart';
import 'package:admin/src/feature/roles/pages/main_view.dart';

class RoleAssignment extends ConsumerStatefulWidget {
  const RoleAssignment({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoleAssignmentState();
}

class _RoleAssignmentState extends ConsumerState<RoleAssignment> {
  int currentIndex = 0;
  late final List<Tab> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      Tab(
        icon: Icon(FluentIcons.view_dashboard),
        text: Text('Main View'),
        body: MainView(
          onAddButtonClick: () {
            generateTab(name: "Create Team");
          },
        ),
      ),
    ];
  }

  void generateTab({required name}) {
    late final Tab tab;
    tab = Tab(
      text: Text(name),
      icon: Icon(FluentIcons.teamwork),
      body: CreateTeam(),
      onClosed: () {
        tabs.remove(tab);
        if (currentIndex > 0) currentIndex--;
      },
    );

    tabs.add(tab);
    currentIndex++;
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.symmetric(vertical: Sizes.p4),
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
