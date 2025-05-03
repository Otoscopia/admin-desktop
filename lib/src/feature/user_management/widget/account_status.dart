import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/config/index.dart';
import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/user_management/provider/user_account_status_provider.dart';

class AccountStatus extends ConsumerWidget {
  final String userId;
  final String title;
  final IconData icon;
  final DateTime? date;
  final String switchTitle;
  final bool switchValue;
  final String providerKey;

  const AccountStatus(
    this.title, {
    super.key,
    required this.icon,
    this.date,
    required this.userId,
    required this.switchTitle,
    required this.switchValue,
    required this.providerKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: Sizes.p8,
      children: [
        Row(
          spacing: Sizes.p8,
          children: [
            Icon(icon, color: AppColors.primary),
            Text(title).titleSmallBold,
          ],
        ),
        Column(
          spacing: Sizes.p16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DatePicker(
                  selected: date,
                  onChanged: (value) {
                    if (providerKey == 'activation') {
                      ref
                          .read(userAccStatusProvider(userId).notifier)
                          .updateAccountStatus(activationDate: date);
                    } else {
                      ref
                          .read(userAccStatusProvider(userId).notifier)
                          .updateAccountStatus(deactivationDate: date);
                    }
                  },
                ),
                TimePicker(
                  selected: date,
                  onChanged: (value) {
                    if (providerKey == 'activation') {
                      ref
                          .read(userAccStatusProvider(userId).notifier)
                          .updateAccountStatus(activationDate: date);
                    } else {
                      ref
                          .read(userAccStatusProvider(userId).notifier)
                          .updateAccountStatus(deactivationDate: date);
                    }
                  },
                ),
              ],
            ),
            Row(
              spacing: Sizes.p4,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ToggleSwitch(
                  checked: switchValue,
                  onChanged: (value) {
                    if (providerKey == 'activation') {
                      logger.info("${value ? DateTime.now() : null}");
                      ref
                          .read(userAccStatusProvider(userId).notifier)
                          .updateAccountStatus(
                            activateImmediately: value,
                            deactivateImmediately: false,
                            deactivationDate: null,
                            activationDate: value ? DateTime.now() : null,
                          );
                    } else {
                      logger.info("${value ? DateTime.now() : null}");
                      ref
                          .read(userAccStatusProvider(userId).notifier)
                          .updateAccountStatus(
                            deactivateImmediately: value,
                            activateImmediately: false,
                            deactivationDate: value ? DateTime.now() : null,
                            activationDate: null,
                          );
                    }
                  },
                ),
                Text(switchTitle),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
