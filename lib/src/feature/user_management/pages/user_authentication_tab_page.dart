import 'package:flutter/material.dart' as m3;

import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:admin/src/core/index.dart';

class UserAuthenticationTabPage extends ConsumerStatefulWidget {
  const UserAuthenticationTabPage(this.data, {super.key});
  final Map<String, dynamic> data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserAuthenticationTabPageState();
}

class _UserAuthenticationTabPageState
    extends ConsumerState<UserAuthenticationTabPage> {
  late final UserDataSource source;
  int rowsPerPage = defaultRowsPerPage;
  int offset = 0;
  final controller = PaginatorController();
  final flyoutController = FlyoutController();
  Map<String, dynamic>? selectedUser;
  Offset? tapPosition;

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
                  _verifyEmail(selectedUser!);
                },
              ),
            if (!user['is_phone_verified'])
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.edit),
                text: const Text('Verify Phone Number'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _verifyPhoneNumber(selectedUser!);
                },
              ),
          ],
        );
      },
    );
  }

  // Action handlers
  void _verifyEmail(Map<String, dynamic> user) {
    logger.info('View details for user: ${user['name']}');
    // Implement view details logic
    showDialog(
      context: context,
      builder:
          (context) => ContentDialog(
            title: Text('User Details: ${user['name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${user['email']}'),
                Text('Status: ${user['status']}'),
                Text('MFA Enabled: ${user['mfa'] ? 'Yes' : 'No'}'),
                Text('Verified: ${user['verification'] ? 'Yes' : 'No'}'),
              ],
            ),
            actions: [
              Button(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void _verifyPhoneNumber(Map<String, dynamic> user) {
    logger.info('Edit user: ${user['name']}');
    // Implement edit user logic
  }

  @override
  void initState() {
    super.initState();
    source = UserDataSource(
      users: List.castFrom(widget.data['users']),
      onShowMenu: _showUserActions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: flyoutController,
      child: PaginatedDataTable2(
        source: source,
        controller: controller,
        rowsPerPage: 20,
        minWidth: 1500,
        columns: [
          DataColumn2(label: Text('Name')),
          DataColumn2(label: Text('Email')),
          DataColumn2(label: Text('Verification')),
          DataColumn2(label: Text('Status')),
          DataColumn2(label: Text('MFA')),
          DataColumn2(label: Text('Password Last Updated')),
          DataColumn2(label: Text('Password Expiration')),
        ],
      ),
    );
  }
}

class UserDataSource extends m3.DataTableSource {
  final List<Map<String, dynamic>> users;
  final Function(Map<String, dynamic> user, Offset position) onShowMenu;

  UserDataSource({required this.users, required this.onShowMenu}) {
    logger.info("User Data Source has been created");
  }

  @override
  DataRow2 getRow(int index) {
    final user = users[index];
    final hasPasswordExpiration = user['password_expiration'] != null;
    final lastPasswordUpdated = DateTime.parse(user['last_password_updated']);

    late final DateTime? passwordExpiration;
    if (hasPasswordExpiration) {
      passwordExpiration = DateTime.parse(user['password_expiration']);
    }

    final verification =
        user['verification'] ? getStatus('verified') : getStatus('unverified');
    final mfa = user['mfa'] ? getStatus('enabled') : getStatus('disabled');
    final activityStatus = getStatus(user['status']);

    final format = DateFormat('MMM. dd, yyyy HH:MM');
    final transmutedLastPasswordUpdated = format.format(lastPasswordUpdated);

    return DataRow2(
      cells: [
        m3.DataCell(Text(user['name'])),
        m3.DataCell(Text(user['email'])),
        m3.DataCell(StatusPill(verification)),
        m3.DataCell(StatusPill(activityStatus)),
        m3.DataCell(StatusPill(mfa)),
        m3.DataCell(Text(transmutedLastPasswordUpdated)),
        m3.DataCell(
          Text(
            hasPasswordExpiration
                ? format.format(passwordExpiration!)
                : 'Password does not expire',
          ),
        ),
      ],
      onSecondaryTapDown: (details) {
        if (verification == Status.unverified) {
          onShowMenu(user, details.globalPosition);
        }
      },
      onTap: () {
        // Optional: also show menu on tap-and-hold or implement row selection
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
