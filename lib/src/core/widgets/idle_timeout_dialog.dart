import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';

class IdleTimeoutDialog {
  static Future<void> showWarning(
    BuildContext context,
    WidgetRef ref, {
    int warningBeforeSeconds = 60,
  }) async {
    // Create a timer that will automatically close the dialog and log out
    late Timer logoutTimer;
    int remainingSeconds = warningBeforeSeconds;

    logoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds--;

      if (remainingSeconds <= 0) {
        timer.cancel();
        Navigator.of(context, rootNavigator: true).pop();
        ref.read(authenticationProvider.notifier).signOut();
      }
    });

    // Show the warning dialog
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _TimeoutWarningDialog(
          remainingSeconds: remainingSeconds,
          onStayLoggedIn: () {
            logoutTimer.cancel();
            Navigator.of(dialogContext).pop();
          },
          onLogout: () {
            logoutTimer.cancel();
            Navigator.of(dialogContext).pop();
            ref.read(authenticationProvider.notifier).signOut();
          },
        );
      },
    ).then((_) {
      // Ensure timer is cancelled when dialog is closed
      if (logoutTimer.isActive) {
        logoutTimer.cancel();
      }
    });
  }
}

class _TimeoutWarningDialog extends StatefulWidget {
  final int remainingSeconds;
  final VoidCallback onStayLoggedIn;
  final VoidCallback onLogout;

  const _TimeoutWarningDialog({
    required this.remainingSeconds,
    required this.onStayLoggedIn,
    required this.onLogout,
  });

  @override
  State<_TimeoutWarningDialog> createState() => _TimeoutWarningDialogState();
}

class _TimeoutWarningDialogState extends State<_TimeoutWarningDialog> {
  late int _seconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _seconds = widget.remainingSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Session Timeout Warning'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your session is about to expire due to inactivity.',
            style: FluentTheme.of(context).typography.body,
          ),
          gap8,
          Text(
            'You will be automatically logged out in $_seconds seconds.',
            style: FluentTheme.of(context).typography.body,
          ),
          gap16,
          Text(
            'Do you want to stay logged in?',
            style: FluentTheme.of(context).typography.bodyStrong,
          ),
        ],
      ),
      actions: [
        Button(onPressed: widget.onLogout, child: const Text('Logout Now')),
        FilledButton(
          onPressed: widget.onStayLoggedIn,
          child: const Text('Stay Logged In'),
        ),
      ],
    );
  }
}
