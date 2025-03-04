import 'package:fluent_ui/fluent_ui.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF008080);

  static const white = Colors.white;

  static const transparent = Colors.transparent;

  static const status = {
    'online': {
      'text': Color(0xFF037847),
      'circle': Color(0xFF14BA6D),
      'background': Color(0xFFECFDF3),
    },
    'deactivated': {
      'text': Color(0xFF754040),
      'circle': Color(0xFF754040),
      'background': Color(0xFFFDDDDD),
    },
    'offline': {
      'text': Color(0xFF364254),
      'circle': Color(0xFF6C778B),
      'background': Color(0xFFF2F4F7),
    },
  };
}
