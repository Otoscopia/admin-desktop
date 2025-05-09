import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:admin/src/core/widgets/custom_text.dart';
import 'package:admin/src/feature/settings/providers/providers.dart';
import 'package:admin/src/feature/settings/widgets/rounded_background.dart';

class TextSettings extends ConsumerStatefulWidget {
  const TextSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextSettingsState();
}

class _TextSettingsState extends ConsumerState<TextSettings> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;

    final provider = ref.read(settingsProvider.notifier);
    final settings = ref.watch(settingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText("Text size preview", style: 5),
        SizedBox(
          height: 80,
          child: Text(
            "The size of these words will change as you adjust the slider. Changes you make here will apply to most of the text on the system.",
            style: typography.body?.apply(fontSizeFactor: scale),
          ),
        ),
        const Gap(8),
        RoundedBackground(
          child: ListTile(
            leading: const Icon(FluentIcons.font_size),
            title: const Text('Font Size'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('A'),
                const Gap(10),
                Slider(
                  value: scale,
                  onChanged: (value) => setState(() => scale = value),
                  min: 0.5,
                  max: 2,
                ),
                const Gap(10),
                const Text('A', style: TextStyle(fontSize: 24)),
                const Gap(8),
                Button(
                  onPressed:
                      settings.fontSize == scale
                          ? null
                          : () => provider.setFontSize(scale),
                  child: const Text("Apply"),
                ),
              ],
            ),
          ),
        ),
        const Gap(8),
        RoundedBackground(
          child: ListTile(
            leading: const Icon(FluentIcons.font),
            title: const Text('Font Family'),
            trailing: SizedBox(
              width: 200.0,
              child: ComboBox(
                isExpanded: true,
                items:
                    settings.fonts
                        .map(
                          (font) => ComboBoxItem(
                            value: font["font"] as String,
                            child: Text(font["name"] as String),
                          ),
                        )
                        .toList(),
                onChanged: (value) => provider.setFontFamily(value!),
                value: settings.fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
