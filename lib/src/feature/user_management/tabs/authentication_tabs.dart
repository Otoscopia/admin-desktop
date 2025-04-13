import 'dart:convert';

import 'package:appwrite/enums.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/user_management/pages/authentication_configuration.dart';
import 'package:admin/src/feature/user_management/pages/user_authentication_tab_page.dart';

class AuthenticationTabs extends ConsumerStatefulWidget {
  const AuthenticationTabs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationTabsState();
}

class _AuthenticationTabsState extends ConsumerState<AuthenticationTabs> {
  int currentIndex = 0;

  Future<Map<String, dynamic>> fetchUsers(String fnBody) async {
    final functionId = getFunctionId('users-authentication');

    final response = await functions.createExecution(
      functionId: functionId,
      method: ExecutionMethod.gET,
      body: fnBody,
    );

    return json.decode(response.responseBody);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authenticationProvider);
    return ScaffoldPage(
      padding: EdgeInsets.symmetric(vertical: Sizes.p4),
      content: FutureBuilder(
        future: fetchUsers(auth.logDetails("Authentication Tabs")),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ProgressRing());
          }
          if (snapshot.hasError) {
            return Center(
              child: InfoBar(
                title: Text('Error'),
                content: Text('Failed to load users: ${snapshot.error}'),
                severity: InfoBarSeverity.error,
                isLong: true,
              ),
            );
          }

          final response = snapshot.data!;

          return TabView(
            shortcutsEnabled: false,
            currentIndex: currentIndex,
            tabs: [
              Tab(
                icon: Icon(FluentIcons.group),
                text: Text('Users'),
                body: UserAuthenticationTabPage(response),
              ),
              Tab(
                text: Text('Configuration'),
                icon: Icon(FluentIcons.data_management_settings),
                body: AuthenticationConfiguration(),
              ),
            ],
            onChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
          );
        },
      ),
    );
  }
}
