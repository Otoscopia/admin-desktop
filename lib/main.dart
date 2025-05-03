import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:admin/src/app.dart';
import 'package:admin/src/core/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjector().init();
  final packageInfo = await PackageInfo.fromPlatform();

  if (!kDebugMode) {
    return await SentryFlutter.init(
      (options) {
        options.release = packageInfo.version;
        options.dsn = Env.sentryDsn;
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 1.0;
      },
      appRunner:
          () => runApp(
            ProviderScope(
              child: DefaultAssetBundle(
                bundle: SentryAssetBundle(),
                child: const MyApp(),
              ),
            ),
          ),
    );
  }

  runApp(const ProviderScope(child: MyApp()));
}
