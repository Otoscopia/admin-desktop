import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key, required this.onAddButtonClick});
  final Function() onAddButtonClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.scrollable(
      padding: EdgeInsets.all(Sizes.p24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 330,
              child: TextBox(
                placeholder: "Search by Name or Role",
                suffix: Padding(
                  padding: EdgeInsets.only(right: Sizes.p12),
                  child: Icon(FluentIcons.search),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: Sizes.p20,
              children: [
                FilledButton(
                  child: Row(
                    spacing: Sizes.p12,
                    children: [
                      Icon(FluentIcons.add_friend),
                      Text("Create Team"),
                    ],
                  ),
                  onPressed: () {
                    onAddButtonClick();
                  },
                ),
                FilledButton(
                  child: Row(
                    spacing: Sizes.p12,
                    children: [
                      Icon(FluentIcons.edit_list_pencil),
                      Text("Edit Team"),
                    ],
                  ),
                  onPressed: () {},
                ),
                FilledButton(
                  child: Row(
                    spacing: Sizes.p12,
                    children: [Icon(FluentIcons.delete), Text("Remove Team")],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        gap24,
        Expanded(
          child: Expander(
            leading: Icon(FluentIcons.health_solid),
            header: Text("Doctor"),
            content: Column(),
          ),
        ),
        gap12,
        Expanded(
          child: Expander(
            leading: Icon(FluentIcons.health_solid),
            header: Text("Nurse"),
            content: Column(),
          ),
        ),
        gap12,
        Expanded(
          child: Expander(
            leading: Icon(FluentIcons.health_solid),
            header: Text("IAM Administrator"),
            content: Column(),
          ),
        ),
      ],
    );
  }
}
