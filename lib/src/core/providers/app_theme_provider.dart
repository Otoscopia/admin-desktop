import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/entities/index.dart';
import 'package:admin/src/core/providers/index.dart';

part 'app_theme_provider.g.dart';

@Riverpod(keepAlive: true)
class AppTheme extends _$AppTheme {
  @override
  ThemeEntity build() {
    final accent = ref.read(currentAccentColorProvider).toAccentColor();
    return ThemeEntity(systemAccent: false, accent: accent);
  }

  void changeTheme(ThemeMode mode) {
    state = ThemeEntity(mode: mode, systemAccent: state.systemAccent);
  }

  void changeAccent(bool systemAccent, AccentColor color) {
    state = ThemeEntity(
      mode: state.mode,
      systemAccent: systemAccent,
      accent: color,
    );
  }
}
