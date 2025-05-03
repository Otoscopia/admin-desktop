import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/user_management/provider/user_account_status_provider.dart';
import 'package:admin/src/feature/user_management/user_management.dart';

class ManageUserPage extends ConsumerStatefulWidget {
  const ManageUserPage(this.uid, {super.key});
  final String uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageUserPageState();
}

class _ManageUserPageState extends ConsumerState<ManageUserPage> {
  @override
  Widget build(BuildContext context) {
    final accStatus = ref.watch(userAccStatusProvider(widget.uid));
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: accStatus.when(
        data: (data) {
          final user = data.user.toMap();
          final logs = data.logs;
          return Padding(
            padding: const EdgeInsets.all(Sizes.p24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: Sizes.p24,
              children: [
                UserInformation(user: user, lastActivity: logs),
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: BorderRadius.circular(Sizes.p12),
                    border: Border.all(
                      color: context.theme.inactiveBackgroundColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p24),
                    child: Column(
                      spacing: Sizes.p16,
                      children: [
                        AccountStatus(
                          'Activation Details',
                          userId: widget.uid,
                          providerKey: 'activation',
                          date: data.activationDate,
                          icon: FluentIcons.skype_circle_check,
                          switchTitle: "Reactivate Immediately",
                          switchValue: data.activateImmediately ?? false,
                        ),
                        Divider(),
                        AccountStatus(
                          'Deactivation Details',
                          userId: widget.uid,
                          providerKey: 'deactivation',
                          date: data.deactivationDate,
                          icon: FluentIcons.skype_circle_minus,
                          switchTitle: "Deactivate Immediately",
                          switchValue: data.deactivateImmediately ?? false,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      child: Text('Save'),
                      onPressed: () async {
                        final logging = ref
                            .read(authenticationProvider)
                            .logDetails('update-user');

                        final body = {
                          "id": user['\$id'],
                          ...data.toMap(),
                          ...json.decode(logging),
                        };

                        ref
                            .read(userAccStatusProvider(widget.uid).notifier)
                            .saveData(body);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Something went wrong: ${error.toString()}"),
                gap16,
                FilledButton(child: Text("Retry"), onPressed: () {}),
              ],
            ),
          );
        },
        loading: () {
          return Center(child: ProgressBar());
        },
      ),
    );
  }
}
