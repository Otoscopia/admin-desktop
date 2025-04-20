import 'dart:convert';

import 'package:appwrite/enums.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/user_management/widget/user_data_source.dart';

class UserTabPage extends ConsumerStatefulWidget {
  const UserTabPage({super.key, required this.onUserTabPressed});
  final Function({required String name, required String uid}) onUserTabPressed;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserTabPageState();
}

class _UserTabPageState extends ConsumerState<UserTabPage> {
  late final UserDataSource source;
  int rowsPerPage = defaultRowsPerPage;
  int offset = 0;
  final controller = PaginatorController();
  final flyoutController = FlyoutController();
  Map<String, dynamic>? selectedUser;
  Offset? tapPosition;

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authenticationProvider);
    source = UserDataSource(
      onUserTabPressed: widget.onUserTabPressed,
      fnbody: auth.logDetails(geteventId('logs-filter')),
      onShowMenu: _showUserActions,
    );
  }

  void _showUserActions(Map<String, dynamic> user, Offset position) {
    setState(() {
      selectedUser = user;
      tapPosition = position;
    });

    flyoutController.showFlyout(
      barrierColor: Colors.transparent,
      position: position,
      builder: (context) {
        return MenuFlyout(
          constraints: const BoxConstraints(maxWidth: 250.0),
          items: [
            if (!user['is_email_verified'])
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.contact_info),
                text: const Text('Verify Email'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _verifyEmail(selectedUser!);
                },
              ),
            if (!user['is_phone_verified'])
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.edit),
                text: const Text('Verify Phone Number'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _verifyPhoneNumber(selectedUser!);
                },
              ),
          ],
        );
      },
    );
  }

  Future<void> _verifyEmail(Map<String, dynamic> user) async {
    final auth = ref.read(authenticationProvider);
    final response = await functions.createExecution(
      functionId: getFunctionId('verify-email'),
      body: auth.logDetails(geteventId('verify-email'), userId: user['id']),
      method: ExecutionMethod.pOST,
    );

    final data = json.decode(response.responseBody);
    final severity = InfoBarSeverity.values.firstWhere(
      (element) => element.name == data['severity'],
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            title: Text(data['title']),
            content: Text(data['message']),
            severity: severity,
          );
        },
      );
    });
  }

  Future<void> _verifyPhoneNumber(Map<String, dynamic> user) async {
    final auth = ref.read(authenticationProvider);
    final response = await functions.createExecution(
      functionId: getFunctionId('verify-phone'),
      body: auth.logDetails(geteventId('verify-phone'), userId: user['id']),
      method: ExecutionMethod.pOST,
    );

    final data = json.decode(response.responseBody);
    final severity = InfoBarSeverity.values.firstWhere(
      (element) => element.name == -data['severity'],
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            title: Text(data['title']),
            content: Text(data['message']),
            severity: severity,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: flyoutController,
      child: AsyncTable(
        showCheckboxColumn: false,
        minWidth: 2000,
        source: source,
        columns: [
          DataColumn2(label: Text('Name'), size: ColumnSize.L),
          DataColumn2(label: Text('Role'), size: ColumnSize.S),
          DataColumn2(label: Text('Email')),
          DataColumn2(label: Text('Account Status')),
          DataColumn2(label: Text('Activity Status')),
          DataColumn2(label: Text('Verification')),
          DataColumn2(label: Text('MFA')),
          DataColumn2(label: Text('Password Last Updated')),
          DataColumn2(label: Text('Password Expiration')),
          DataColumn2(label: Text('Created At'), size: ColumnSize.S),
        ],
      ),
    );
  }
}
