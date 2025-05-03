import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin/src/core/index.dart';

part 'create_team_provider.g.dart';

@Riverpod(keepAlive: true)
class CreateTeams extends _$CreateTeams {
  @override
  TeamData build() {
    final team = TeamData(
      name: '',
      description: '',
      roleId: '',
      roleName: '',
      userIds: [],
      permissions: [],
    );

    return team;
  }

  void setTeam(TeamData? team) {
    if (team != null) {
      state = team;
    }
  }

  Future<TeamData> createTeam() async {
    try {
      final teamData = state;

      if (teamData.timeBased == true) {
        final response = await database.createDocument(
          databaseId: databaseId,
          collectionId: getCollectionId('time_based'),
          documentId: ID.unique(),
          data: {
            'value': teamData.timeBased,
            'start_date': teamData.startDate?.toIso8601String(),
            'end_date': teamData.endDate?.toIso8601String(),
          },
        );

        await database.createDocument(
          databaseId: databaseId,
          collectionId: getCollectionId('teams'),
          documentId: ID.unique(),
          data: {
            'name': teamData.name,
            'description': teamData.description,
            'assignment': teamData.roleId,
            'members': teamData.userIds,
            'time_based': response.$id,
            'permissions': teamData.permissions,
          },
        );
      } else {
        await database.createDocument(
          databaseId: databaseId,
          collectionId: getCollectionId('teams'),
          documentId: ID.unique(),
          data: {
            'name': teamData.name,
            'description': teamData.description,
            'assignment': teamData.roleId,
            'members': teamData.userIds,
            'time_based': null,
            'permissions': teamData.permissions,
          },
        );
      }

      await updateMembers(teamData.userIds, true);

      return teamData;
    } on AppwriteException catch (_) {
      rethrow;
    }
  }

  Future<TeamData> updateTeam() async {
    try {
      final teamData = state;

      if (teamData.timeBased == true) {
        await database.updateDocument(
          databaseId: databaseId,
          collectionId: getCollectionId('time_based'),
          documentId: teamData.timeBasedId ?? ID.unique(),
          data: {
            'value': teamData.timeBased,
            'start_date': teamData.startDate?.toIso8601String(),
            'end_date': teamData.endDate?.toIso8601String(),
          },
        );

        await database.updateDocument(
          databaseId: databaseId,
          collectionId: getCollectionId('teams'),
          documentId: teamData.id!,
          data: {
            'name': teamData.name,
            'description': teamData.description,
            'assignment': teamData.roleId,
            'members': teamData.userIds,
            'time_based': teamData.timeBasedId!,
            'permissions': teamData.permissions,
          },
        );
      } else {
        await database.updateDocument(
          databaseId: databaseId,
          collectionId: getCollectionId('teams'),
          documentId: teamData.id!,
          data: {
            'name': teamData.name,
            'description': teamData.description,
            'assignment': teamData.roleId,
            'members': teamData.userIds,
            'time_based': null,
            'permissions': teamData.permissions,
          },
        );
      }

      await updateMembers(teamData.userIds, true);

      if (teamData.unselectedMember != null) {
        await updateMembers(teamData.unselectedMember!, false);
      }

      return teamData;
    } on AppwriteException catch (_) {
      rethrow;
    }
  }

  Future<void> removeMember(
    Map<String, dynamic> data,
    user,
    teamId,
    userId,
  ) async {
    final updatedMembers =
        List.from(
          data['members'],
        ).where((u) => u['\$id'] != user['\$id']).toList();

    await database.updateDocument(
      databaseId: databaseId,
      collectionId: getCollectionId('teams'),
      documentId: teamId,
      data: {'members': updatedMembers},
    );

    await database.updateDocument(
      databaseId: databaseId,
      collectionId: getCollectionId('users'),
      documentId: userId,
      data: {'has_team': false},
    );
  }

  Future<void> deleteTeam(TeamData team) async {
    await updateMembers(team.userIds, false);

    await database.updateDocument(
      databaseId: databaseId,
      collectionId: getCollectionId('teams'),
      documentId: team.id!,
      data: {'members': []},
    );

    await database.deleteDocument(
      databaseId: databaseId,
      collectionId: getCollectionId('teams'),
      documentId: team.id!,
    );
  }

  Future<void> updateMembers(List<String> members, bool value) async {
    for (final userId in members) {
      await database.updateDocument(
        databaseId: databaseId,
        collectionId: getCollectionId('users'),
        documentId: userId,
        data: {'has_team': value},
      );
    }
  }

  void updateTeamDetails({
    String? id,
    String? name,
    String? description,
    String? roleId,
    String? roleName,
    List<String>? userIds,
    List<String>? permissions,
    bool? timeBased,
    DateTime? startDate,
    String? timeBasedId,
    DateTime? endDate,
    List<String>? unselectedMember,
  }) {
    final team = state;
    state = team.copyWith(
      id: id,
      name: name,
      description: description,
      roleId: roleId,
      roleName: roleName,
      userIds: userIds,
      permissions: permissions,
      timeBased: timeBased,
      startDate: startDate,
      endDate: endDate,
      timeBasedId: timeBasedId,
      unselectedMember: unselectedMember,
    );
  }
}
