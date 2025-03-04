import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:system_theme/system_theme.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/admin.dart';
import 'package:admin/src/feature/authentication/sign_in.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(appThemeProvider);
    final accentColor = ref.watch(currentAccentColorProvider).toAccentColor();
    final accent = theme.systemAccent
        ? accentColor
        : SystemTheme.fallbackColor.toAccentColor();

    return FluentApp(
      title: 'Otoscopia Admin',
      themeMode: theme.mode,
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData.light().copyWith(accentColor: accent),
      darkTheme: FluentThemeData.dark().copyWith(accentColor: accent),
      navigatorObservers: !kDebugMode ? [SentryNavigatorObserver()] : [],
      home: AppContainer(
        onLoaded: (context) {
          final auth = ref.watch(authenticationProvider);

          return PageContainer(
            content: auth.user != null ? Admin() : SignIn(),
          );
        },
      ),
    );
  }
}
