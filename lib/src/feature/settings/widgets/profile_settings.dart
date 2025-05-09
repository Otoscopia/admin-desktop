import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/core/widgets/custom_text.dart';
import 'package:admin/src/feature/settings/widgets/widget_expander.dart';

import 'profile/account_security.dart';
import 'profile/user_account_widget.dart';
import 'profile/user_information_widget.dart';

class ProfileSettings extends ConsumerWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authenticationProvider).user!;
    final mfa = user.mfaEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const UserInformation(),
            Row(
              children: [
                Icon(mfa ? FluentIcons.shield_solid : FluentIcons.shield),
                const Gap(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText("Security Status", style: 5),
                    CustomText(mfa ? "Secured" : "Unsecured"),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Gap(32),
        const CustomText('Profile', style: 5),
        const Gap(8),
        const WidgetExpander(
          icon: FluentIcons.account_management,
          title: "User Information",
          subtitle: "View or Modify your Information",
          content: UserAccount(),
        ),
        const Gap(4),
        const WidgetExpander(
          icon: FluentIcons.lightning_secure,
          title: "Account Security",
          subtitle: "Modify your Account Security",
          content: AccountSecurity(),
        ),
      ],
    );
  }
}
