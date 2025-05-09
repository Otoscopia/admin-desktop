import 'package:flutter/services.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:admin/src/core/widgets/custom_text.dart';

class EnableMfaWidget extends ConsumerStatefulWidget {
  const EnableMfaWidget(this._mfa, {super.key});
  final List _mfa;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MfaWidgetState();
}

class _MfaWidgetState extends ConsumerState<EnableMfaWidget> {
  final mfaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      shrinkWrap: true,
      children: [
        const CustomText(
          'Scan the QR code below to enable Authenticator App',
          style: 4,
        ),
        const Gap(4),
        const InfoBar(
          title: Text('Warning'),
          content: Text(
            'Please store the secret key in a safe place, as it will not be shown again',
          ),
          severity: InfoBarSeverity.warning,
          isLong: true,
        ),
        Image.memory(widget._mfa[0] as Uint8List),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget._mfa[1]));
              // popUpInfoBar(
              //   barSeverity: InfoBarSeverity.success,
              //   'OTP Secret Key',
              //   'OTP has been saved to clipboard, please store it in a safe place',
              //   context,
              // );
            },
            child: CustomText('Secret Key: ${widget._mfa[1]}', style: 4),
          ),
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
                  //     .verifyAuthenticatorApp(mfaController.text);

                  // ref.read(userProvider.notifier).updateMfa(true);

                  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((
                    timeStamp,
                  ) {
                    Navigator.pop(context);

                    Clipboard.setData(ClipboardData(text: widget._mfa[1]));

                    // popUpInfoBar(
                    //   'Success',
                    //   'Authenticator App has been enabled, the Secret Key has been saved to clipboard and the OTP has been verified successfully',
                    //   context,
                    //   barSeverity: InfoBarSeverity.success,
                    // );
                  });
                },
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
