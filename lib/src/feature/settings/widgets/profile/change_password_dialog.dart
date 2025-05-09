import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

Future<void> changePasswordDialog(context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return const ContentDialog(
        title: Text('Change Password'),
        constraints: BoxConstraints(maxWidth: 600),
        content: ChangePasswordWidget(),
      );
    },
  );
}

class ChangePasswordWidget extends ConsumerStatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends ConsumerState<ChangePasswordWidget> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InfoLabel(
          label: "Old Password",
          child: PasswordBox(controller: oldPasswordController),
        ),
        const Gap(8),
        InfoLabel(
          label: "New Password",
          child: PasswordBox(controller: newPasswordController),
        ),
        const Gap(8),
        InfoLabel(
          label: "Confirm Password",
          child: PasswordBox(controller: confirmPasswordController),
        ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Button(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FilledButton(
              onPressed: () async {
                // if (newPasswordController.text !=
                //     confirmPasswordController.text) {
                //   popUpInfoBar(
                //     'Error',
                //     'Passwords do not match.',
                //     context,
                //     barSeverity: InfoBarSeverity.error,
                //   );
                //   return;
                // }

                try {
                  // await ref
                  //     .read(accountProvider.notifier)
                  //     .changePassword(
                  //       newPasswordController.text,
                  //       oldPasswordController.text,
                  //     );

                  // WidgetsFlutterBinding.ensureInitialized()
                  //     .addPostFrameCallback((_) {
                  //       popUpInfoBar(
                  //         'Success',
                  //         'Password has been changed.',
                  //         context,
                  //         barSeverity: InfoBarSeverity.success,
                  //       );
                  //       Navigator.of(context).pop();
                  //     });
                } catch (e) {
                  // WidgetsFlutterBinding.ensureInitialized()
                  //     .addPostFrameCallback((_) {
                  //       popUpInfoBar(
                  //         'Error',
                  //         e.toString(),
                  //         context,
                  //         barSeverity: InfoBarSeverity.error,
                  //       );
                  //     });
                }
              },
              child: const Text('Save New Password'),
            ),
          ],
        ),
      ],
    );
  }
}
