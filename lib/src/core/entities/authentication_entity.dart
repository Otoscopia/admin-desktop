import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:admin/src/core/index.dart';

class AuthenticationEntity {
  final bool isLoading;
  final UserEntity? user;

  AuthenticationEntity({this.isLoading = false, this.user});

  AuthenticationEntity copyWith({bool? isLoading, UserEntity? user}) {
    return AuthenticationEntity(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }

  String logDetails(String event, {String? userId}) {
    late String info;
    if (kIsWeb) {
      final web = (device as WebBrowserInfo);
      info = "${web.platform} - ${web.browserName} - ${web.userAgent}";
    } else if (Platform.isWindows) {
      final win = (device as WindowsDeviceInfo);
      info = "${win.productName} - ${win.computerName} - ${win.buildLab}";
    } else if (Platform.isMacOS) {
      final mac = (device as MacOsDeviceInfo);
      info = "${mac.model} - ${mac.computerName} - ${mac.osRelease}";
    }

    return json.encode({
      'user': userId ?? user?.uid,
      'role': user?.roleId,
      'location': user?.location,
      'ip': user?.ip,
      'device': info,
      'event': event,
    });
  }
}
