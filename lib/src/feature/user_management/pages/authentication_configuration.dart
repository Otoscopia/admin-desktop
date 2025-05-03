import 'package:appwrite/appwrite.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/core/services/document_list_extensions.dart';
import 'package:admin/src/feature/user_management/provider/user_auth_config_provider.dart';
import 'package:admin/src/feature/user_management/widget/configuration_container.dart';

class AuthenticationConfiguration extends ConsumerStatefulWidget {
  const AuthenticationConfiguration({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationConfigurationState();
}

class _AuthenticationConfigurationState
    extends ConsumerState<AuthenticationConfiguration> {
  bool mfa = false;
  String selectedIdleSession = '';
  String selectedPasswordExpiration = '';
  String selectedPasswordExpirationPeriod = '';

  late List<ComboBoxItem<String>> passwordExpirationDurations;

  late List<ComboBoxItem<String>> passwordGracePeriod;

  late List<ComboBoxItem<String>> idleSessionTimeout;

  Future<void> updateDocument(String key, {String? value, bool? mfa}) async {
    try {
      if (value != null) {
        logger.info(value);
        switch (key) {
          case 'password_expiration':
            setState(() => selectedPasswordExpiration = value);
            break;
          case 'password_grace_period':
            setState(() => selectedPasswordExpirationPeriod = value);
            break;
          case 'idle_session_timeout':
            setState(() => selectedIdleSession = value);
            break;
        }
      } else if (mfa != null) {
        logger.info(this.mfa.toString());
        setState(() => this.mfa = mfa);
        logger.info(mfa.toString());
      }

      await ref
          .read(userAuthConfigProvider.notifier)
          .updateDocument(key, value: value, mfa: mfa);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('Configuration Saved!'),
              content: const Text(
                'Users Configuration has been saved, All users will be notified via in-app notification.',
              ),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: close,
              ),
              severity: InfoBarSeverity.info,
            );
          },
        );
      });
    } on AppwriteException catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('Configuration has not been saved!'),
              content: Text(
                'Something went wrong, please contact technical support. ${error.message}',
              ),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: close,
              ),
              severity: InfoBarSeverity.error,
            );
          },
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize these with empty lists
    passwordExpirationDurations = [];
    passwordGracePeriod = [];
    idleSessionTimeout = [];
  }

  @override
  Widget build(BuildContext context) {
    final configState = ref.watch(userAuthConfigProvider);

    return configState.when(
      data: (data) {
        final configuration = data.configuration.data;
        mfa = configuration['mfa_status'];
        logger.info(mfa.toString());
        selectedIdleSession = configuration['idle_session_timeout']['\$id'];
        selectedPasswordExpiration =
            configuration['password_expiration']['\$id'];
        selectedPasswordExpirationPeriod =
            configuration['password_grace_period']['\$id'];

        passwordExpirationDurations = data.passwordExpiration
            .toPasswordExpiration(data.passwordExpiration);
        passwordGracePeriod = data.passwordGracePeriod.toPasswordExpiration(
          data.passwordGracePeriod,
        );
        idleSessionTimeout = data.idleSessionTimeout.toPasswordExpiration(
          data.idleSessionTimeout,
        );

        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.all(Sizes.p24),
            child: SizedBox(
              width: 650,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: Sizes.p24,
                children: [
                  const Padding(padding: EdgeInsets.only(top: Sizes.p24)),
                  const Text("Settings").titleSmallBold,

                  // Display a loading indicator for individual settings if they're being updated
                  ConfigurationContainer(
                    'Default Password Expiration Duration',
                    items: passwordExpirationDurations,
                    value: selectedPasswordExpiration,
                    onChanged: (value) async {
                      // Update local state immediately for responsive UI
                      setState(() => selectedPasswordExpiration = value);
                      await updateDocument('password_expiration', value: value);
                    },
                  ),

                  ConfigurationContainer(
                    'Password Expiration Grace Period',
                    items: passwordGracePeriod,
                    value: selectedPasswordExpirationPeriod,
                    onChanged: (value) async {
                      setState(() => selectedPasswordExpirationPeriod = value);
                      await updateDocument(
                        'password_grace_period',
                        value: value,
                      );
                    },
                  ),

                  ConfigurationContainer(
                    'Idle Session timeout (in minutes)',
                    items: idleSessionTimeout,
                    value: selectedIdleSession,
                    onChanged: (value) async {
                      setState(() => selectedIdleSession = value);
                      await updateDocument(
                        'idle_session_timeout',
                        value: value,
                      );
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Mandatory Multi-Factor Authentication'),
                      ToggleSwitch(
                        checked: mfa,
                        onChanged: (value) async {
                          setState(() => mfa = value);
                          await updateDocument('mfa_status', mfa: value);
                        },
                      ),
                      const SizedBox(width: 210),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Something went wrong: ${error.toString()}"),
              gap16,
              FilledButton(child: const Text("Retry"), onPressed: () {}),
            ],
          ),
        );
      },
      loading: () => const LoadingPage(),
    );
  }
}
