// ignore_for_file: avoid_build_context_in_providers
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';

part 'idle_timeout_provider.g.dart';

@Riverpod(keepAlive: true)
class IdleTimeout extends _$IdleTimeout {
  Timer? _timer;
  int _timeoutMinutes = 15; // Default timeout value
  DateTime _lastActivity = DateTime.now();
  StreamSubscription? _activitySubscription;

  @override
  bool build() {
    ref.onDispose(() {
      _cancelTimer();
      _activitySubscription?.cancel();
    });

    return false; // Initial idle state (false = not idle)
  }

  void initialize(BuildContext context) {
    // Start monitoring activity
    _startMonitoring(context);

    // Set up the initial timer
    _resetTimer(context);
  }

  void setTimeoutDuration(int minutes) {
    _timeoutMinutes = minutes;
    _resetTimer();
    logger.info('Idle timeout set to $_timeoutMinutes minutes');
  }

  void userActivity() {
    _lastActivity = DateTime.now();

    // If the user was previously considered idle, reset the state
    if (state) {
      state = false;
    }

    _resetTimer();
  }

  void _startMonitoring(BuildContext context) {
    // Create a focus node that will receive input events
    final FocusNode focusNode = FocusNode();
    FocusScope.of(context).requestFocus(focusNode);

    _activitySubscription = HardwareKeyboard()
        .syncKeyboardState()
        .asStream()
        .cast()
        .listen((_) => userActivity());

    // Listen for pointer/mouse events
    // _activitySubscription = ServicesBinding
    //     .instance
    //     .keyEventManager
    //     .keyMessageHandler
    //     .cast<KeyEvent>()
    //     .listen((_) => userActivity());
  }

  void _resetTimer([BuildContext? context]) {
    _cancelTimer();

    // Create a new timer
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkIdleState(context);
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _checkIdleState(BuildContext? context) {
    final now = DateTime.now();
    final idleTime = now.difference(_lastActivity).inMinutes;

    if (idleTime >= _timeoutMinutes) {
      if (!state) {
        logger.info(
          'User idle for $_timeoutMinutes minutes, triggering logout',
        );
        state = true;

        // If we should automatically log out, do it here
        if (context != null) {
          // Perform logout
          ref.read(authenticationProvider.notifier).signOut();
        }
      }
    }
  }
}
