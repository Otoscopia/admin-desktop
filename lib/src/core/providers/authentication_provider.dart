import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';

part 'authentication_provider.g.dart';

@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  @override
  AuthenticationEntity build() {
    return AuthenticationEntity(isLoading: false, user: null);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    try {
      if (!kIsWeb) logger.info("Signing in user...");
      final response = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final userResponse = await database.getDocument(
        databaseId: Env.database,
        collectionId: Env.users,
        documentId: response.userId,
      );

      await initializeAppwriteInjector(
        response,
        userResponse.data['role']['\$id'],
      );

      final user = UserEntity.fromAppwrite(
        user: userResponse,
        session: response,
        collectionIds: collectionIds,
        storageIds: storageIds,
        functionIds: functionIds,
        eventIds: eventIds,
      );

      state = state.copyWith(isLoading: false, user: user);
    } on AppwriteException catch (error, stackTrace) {
      logger.error("Error signing in user: ${error.message}");
      throw Exception([error.message, stackTrace]);
    } catch (error, stackTrace) {
      logger.error(
        "An error occurred while signing in the user: ${error.toString()}",
      );
      throw Exception([error, stackTrace]);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb) logger.info("Signing user out...");
    state = state.copyWith(isLoading: true);
    try {
      await account.deleteSession(sessionId: state.user!.session!);
    } on AppwriteException catch (error, stackTrace) {
      logger.error("Error signing out user: ${error.message}");
      throw Exception([error.message, stackTrace]);
    } catch (error, stackTrace) {
      logger.error(
        "An error occurred while signing out the user: ${error.toString()}",
      );
      throw Exception([error, stackTrace]);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> initializeAppwriteInjector(Session? session, String role) async {
    try {
      late final Execution response;

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

      final body = {
        'user': session?.userId,
        'role': role,
        'location': session?.countryName,
        'ip': session?.ip,
        'device': info,
        'resource': '6803beaf00232580b773',
      };

      response = await functions.createExecution(
        functionId: Env.appwriteInjector,
        body: json.encode(body),
        method: ExecutionMethod.gET,
      );

      final jsonResponse =
          json.decode(response.responseBody) as Map<String, dynamic>;

      initializeAppwriteIds(
        collections: jsonResponse['databases'],
        storages: jsonResponse['buckets'],
        functions: jsonResponse['functions'],
        events: jsonResponse['events'],
      );
    } catch (error) {
      logger.error(
        "An error occured while initializing appwrite injector ${error.toString()}",
      );
    }
  }

  void initializeAppwriteIds({
    required collections,
    required storages,
    required functions,
    required events,
  }) {
    collectionIds = collections;
    storageIds = storages;
    functionIds = functions;
    eventIds = events;
  }
}
