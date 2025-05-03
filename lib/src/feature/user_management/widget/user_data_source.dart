import 'dart:convert';

import 'package:flutter/material.dart' as m3;

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

import 'package:admin/src/core/index.dart';

class UserDataSource extends AsyncDataTableSource {
  final String fnbody;
  final Function(Map<String, dynamic> user, Offset position) onShowMenu;
  final Function({required String name, required String uid}) onUserTabPressed;

  UserDataSource({
    required this.fnbody,
    required this.onShowMenu,
    required this.onUserTabPressed,
  }) {
    logger.info("User Data Source has been created");
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    try {
      final functionId = getFunctionId('users-account-lifecycle');

      final body = {
        ...json.decode(fnbody),
        "limit": count,
        "offset": startIndex,
      };

      final response = await functions.createExecution(
        functionId: functionId,
        method: ExecutionMethod.gET,
        body: json.encode(body),
      );

      final parseData = json.decode(response.responseBody);
      final total = parseData['total'];
      final rows =
          List.castFrom(parseData['users']).asMap().entries.map((d) {
            final index = d.key;
            final e = d.value;
            final dateFormat = DateFormat('MMM. dd, yyyy');

            final id = e['id'];
            final name = e['name'];
            final role = (e['role'] as String).uppercaseFirst();
            final email = e['email'];

            final date = DateTime.parse(e['created_at']);
            final createdAt = dateFormat.format(date);
            final activityStatus = getStatus(e['activity_status']);
            final accountStatus = getStatus(e['account_status']);

            final lastPasswordUpdated = DateTime.parse(
              e['last_password_updated'],
            );

            final verification =
                e['verification']
                    ? getStatus('verified')
                    : getStatus('unverified');
            final mfa = e['mfa'] ? getStatus('enabled') : getStatus('disabled');

            final transmutedLastPasswordUpdated = dateFormat.format(
              lastPasswordUpdated,
            );

            // Check if this row is selected
            final isSelected = selectionRowKeys.contains(ValueKey(index));

            final DateTime passwordExpirationDate = lastPasswordUpdated.add(
              Duration(days: int.parse(e['password_expiration'])),
            );

            // Calculate days remaining until expiration
            final int daysRemaining =
                passwordExpirationDate.difference(DateTime.now()).inDays;

            // Format the message based on days remaining
            String expirationMessage;
            if (daysRemaining < 0) {
              expirationMessage = "Password expired ${-daysRemaining} days ago";
            } else if (daysRemaining == 0) {
              expirationMessage = "Password expires today";
            } else if (daysRemaining == 1) {
              expirationMessage = "Password expires tomorrow";
            } else {
              expirationMessage = "Password expires in $daysRemaining days";
            }

            return DataRow2(
              onTap: () => onUserTabPressed(name: name, uid: id),
              onSecondaryTapDown: (details) {
                onShowMenu(e, details.globalPosition);
                // if (verification == Status.unverified) {
                // }
              },
              onSelectChanged: (value) {
                setRowSelection(ValueKey(index), value ?? false);
              },
              selected: isSelected,
              cells: [
                m3.DataCell(Text(name)),
                m3.DataCell(Text(role)),
                m3.DataCell(Text(email)),
                m3.DataCell(StatusPill(activityStatus)),
                m3.DataCell(StatusPill(accountStatus)),
                m3.DataCell(StatusPill(verification)),
                m3.DataCell(StatusPill(mfa)),
                m3.DataCell(Text(transmutedLastPasswordUpdated)),
                m3.DataCell(Text(expirationMessage)),
                m3.DataCell(Text(createdAt)),
              ],
            );
          }).toList();

      return AsyncRowsResponse(total, rows);
    } on AppwriteException catch (e) {
      logger.error('Something went wrong ${e.message}');
      return AsyncRowsResponse(0, []);
    }
  }
}
