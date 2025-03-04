import 'package:fluent_ui/fluent_ui.dart';

extension NavigationExtension on BuildContext {
  FluentThemeData get theme => FluentTheme.of(this);

  Brightness get brightness => FluentTheme.of(this).brightness;

  bool get isDark => FluentTheme.of(this).brightness.isDark;

  push(Widget page) {
    return Navigator.of(this).push(
      FluentPageRoute(builder: (context) => page),
    );
  }

  pushWithAnimation(Widget page) {
    return Navigator.of(this).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ));
  }

  pop() {
    return Navigator.of(this).pop();
  }
}
