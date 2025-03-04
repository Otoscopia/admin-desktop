import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system_theme/system_theme.dart';

import 'package:admin/src/config/colors.dart';

part 'accent_color_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<Color> systemAccentColor(Ref ref) {
  // Initialize with current accent color
  ref.onDispose(() {
    // Clean up if needed
  });

  Stream<Color> color = SystemTheme.onChange.map((accent) => accent.accent);

  return color;
}

// You can also create a provider to get the current accent color value
@riverpod
Color currentAccentColor(Ref ref) {
  SystemTheme.fallbackColor = AppColors.primary.toAccentColor();
  final color = ref
      .watch(systemAccentColorProvider)
      .whenData((color) => color)
      .valueOrNull;

  return color ?? SystemTheme.fallbackColor;
}
