import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:admin/src/core/widgets/custom_text.dart';
import 'package:admin/src/feature/settings/widgets/display_settings.dart';
import 'package:admin/src/feature/settings/widgets/profile_settings.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: const [
          CustomText('Settings', style: 1),
          Gap(8),
          ProfileSettings(),
          Gap(8),
          DisplaySettings(),
          Gap(16),
        ],
      ),
    );
  }
}
