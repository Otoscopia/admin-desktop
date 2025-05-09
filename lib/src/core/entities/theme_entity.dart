import 'package:fluent_ui/fluent_ui.dart';

class ThemeEntity {
  ThemeMode mode;
  bool systemAccent;
  AccentColor? accent;

  ThemeEntity({
    this.mode = ThemeMode.system,
    this.systemAccent = false,
    this.accent,
  });
}
