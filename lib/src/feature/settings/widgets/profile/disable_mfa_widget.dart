import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:admin/src/core/widgets/custom_text.dart';

class DisableMfaWidget extends ConsumerStatefulWidget {
  const DisableMfaWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MfaWidgetState();
}

class _MfaWidgetState extends ConsumerState<DisableMfaWidget> {
  final mfaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomText(
          'Input the OTP below to disable Authenticator App',
          style: 4,
        ),
        const Gap(8),
        InfoLabel(
          label: 'OTP Verification Code',
          child: Row(
            children: [
              Expanded(child: TextBox(controller: mfaController)),
              const Gap(8),
              Button(
                onPressed: () async {
                  // await ref
                  //     .read(multiFactorAuthenticationProvider.notifier)
                  //     .disableAuthenticatorApp(mfaController.text);

                  // ref.read(userProvider.notifier).updateMfa(false);

                  // WidgetsFlutterBinding.ensureInitialized()
                  //     .addPostFrameCallback((Duration duration) {
                  //       Navigator.of(context).pop();
                  //       popUpInfoBar(
                  //         'Success',
                  //         'Authenticator app has been disabled.',
                  //         context,
                  //       );
                  //     });
                },
                child: const Text('Disable'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
