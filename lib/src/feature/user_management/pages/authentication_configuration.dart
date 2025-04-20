import 'package:appwrite/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/core/services/document_list_extensions.dart';
import 'package:admin/src/feature/user_management/widget/configuration_container.dart';

class AuthenticationConfiguration extends ConsumerStatefulWidget {
  final DocumentList configuration;
  final DocumentList passwordExpiration;
  final DocumentList passwordGracePeriod;
  final DocumentList idleSessionTimeout;

  const AuthenticationConfiguration({
    super.key,
    required this.configuration,
    required this.passwordExpiration,
    required this.passwordGracePeriod,
    required this.idleSessionTimeout,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationConfigurationState();
}

class _AuthenticationConfigurationState
    extends ConsumerState<AuthenticationConfiguration> {
  String id = '';
  bool mfa = false;
  String selectedIdleSession = '';
  String selectedPasswordExpiration = '';
  String selectedPasswordExpirationPeriod = '';

  late final List<ComboBoxItem<String>> passwordExpirationDurations;

  late final List<ComboBoxItem<String>> passwordGracePeriod;

  late final List<ComboBoxItem<String>> idleSessionTimeout;

  @override
  void initState() {
    final configuration = widget.configuration.toConfiguration(
      widget.configuration,
    );

    id = configuration['\$id'];
    mfa = configuration['mfa_status'];
    selectedIdleSession = configuration['idle_session_timeout']['\$id'];
    selectedPasswordExpiration = configuration['password_expiration']['\$id'];
    selectedPasswordExpirationPeriod =
        configuration['password_grace_period']['\$id'];

    passwordExpirationDurations = widget.passwordExpiration
        .toPasswordExpiration(widget.passwordExpiration);

    passwordGracePeriod = widget.passwordGracePeriod.toPasswordExpiration(
      widget.passwordGracePeriod,
    );

    idleSessionTimeout = widget.idleSessionTimeout.toPasswordExpiration(
      widget.idleSessionTimeout,
    );
    super.initState();
  }

  Future<void> updateDocument(
    String key, {
    String? value,
    bool mfa = false,
  }) async {
    await database.updateDocument(
      databaseId: databaseId,
      collectionId: getCollectionId('admin_users_account_configuration'),
      documentId: id,
      data: {key: value ?? mfa},
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(padding: const EdgeInsets.only(top: Sizes.p24)),
              Text("Settings").titleSmallBold,
              ConfigurationContainer(
                'Default Password Expiration Duration',
                items: passwordExpirationDurations,
                value: selectedPasswordExpiration,
                onChanged: (value) async {
                  await updateDocument('password_expiration', value: value);
                  setState(() => selectedPasswordExpiration = value);
                },
              ),
              ConfigurationContainer(
                'Password Expiration Grace Period',
                items: passwordGracePeriod,
                value: selectedPasswordExpirationPeriod,
                onChanged: (value) async {
                  await updateDocument('password_grace_period', value: value);
                  setState(() => selectedPasswordExpirationPeriod = value);
                },
              ),
              ConfigurationContainer(
                'Idle Session timeoute (in minutes)',
                items: idleSessionTimeout,
                value: selectedIdleSession,
                onChanged: (value) async {
                  await updateDocument('idle_session_timeout', value: value);
                  setState(() => selectedIdleSession = value);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mandatory Multi-Factor Authentication'),
                  ToggleSwitch(
                    checked: mfa,
                    onChanged: (value) async {
                      await updateDocument('mfa_status', mfa: value);
                      setState(() => mfa = value);
                    },
                  ),
                  SizedBox(width: 210),
                ],
              ),
              // Row(mainAxisAlignment: MainAxisAlignment.end),
            ],
          ),
        ),
      ),
    );
  }
}
