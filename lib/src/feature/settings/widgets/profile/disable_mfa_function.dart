import 'package:fluent_ui/fluent_ui.dart';

import 'disable_mfa_widget.dart';

Future<void> disableMfaFunction(BuildContext context) async {
  await showDialog(
    barrierDismissible: true,
    dismissWithEsc: true,
    context: context,
    builder: (context) {
      return const ContentDialog(
        title: Text('Disable Multi-Factor Authentication'),
        constraints: BoxConstraints(maxWidth: 600),
        content: DisableMfaWidget(),
      );
    },
  );
}
