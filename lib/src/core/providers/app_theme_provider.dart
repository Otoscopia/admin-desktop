import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/entities/index.dart';

part 'app_theme_provider.g.dart';

@Riverpod(keepAlive: true)
class AppTheme extends _$AppTheme {
  @override
  ThemeEntity build() {
    return ThemeEntity();
  }

  void changeTheme(ThemeMode mode) {
    state = ThemeEntity(
      mode: mode,
      systemAccent: state.systemAccent,
    );
  }
}
