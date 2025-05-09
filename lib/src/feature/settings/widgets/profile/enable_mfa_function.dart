import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'enable_mfa_widget.dart';

Future<void> enableMfaFunction(BuildContext context, WidgetRef ref) async {
  // await showDialog(
  //   barrierDismissible: true,
  //   dismissWithEsc: true,
  //   context: context,
  //   builder: (context) {
  //     return ContentDialog(
  //       title: const Text('Enable Multi-Factor Authentication'),
  //       constraints: const BoxConstraints(maxWidth: 600),
  //       content: FutureBuilder(
  //         future:
  //             ref
  //                 .read(multiFactorAuthenticationProvider.notifier)
  //                 .enableAuthenticatorApp(),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return const SizedBox(
  //               height: 200,
  //               child: Center(child: LoadingWidget()),
  //             );
  //           }

  //           final mfa = snapshot.data as List<dynamic>;

  //           return EnableMfaWidget(mfa);
  //         },
  //       ),
  //       actions: [
  //         Button(
  //           child: const Text("Close"),
  //           onPressed: () => Navigator.pop(context),
  //         ),
  //       ],
  //     );
  //   },
  // );
}
