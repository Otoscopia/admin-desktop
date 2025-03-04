import 'package:fluent_ui/fluent_ui.dart';

import 'package:admin/src/config/colors.dart';

extension AppThemeData on FluentThemeData {
  static FluentThemeData light() =>
      FluentThemeData.light()._customAccentColor();
  static FluentThemeData dark() => FluentThemeData.dark()._customAccentColor();

  FluentThemeData _customAccentColor() {
    return copyWith(
      accentColor: AppColors.primary.toAccentColor(),
    );
  }

  // FluentThemeData _dark {
  //   return FluentThemeData.dark().copyWith(

  //   );
  // }
}
