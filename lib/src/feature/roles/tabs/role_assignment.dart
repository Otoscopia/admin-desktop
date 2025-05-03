import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/roles/pages/create_team.dart';
import 'package:admin/src/feature/roles/provider/create_team_provider.dart';

class RoleAssignment extends ConsumerStatefulWidget {
  const RoleAssignment({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoleAssignmentState();
}

class _RoleAssignmentState extends ConsumerState<RoleAssignment> {
  final controller = TextEditingController();
  final Map<String, FlyoutController> _flyoutMemberControllers = {};
  final Map<String, FlyoutController> _flyoutTeamControllers = {};

  Future<List<DocumentList?>> fetchData() async {
    final fetchCollections = ['roles', 'users', 'teams'];
    final userQuery = Query.contains('readable_name', controller.text);

    return await Future.wait(
      fetchCollections.map((collection) {
        final queries = [collection == 'users' ? userQuery : Query.limit(1000)];

        return database.listDocuments(
          databaseId: databaseId,
          collectionId: getCollectionId(collection),
          queries: queries,
        );
      }),
    );
  }

  Future<void> createTeam() async {
    try {
      final teamData =
          await ref.read(createTeamsProvider.notifier).createTeam();
      await displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            title: Text("Success"),
            content: Text("Team ${teamData.name} created successfully"),
            severity: InfoBarSeverity.success,
            isLong: true,
            onClose: close,
          );
        },
      );
    } on AppwriteException catch (e) {
      await displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            title: Text("Something went wrong!"),
            content: Text("Unable to create team: ${e.message}"),
            severity: InfoBarSeverity.error,
            isLong: true,
            onClose: close,
          );
        },
      );
    } finally {
      setState(() {});
    }
  }

  Future<void> saveTeam() async {
    try {
      final teamData =
          await ref.read(createTeamsProvider.notifier).updateTeam();
      await displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            title: Text("Success"),
            content: Text("Team ${teamData.name} edited successfully"),
            severity: InfoBarSeverity.success,
            isLong: true,
            onClose: close,
          );
        },
      );
    } on AppwriteException catch (e) {
      await displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            title: Text("Something went wrong!"),
            content: Text("Unable to edit team: ${e.message}"),
            severity: InfoBarSeverity.error,
            isLong: true,
            onClose: close,
          );
        },
      );
    } finally {
      setState(() {});
    }
  }

  void showContentDialog(
    BuildContext context,
    DocumentList roles,
    DocumentList users,
  ) async {
    Size size = MediaQuery.of(context).size;
    double width = size.width / .25;
    double height = size.height * .75;

    final filtered =
        users.documents.where((u) => u.data['has_team'] != true).toList();

    await showDialog<String>(
      context: context,
      builder:
          (context) => ContentDialog(
            constraints: BoxConstraints(maxWidth: width, maxHeight: height),
            title: const Text('Create Teams'),
            content: CreateTeam(
              roles: roles,
              users: filtered,
              isEditing: false,
            ),
            actions: [
              FilledButton(
                child: const Text('Create'),
                onPressed: () async {
                  await createTeam();
                  Navigator.pop(context);
                },
              ),
              Button(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void showEditDialog(
    BuildContext context,
    DocumentList roles,
    DocumentList users, {
    TeamData? team,
  }) async {
    Size size = MediaQuery.of(context).size;
    double width = size.width / .25;
    double height = size.height * .75;

    final filtered = users.documents.where((u) => true).toList();

    await showDialog<String>(
      context: context,
      builder:
          (context) => ContentDialog(
            constraints: BoxConstraints(maxWidth: width, maxHeight: height),
            title: const Text('Edit Team'),
            content: CreateTeam(
              roles: roles,
              users: filtered,
              isEditing: true,
              team: team,
            ),
            actions: [
              FilledButton(
                child: const Text('Save Changes'),
                onPressed: () async {
                  await saveTeam();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pop(context);
                  });
                },
              ),
              Button(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  List<Widget> rolesWidgets(DocumentList roles, DocumentList users) {
    return roles.documents.asMap().entries.map((d) {
      final id = d.value.$id;
      final data = d.value.data;

      final roleUsers =
          users.documents.where((user) {
            return (user.data['role']['\$id'] as String) == id &&
                user.data['has_team'] != true;
          }).toList();

      final roleName =
          data['key'] == 'admin'
              ? 'IAM Administrator'
              : (data['key'] as String).uppercaseFirst();

      return Padding(
        padding: EdgeInsets.only(top: d.key == 0 ? Sizes.p8 : Sizes.p24),
        child: Expander(
          leading: Icon(FluentIcons.health_solid),
          header: Text("$roleName (${roleUsers.length})"),
          content: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100, maxHeight: 250),
            child: ListView.builder(
              itemCount: roleUsers.length,
              itemBuilder: (context, index) {
                final user = roleUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.theme.inactiveBackgroundColor,
                    backgroundImage:
                        Image.network(
                          "https://robohash.org/${user.$id}?set=set4",
                        ).image,
                  ),
                  title: Text(user.data['readable_name']),
                  subtitle: Text(user.data['email']),
                );
              },
            ),
          ),
        ),
      );
    }).toList();
  }

  FlyoutController _getMemberFlyoutController(String userId) {
    if (!_flyoutMemberControllers.containsKey(userId)) {
      _flyoutMemberControllers[userId] = FlyoutController();
    }
    return _flyoutMemberControllers[userId]!;
  }

  FlyoutController _getTeamFlyoutController(String teamId) {
    if (!_flyoutTeamControllers.containsKey(teamId)) {
      _flyoutTeamControllers[teamId] = FlyoutController();
    }
    return _flyoutTeamControllers[teamId]!;
  }

  List<Widget> teamsWidgets(
    DocumentList teams,
    DocumentList roles,
    DocumentList users,
  ) {
    return teams.documents.map((team) {
      final data = team.data;
      final id = team.$id;
      final teamName = (data['name'] as String).uppercaseFirst();
      final description = data['description'];
      final roleId = data['assignment']['\$id'];
      final roleName = (data['assignment']['key'] as String).uppercaseFirst();
      final teamUsers = List.from(data['members']);
      final teamFlyoutController = _getTeamFlyoutController(team.$id);

      final teamUsersId = teamUsers.map((d) => d['\$id'] as String).toList();
      final permissions = List<String>.from(data['permissions']);

      final isTimeBased = data['time_based'] != null;

      final teamData = TeamData(
        id: id,
        name: teamName,
        description: description ?? '',
        roleId: roleId,
        roleName: roleName,
        userIds: teamUsersId,
        permissions: permissions,
        timeBased: isTimeBased ? true : false,
        timeBasedId: isTimeBased ? data['time_based']['\$id'] : '',
        startDate:
            isTimeBased
                ? DateTime.parse(data['time_based']['start_date'])
                : null,
        endDate:
            isTimeBased ? DateTime.parse(data['time_based']['end_date']) : null,
      );

      return Padding(
        padding: const EdgeInsets.only(top: Sizes.p24),
        child: GestureDetector(
          // This is for the entire team container right-click
          onSecondaryTapDown: (details) {
            teamFlyoutController.showFlyout(
              position: details.globalPosition,
              builder: (context) {
                return MenuFlyout(
                  constraints: const BoxConstraints(maxWidth: 250.0),
                  items: [
                    MenuFlyoutItem(
                      leading: const Icon(FluentIcons.delete),
                      text: Text('Delete team $teamName'),
                      onPressed: () async {
                        Navigator.pop(context);
                        try {
                          await ref
                              .read(createTeamsProvider.notifier)
                              .deleteTeam(teamData);

                          displayInfoBar(
                            context,
                            builder: (context, close) {
                              return InfoBar(
                                title: Text("Success"),
                                content: Text("Team deleted successfully"),
                                severity: InfoBarSeverity.success,
                                isLong: true,
                                onClose: close,
                              );
                            },
                          );
                        } catch (e) {
                          displayInfoBar(
                            context,
                            builder: (context, close) {
                              return InfoBar(
                                title: Text("Error"),
                                content: Text("Failed to delete team: $e"),
                                severity: InfoBarSeverity.error,
                                isLong: true,
                                onClose: close,
                              );
                            },
                          );
                        } finally {
                          setState(() {});
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: FlyoutTarget(
            controller: teamFlyoutController,
            child: Expander(
              leading: Icon(FluentIcons.teamwork),
              trailing: Button(
                child: Text('Edit Team'),
                onPressed: () {
                  showEditDialog(context, roles, users, team: teamData);
                },
              ),
              header: Text("$teamName (${teamUsers.length})"),
              content: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100, maxHeight: 250),
                child: ListView.builder(
                  itemCount: teamUsers.length,
                  itemBuilder: (context, index) {
                    final user = teamUsers[index];
                    final userId = user['\$id'] as String;
                    final flyoutController = _getMemberFlyoutController(userId);

                    return FlyoutTarget(
                      controller: flyoutController,
                      child: GestureDetector(
                        onDoubleTapDown: (details) {
                          flyoutController.showFlyout(
                            position: details.globalPosition,
                            builder: (context) {
                              return MenuFlyout(
                                constraints: const BoxConstraints(
                                  maxWidth: 250.0,
                                ),
                                items: [
                                  MenuFlyoutItem(
                                    leading: const Icon(
                                      FluentIcons.user_remove,
                                    ),
                                    text: Text(
                                      'Remove ${user['readable_name']} from Team',
                                    ),
                                    onPressed: () async {
                                      await ref
                                          .read(createTeamsProvider.notifier)
                                          .removeMember(data, user, id, userId);

                                      try {
                                        await displayInfoBar(
                                          context,
                                          builder: (context, close) {
                                            return InfoBar(
                                              title: Text("Success"),
                                              content: Text(
                                                "Member removed successfully",
                                              ),
                                              severity: InfoBarSeverity.success,
                                              isLong: true,
                                              onClose: close,
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        await displayInfoBar(
                                          context,
                                          builder: (context, close) {
                                            return InfoBar(
                                              title: Text("Error"),
                                              content: Text(
                                                "Failed to remove member: $e",
                                              ),
                                              severity: InfoBarSeverity.error,
                                              isLong: true,
                                              onClose: close,
                                            );
                                          },
                                        );
                                      } finally {
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                context.theme.inactiveBackgroundColor,
                            backgroundImage:
                                Image.network(
                                  "https://robohash.org/${user['\$id']}?set=set4",
                                ).image,
                          ),
                          title: Text(user['readable_name']),
                          subtitle: Text(user['email']),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    // Dispose all flyout controllers
    _flyoutMemberControllers.forEach((_, controller) => controller.dispose());
    _flyoutTeamControllers.forEach((_, controller) => controller.dispose());
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ProgressBar());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Something wen't wrong"));
          }

          final roles = snapshot.data?[0];
          final users = snapshot.data?[1];
          final teams = snapshot.data?[2];

          return ScaffoldPage.scrollable(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 330,
                    child: TextBox(
                      placeholder: "Search by Name",
                      controller: controller,
                      suffix: Padding(
                        padding: EdgeInsets.only(right: Sizes.p12),
                        child: Icon(FluentIcons.search),
                      ),
                      onEditingComplete: () {
                        setState(() {});
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: Sizes.p20,
                    children: [
                      FilledButton(
                        child: Row(
                          spacing: Sizes.p12,
                          children: [
                            Icon(FluentIcons.add_friend),
                            Text("Create Team"),
                          ],
                        ),
                        onPressed:
                            () => showContentDialog(context, roles!, users!),
                      ),
                    ],
                  ),
                ],
              ),

              gap24,
              Text('Default Roles').titleSmallBold,
              if (roles?.total != 0) ...rolesWidgets(roles!, users!),

              if (teams?.total != 0) ...teamsWidgets(teams!, roles!, users!),
            ],
          );
        },
      ),
    );
  }
}
