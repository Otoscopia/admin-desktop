import 'package:appwrite/appwrite.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:admin/src/core/models/user_model.dart';

part 'authentication_provider.g.dart';

@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  @override
  AuthenticationEntity build() {
    logger.info("Initializing authentication...");

    final initialState = AuthenticationEntity(isLoading: true, user: null);

    final userModel = isar.userModels.where().findFirstAsync();

    userModel.then((value) {
      if (value != null) {
        state = AuthenticationEntity(isLoading: false, user: value.toEntity());
      } else {
        state = AuthenticationEntity(isLoading: false, user: null);
      }
    });

    return initialState;
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    try {
      logger.info("Signing in user...");
      final response = await account.createEmailPasswordSession(
          email: email, password: password);

      final accountResponse = await account.get();

      final userResponse = await database.getDocument(
        databaseId: Env.database,
        collectionId: Env.userCollection,
        documentId: response.userId,
      );

      final user = UserEntity.fromUser(
        user: userResponse,
        session: response.$id,
        account: accountResponse,
      );

      await isar.writeAsync((isar) {
        return isar.userModels.put(UserModel.fromEntity(user)..id = 0);
      });

      state = state.copyWith(isLoading: false, user: user);
    } on AppwriteException catch (error, stackTrace) {
      logger.error("Error signing in user: ${error.message}");
      throw Exception([error.message, stackTrace]);
    } catch (error, stackTrace) {
      logger.error(
          "An error occurred while signing in the user: ${error.toString()}");
      throw Exception([error, stackTrace]);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    logger.info("Signing user out...");
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
          "An error occurred while signing out the user: ${error.toString()}");
      throw Exception([error, stackTrace]);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
