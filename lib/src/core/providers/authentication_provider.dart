import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/core/models/user_model.dart';

part 'authentication_provider.g.dart';

@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  @override
  AuthenticationEntity build() {
    if (!kIsWeb) logger.info("Initializing authentication...");

    final initialState = AuthenticationEntity(isLoading: false, user: null);

    final user = isar.userModels.where().findFirst()?.toEntity();

    if (!kIsWeb) logger.info("Authentication Initialized...");

    if (user != null) {
      initializeAppwriteIds(
        collections: user.collectionIds,
        storages: user.storageIds,
        functions: user.functionIds,
      );
    }

    return initialState.copyWith(user: user);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    try {
      if (!kIsWeb) logger.info("Signing in user...");
      final response = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      await initializeAppwriteInjector(response);

      final List<dynamic> collections = List.from(collectionIds['collections']);

      final usersId =
          collections
              .where((collection) => collection['name'] == 'users')
              .first;

      final userResponse = await database.getDocument(
        databaseId: collectionIds['database'],
        collectionId: usersId['id']!,
        documentId: response.userId,
      );

      final user = UserEntity.fromAppwrite(
        user: userResponse,
        session: response,
        collectionIds: collectionIds,
        storageIds: storageIds,
        functionIds: functionIds,
      );

      final model = UserModel.fromEntity(user)..id = 0;

      await isar.writeAsync((isar) {
        return isar.userModels.put(model);
      });

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
      account.deleteSession(sessionId: state.user!.session!);
      await isar.writeAsync((isar) {
        return isar.userModels.delete(0);
      });
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

  Future<void> initializeAppwriteInjector(Session? session) async {
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
        'location': session?.countryName,
        'ip': session?.ip,
        'device': info,
        'resource': 'authentication',
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
  }) {
    collectionIds = collections;
    storageIds = storages;
    functionIds = functions;
  }
}
