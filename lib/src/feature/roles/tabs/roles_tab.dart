import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/common/tab_pages.dart';
import 'package:admin/src/feature/roles/pages/check_access.dart';
import 'package:admin/src/feature/roles/pages/view_roles.dart';

class RolesTab extends ConsumerWidget {
  const RolesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: TabPages(
        tabTitles: ["Check Access", "View Roles"],
        icons: [
          FluentIcons.info_solid,
          FluentIcons.search,
          FluentIcons.red_eye,
        ],
        bodies: [CheckAccess(), ViewRoles()],
      ),
    );
  }
}
