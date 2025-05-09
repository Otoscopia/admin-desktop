import 'package:fluent_ui/fluent_ui.dart';

import 'package:admin/src/config/index.dart';

class SettingsEntity {
  final ThemeMode themeMode;
  final AccentColor accentColor;
  final double fontSize;
  final String fontFamily;

  SettingsEntity({
    required this.themeMode,
    required this.accentColor,
    required this.fontSize,
    required this.fontFamily,
  });

  List<Map<String, String>> get fonts => [
    {"font": "Segoe UI", "name": "Segoe UI"},
    {"font": "Arial", "name": "Arial"},
    {"font": "Times New Roman", "name": "Times New Roman"},
    {"font": "Courier New", "name": "Courier New"},
  ];

  List<Map<String, Object>> get themeModes => [
    {"mode": ThemeMode.system, "name": "System"},
    {"mode": ThemeMode.light, "name": "Light"},
    {"mode": ThemeMode.dark, "name": "Dark"},
  ];

  factory SettingsEntity.initial() {
    return SettingsEntity(
      themeMode: ThemeMode.system,
      accentColor: AppColors.primary.toAccentColor(),
      fontSize: 1,
      fontFamily: "Segoe UI",
    );
  }

  SettingsEntity copyWith({
    ThemeMode? themeMode,
    AccentColor? accentColor,
    double? fontSize,
    String? fontFamily,
  }) {
    return SettingsEntity(
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}
