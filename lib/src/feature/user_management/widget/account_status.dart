import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/config/index.dart';
import 'package:admin/src/core/index.dart';

class AccountStatus extends ConsumerStatefulWidget {
  final String title;
  final IconData icon;
  final DateTime? date;
  final String switchTitle;
  const AccountStatus(
    this.title, {
    super.key,
    required this.icon,
    this.date,
    required this.switchTitle,
  });

  @override
  ConsumerState<AccountStatus> createState() => _AccountStatusState();
}

class _AccountStatusState extends ConsumerState<AccountStatus> {
  late DateTime? date;
  bool immediately = false;

  @override
  void initState() {
    super.initState();
    if (widget.date != null) {
      date = widget.date!;
    } else {
      date = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Sizes.p8,
      children: [
        Row(
          spacing: Sizes.p8,
          children: [
            Icon(widget.icon, color: AppColors.primary),
            Text(widget.title).titleSmallBold,
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
                    setState(() {
                      date = value;
                    });
                  },
                ),
                TimePicker(
                  selected: date,
                  onChanged: (value) {
                    setState(() {
                      date = value;
                    });
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
                  checked: immediately,
                  onChanged:
                      (value) => setState(() {
                        immediately = value;
                      }),
                ),
                Text(widget.switchTitle),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
