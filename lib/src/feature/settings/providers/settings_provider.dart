import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';

class SettingsNotifier extends StateNotifier<SettingsEntity> {
  SettingsNotifier() : super(SettingsEntity.initial());

  void setThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
  }

  void setAccentColor(AccentColor accentColor) {
    state = state.copyWith(accentColor: accentColor);
  }

  void setFontSize(double fontSize) {
    state = state.copyWith(fontSize: fontSize);
  }

  void setFontFamily(String fontFamily) {
    state = state.copyWith(fontFamily: fontFamily);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsEntity>((ref) {
      return SettingsNotifier();
    });
