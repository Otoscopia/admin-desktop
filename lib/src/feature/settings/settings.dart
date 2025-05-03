import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/settings/user_information.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authenticationProvider).user;

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text("Settings")),
      children: [
        Row(
          spacing: 12,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: Image.network(
                "https://picsum.photos/200",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(user!.readableName).title,
                  Text(user.email),
                  Text(user.role.name.uppercaseFirst()),
                ],
              ),
            ),
          ],
        ),
        gap32,
        Expanded(
          child: Expander(
            leading: const Icon(FluentIcons.user_optional),
            header: createHeader(
              title: "User Information",
              subtitle: "View and edit your user information",
            ),
            // content: Text("data"),
            content: const UserInformationWidget(),
          ),
        ),
        gap12,
        Expanded(
          child: Expander(
            leading: const Icon(FluentIcons.settings_secure),
            header: createHeader(
              title: "Account Security",
              subtitle: "Modify your Account Security",
            ),
            content: const Text("data"),
          ),
        ),
        gap12,
        Expander(
          leading: const Icon(FluentIcons.color, size: 28),
          header: createHeader(
            title: "Colors",
            subtitle: "Modify Theme Mode and Accent Colors",
          ),
          content: const Text("data"),
        ),
        gap12,
        Expander(
          leading: const Icon(FluentIcons.account_management, size: 28),
          header: createHeader(
            title: "Text Size",
            subtitle: "Text sizes that appears throughout the application",
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(FluentIcons.font_size),
                title: const Text('Font Size'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('A'),
                    gap8,
                    Slider(
                      value: scale,
                      onChanged: (value) => setState(() => scale = value),
                      min: 0.5,
                      max: 2,
                    ),
                    gap8,
                    const Text('A', style: TextStyle(fontSize: 24)),
                    gap8,
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget createHeader({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title).titleSmall, Text(subtitle).caption],
      ),
    );
  }
}
