import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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

    return FluentApp(
      title: 'Otoscopia Admin',
      themeMode: theme.mode,
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData.light().copyWith(accentColor: theme.accent),
      darkTheme: FluentThemeData.dark().copyWith(accentColor: theme.accent),
      navigatorObservers: !kDebugMode ? [SentryNavigatorObserver()] : [],
      home:
          kIsWeb
              ? FutureBuilder(
                future: null,
                builder: (context, snapshot) {
                  final auth = ref.watch(authenticationProvider);

                  return PageContainer(
                    content: auth.user != null ? const Admin() : const SignIn(),
                  );
                },
              )
              : AppContainer(
                onLoaded: (context) {
                  final auth = ref.watch(authenticationProvider);

                  return PageContainer(
                    content: auth.user != null ? const Admin() : const SignIn(),
                  );
                },
              ),
    );
  }
}
