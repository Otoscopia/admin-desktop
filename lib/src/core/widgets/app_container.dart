import 'package:appwrite/appwrite.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:admin/src/config/index.dart';
import 'package:admin/src/core/index.dart';

class AppContainer extends ConsumerStatefulWidget {
  const AppContainer({super.key, required this.onLoaded});
  final WidgetBuilder onLoaded;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppContainerState();
}

class _AppContainerState extends ConsumerState<AppContainer>
    with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    _init();
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (!isPreventClose) return;

    if (!mounted) return;

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('Confirm close'),
            content: const Text('Are you sure you want to close this window?'),
            actions: [
              Button(
                child: const Text('No'),
                onPressed: () {
                  context.pop();
                },
              ),
              FilledButton(
                child: const Text('Yes'),
                onPressed: () async {
                  try {
                    await ref.read(authenticationProvider.notifier).signOut();
                  } on AppwriteException catch (error) {
                    logger.warning("Unable to sign out ${error.message}");
                  } finally {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.pop();
                      setState(() {});
                    });
                    await windowManager.destroy();
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: appBar(context),
      content: widget.onLoaded(context),
    );
  }

  NavigationAppBar appBar(BuildContext context) {
    return NavigationAppBar(
      automaticallyImplyLeading: false,
      title: const DragToMoveArea(
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text("Otoscopia Admin"),
        ),
      ),
      actions: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ToggleSwitch(
              checked: context.isDark,
              onChanged: (v) {
                if (v) {
                  ref
                      .read(appThemeProvider.notifier)
                      .changeTheme(ThemeMode.dark);
                } else {
                  ref
                      .read(appThemeProvider.notifier)
                      .changeTheme(ThemeMode.light);
                }
              },
            ),
          ),
          SizedBox(
            width: 138,
            height: 50,
            child: WindowCaption(
              brightness: context.brightness,
              backgroundColor: AppColors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
