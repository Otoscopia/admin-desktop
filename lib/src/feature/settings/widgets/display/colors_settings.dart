import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:admin/src/core/providers/app_theme_provider.dart';
import 'package:admin/src/core/widgets/custom_text.dart';
import 'package:admin/src/feature/settings/widgets/rounded_background.dart';

class ColorsSettings extends ConsumerWidget {
  const ColorsSettings({super.key});

  static const List<String> accentColorNames = [
    'System',
    'Yellow',
    'Orange',
    'Red',
    'Magenta',
    'Purple',
    'Blue',
    'Teal',
    'Green',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(appThemeProvider.notifier);
    final settings = ref.watch(appThemeProvider);

    const width = 150.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoundedBackground(
          child: ListTile(
            leading: const Icon(FluentIcons.contrast),
            title: const CustomText('Theme Mode'),
            subtitle: const CustomText(
              "Change the theme that appears in the system",
            ),
            trailing: SizedBox(
              width: width,
              child: ComboBox<ThemeMode>(
                isExpanded: true,
                items:
                    ThemeMode.values
                        .map(
                          (mode) => ComboBoxItem(
                            value: mode,
                            child: CustomText(mode.name.uppercaseFirst()),
                          ),
                        )
                        .toList(),
                onChanged: (value) => provider.changeTheme(value!),
                value: settings.mode,
              ),
            ),
          ),
        ),
        const Gap(8),
        RoundedBackground(
          child: ListTile(
            leading: const Icon(FluentIcons.color),
            title: const CustomText('Accent Color'),
            subtitle: const CustomText(
              "Change the color of the primary elements of the app",
            ),
            trailing: SizedBox(
              width: width,
              child: ComboBox<AccentColor>(
                isExpanded: true,
                items:
                    Colors.accentColors
                        .asMap()
                        .entries
                        .map(
                          (color) => ComboBoxItem(
                            value: color.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: color.value,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const Gap(8),
                                CustomText(accentColorNames[color.key]),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) => provider.changeAccent(false, value!),
                value: settings.accent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
