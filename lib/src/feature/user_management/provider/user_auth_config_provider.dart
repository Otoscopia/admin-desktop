import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';

part 'user_auth_config_provider.g.dart';

@Riverpod(keepAlive: true)
class UserAuthConfig extends _$UserAuthConfig {
  @override
  FutureOr<UserAuthConfigEntity> build() async {
    return await fetchDocuments();
  }

  Future<UserAuthConfigEntity> fetchDocuments() async {
    final userConfig = database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('admin_users_account_configuration'),
      queries: [Query.limit(1)],
    );

    final idleSessionDropdown = database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('dropdown_selections'),
      queries: [Query.equal('key', 'idle-session-timout')],
    );

    final passwordExpirationDropdown = database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('dropdown_selections'),
      queries: [Query.equal('key', 'password-expiration')],
    );

    final passwordGraceperiodDropdown = database.listDocuments(
      databaseId: databaseId,
      collectionId: getCollectionId('dropdown_selections'),
      queries: [Query.equal('key', 'password-grace-period')],
    );

    final response = await Future.wait([
      userConfig,
      idleSessionDropdown,
      passwordExpirationDropdown,
      passwordGraceperiodDropdown,
    ]);

    return UserAuthConfigEntity(
      id: response[0].documents.first.$id,
      configuration: response[0].documents.first,
      idleSessionTimeout: response[1],
      passwordExpiration: response[2],
      passwordGracePeriod: response[3],
    );
  }

  Future<void> updateDocument(String key, {String? value, bool? mfa}) async {
    try {
      final data = state.value;
      if (data == null) return;

      // Update document in database
      await database.updateDocument(
        databaseId: databaseId,
        collectionId: getCollectionId('admin_users_account_configuration'),
        documentId: data.id,
        data: {key: value ?? mfa},
      );

      // Create an updated version of the configuration
      final doc = data.configuration;
      final updatedData = Map<String, dynamic>.from(doc.data);

      if (value != null) {
        // Handle dropdown values which are stored as objects with $id field
        if (updatedData.containsKey(key) && updatedData[key] is Map) {
          updatedData[key] = {'\$id': value};
        }
      } else if (mfa != null) {
        // Handle boolean toggle
        updatedData[key] = mfa;
      }

      // Create a new Document with updated data
      final updatedDoc = Document(
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: doc.$createdAt,
        $updatedAt: doc.$updatedAt,
        $permissions: doc.$permissions,
        data: updatedData,
      );

      // Create a new UserAuthConfigEntity with the updated configuration
      final updatedEntity = UserAuthConfigEntity(
        id: data.id,
        configuration: updatedDoc,
        passwordExpiration: data.passwordExpiration,
        passwordGracePeriod: data.passwordGracePeriod,
        idleSessionTimeout: data.idleSessionTimeout,
      );

      // Update the state with the new entity
      state = AsyncValue.data(updatedEntity);
    } on AppwriteException catch (_) {
      // Keep the current state on error rather than going to error state
      rethrow;
    }
  }
}
