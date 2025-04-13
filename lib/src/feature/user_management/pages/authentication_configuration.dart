import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/user_management/widget/configuration_container.dart';

class AuthenticationConfiguration extends ConsumerStatefulWidget {
  const AuthenticationConfiguration({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationConfigurationState();
}

class _AuthenticationConfigurationState
    extends ConsumerState<AuthenticationConfiguration> {
  // Future<Document> fetchDetails() async {
  //   final response = await database.listDocuments(
  //     databaseId: databaseId,
  //     collectionId: getCollectionId('users'),
  //     queries: [Query.equal('key', 'admin-auth-configuration')],
  //   );

  //   return response.documents.first;
  // }
  bool mfa = false;

  String selectedPasswordExpiration = "60";
  final passwordExpirationDurations = [
    ComboBoxItem(value: "60", child: Text("60 Days")),
    ComboBoxItem(value: "90", child: Text("90 Days")),
    ComboBoxItem(value: "180", child: Text("180 Days")),
    ComboBoxItem(value: "170", child: Text("170 Days")),
    ComboBoxItem(value: "365", child: Text("365 Days (1 Year)")),
  ];

  String selectedPasswordExpirationPeriod = "1";
  final passwordEpirationGracePeriod = [
    ComboBoxItem(value: "1", child: Text("1 Day")),
    ComboBoxItem(value: "2", child: Text("2 Days")),
    ComboBoxItem(value: "3", child: Text("3 Days")),
    ComboBoxItem(value: "4", child: Text("4 Days")),
    ComboBoxItem(value: "5", child: Text("5 Days")),
    ComboBoxItem(value: "6", child: Text("6 Days")),
    ComboBoxItem(value: "7", child: Text("7 Day (1 Week)")),
  ];

  String selectedIdleSession = "15";
  final idleSessionTimeout = [
    ComboBoxItem(value: "15", child: Text("15 Minutes")),
    ComboBoxItem(value: "30", child: Text("30 Minutes")),
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: FutureBuilder(
        // future: fetchDetails(),
        future: Future.delayed(Duration(milliseconds: 50)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ProgressRing());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Something wen't wrong ${snapshot.error}"),
            );
          }

          // final user = snapshot.data as Document;

          return Padding(
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
                    onChanged:
                        (value) =>
                            setState(() => selectedPasswordExpiration = value),
                  ),
                  ConfigurationContainer(
                    'Password Expiration Grace Period',
                    items: passwordEpirationGracePeriod,
                    value: selectedPasswordExpirationPeriod,
                    onChanged:
                        (value) => setState(
                          () => selectedPasswordExpirationPeriod = value,
                        ),
                  ),
                  ConfigurationContainer(
                    'Idle Session timeoute (in minutes)',
                    items: idleSessionTimeout,
                    value: selectedIdleSession,
                    onChanged:
                        (value) => setState(() => selectedIdleSession = value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mandatory Multi-Factor Authentication'),
                      ToggleSwitch(
                        checked: mfa,
                        onChanged: (value) {
                          setState(() {
                            mfa = value;
                          });
                        },
                      ),
                      SizedBox(width: 210),
                    ],
                  ),
                  // Row(mainAxisAlignment: MainAxisAlignment.end),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
