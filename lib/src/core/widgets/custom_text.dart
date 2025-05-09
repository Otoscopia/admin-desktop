import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/feature/settings/providers/providers.dart';

class CustomText extends ConsumerWidget {
  const CustomText(this._text, {super.key, this.style = 7});

  final String _text;

  /// 1: title, 2: subtitle, 3: caption, 4: body Large, 5: body Strong, 6: bold caption
  final int style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = FluentTheme.of(context).typography;

    final settings = ref.watch(settingsProvider);

    switch (style) {
      case 1:
        return Text(
          _text,
          style: typography.title?.apply(fontSizeFactor: settings.fontSize),
        );
      case 2:
        return Text(
          _text,
          style: typography.subtitle?.apply(fontSizeFactor: settings.fontSize),
        );
      case 3:
        return Text(
          _text,
          style: typography.caption?.apply(fontSizeFactor: settings.fontSize),
        );
      case 4:
        return Text(
          _text,
          style: typography.bodyLarge?.apply(fontSizeFactor: settings.fontSize),
        );
      case 5:
        return Text(
          _text,
          style: typography.bodyStrong?.apply(
            fontSizeFactor: settings.fontSize,
          ),
        );
      case 6:
        return Text(
          _text,
          style: typography.caption
              ?.apply(fontSizeFactor: settings.fontSize)
              .copyWith(fontWeight: FontWeight.bold),
        );
      default:
        return Text(
          _text,
          style: typography.body?.apply(fontSizeFactor: settings.fontSize),
        );
    }
  }
}
