import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:admin/src/core/providers/index.dart';
import 'package:admin/src/core/widgets/custom_text.dart';

class UserInformation extends ConsumerWidget {
  const UserInformation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authenticationProvider).user!;
    final role = user.role.name.uppercaseFirst();
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: Image.network(
            "https://picsum.photos/200",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(user.readableName.toUpperCase(), style: 4),
            CustomText(user.email),
            CustomText(role),
          ],
        ),
      ],
    );
  }
}
