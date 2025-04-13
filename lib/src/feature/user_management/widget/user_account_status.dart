import 'package:appwrite/models.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/user_management/user_management.dart';

class UserAccountStatus extends StatefulWidget {
  const UserAccountStatus(this.user, {super.key});
  final Document user;

  @override
  State<UserAccountStatus> createState() => _UserAccountStatusState();
}

class _UserAccountStatusState extends State<UserAccountStatus> {
  late DateTime activationDate;
  late DateTime? deactivationDate;

  @override
  void initState() {
    super.initState();
    final user = widget.user.data['account_status'];
    activationDate = DateTime.parse(user['activation_date']);
    if (user['deactivation'] != null) {
      deactivationDate = DateTime.parse(user['deactivation']);
    } else {
      deactivationDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(Sizes.p12),
        border: Border.all(color: context.theme.inactiveBackgroundColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          spacing: Sizes.p16,
          children: [
            AccountStatus(
              'Activation Details',
              date: activationDate,
              icon: FluentIcons.skype_circle_check,
              switchTitle: "Reactivate Immediately",
            ),
            Divider(),
            AccountStatus(
              'Deactivation Details',
              date: deactivationDate,
              icon: FluentIcons.skype_circle_minus,
              switchTitle: "Deactivate Immediately",
            ),
          ],
        ),
      ),
    );
  }
}
