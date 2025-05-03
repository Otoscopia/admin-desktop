import 'package:appwrite/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/roles/provider/create_team_provider.dart';

class CreateTeam extends ConsumerStatefulWidget {
  final DocumentList roles;
  final List<Document> users;
  final bool isEditing;
  final TeamData? team;

  const CreateTeam({
    super.key,
    required this.roles,
    required this.users,
    required this.isEditing,
    this.team,
  });

  @override
  ConsumerState<CreateTeam> createState() => CreateTeamState();
}

class CreateTeamState extends ConsumerState<CreateTeam> {
  final expanderKey = GlobalKey<ExpanderState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();
  String selectedRoleId = '';
  String selectedRoleName = '';
  List<String> users = [];
  List<String> unselectedMember = [];
  final permissions = ['read', 'write', 'update', 'delete'];
  List<String> selectedPermissions = [];
  bool? timeBased = false;
  DateTime? startTime = DateTime.now();
  DateTime? endTime = DateTime.now();

  @override
  void initState() {
    if (widget.team != null) {
      final team = widget.team!;
      nameController.text = team.name;
      descriptionController.text = team.description;
      selectedRoleId = team.roleId;
      selectedRoleName = team.roleName;
      users = team.userIds;
      selectedPermissions = team.permissions;
      timeBased = team.timeBased ?? false;
      startTime = team.startDate;
      endTime = team.endDate;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(createTeamsProvider.notifier)
            .updateTeamDetails(
              id: widget.team?.id,
              name: team.name,
              description: team.description,
              roleId: team.roleId,
              roleName: team.roleName,
              userIds: team.userIds,
              permissions: team.permissions,
              timeBased: team.timeBased,
              startDate: team.startDate,
              endDate: team.endDate,
              timeBasedId: team.timeBasedId,
            );
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUser =
        widget.users.where((u) {
          final hasSearchData = searchController.text.isNotEmpty;
          final selectedRole = u.data['role']['\$id'] == selectedRoleId;

          final search = searchController.text;
          final name = u.data['readable_name'] as String;

          return hasSearchData
              ? name.contains(search) && selectedRole
              : selectedRole;
        }).toList();

    return ScaffoldPage.scrollable(
      children: [
        Text("Team Name"),
        gap8,
        SizedBox(
          width: 400,
          child: TextBox(
            controller: nameController,
            placeholder: 'Night Shift Workers',
            onChanged: (value) {
              ref
                  .read(createTeamsProvider.notifier)
                  .updateTeamDetails(name: nameController.text);
            },
          ),
        ),

        gap16,

        Text("Team Description"),
        gap8,
        SizedBox(
          height: 100.0,
          width: 400,
          child: TextBox(
            maxLines: null,
            controller: descriptionController,
            placeholder: "A meaningful description",
            onChanged: (value) {
              ref
                  .read(createTeamsProvider.notifier)
                  .updateTeamDetails(description: descriptionController.text);
            },
          ),
        ),
        gap16,
        if (!widget.isEditing)
          Expander(
            header: Text("Select Role Assignment"),
            leading: Icon(FluentIcons.c_r_m_services),
            trailing: Text(selectedRoleName),
            content: SizedBox(
              height: 215,
              child: ListView.builder(
                itemCount: widget.roles.total,
                itemBuilder: (context, index) {
                  final role = widget.roles.documents[index];
                  final name = (role.data['key'] as String).uppercaseFirst();
                  return ListTile.selectable(
                    selected: selectedRoleId == role.$id,
                    onSelectionChange: (value) {
                      final id = role.$id;
                      final name =
                          (role.data['key'] as String).uppercaseFirst();
                      setState(() {
                        selectedRoleId = id;
                        selectedRoleName = name;
                      });
                      ref
                          .read(createTeamsProvider.notifier)
                          .updateTeamDetails(roleId: id, roleName: name);
                    },
                    selectionMode: ListTileSelectionMode.single,
                    title: Text(name),
                    subtitle: Text(role.data['description']),
                  );
                },
              ),
            ),
          ),
        gap16,
        Expander(
          leading: Icon(FluentIcons.people_add),
          trailing: Text(users.length.toString()),
          header: Text("Select Team Member"),
          content: SizedBox(
            width: 330,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Sizes.p12,
              children: [
                SizedBox(
                  width: 330,
                  child: TextBox(
                    placeholder: "Search by Name",
                    controller: searchController,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredUser.length,
                  itemBuilder: (context, index) {
                    final user = filteredUser[index];
                    return ListTile.selectable(
                      selected: users.contains(user.$id),
                      onSelectionChange: (selected) {
                        setState(() {
                          if (selected) {
                            users.add(user.$id);
                          } else {
                            if (widget.isEditing && users.contains(user.$id)) {
                              unselectedMember.add(user.$id);
                            }
                            users.remove(user.$id);
                          }
                          ref
                              .read(createTeamsProvider.notifier)
                              .updateTeamDetails(userIds: users);
                          ref
                              .read(createTeamsProvider.notifier)
                              .updateTeamDetails(unselectedMember: users);
                        });
                      },
                      selectionMode: ListTileSelectionMode.multiple,
                      title: Text(user.data['readable_name']),
                      subtitle: Text(user.data['email']),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        gap16,
        Expander(
          leading: Icon(FluentIcons.permissions_solid),
          header: Text("Permissions"),
          content: SizedBox(
            height: 180,
            child: ListView.builder(
              itemCount: permissions.length,
              itemBuilder: (context, index) {
                final permission = permissions[index];
                return ListTile.selectable(
                  title: Text(permission.uppercaseFirst()),
                  selectionMode: ListTileSelectionMode.multiple,
                  selected: selectedPermissions.contains(permission),
                  onSelectionChange: (selected) {
                    setState(() {
                      if (selected) {
                        selectedPermissions.add(permission);
                      } else {
                        selectedPermissions.remove(permission);
                      }
                      ref
                          .read(createTeamsProvider.notifier)
                          .updateTeamDetails(permissions: selectedPermissions);
                    });
                  },
                );
              },
            ),
          ),
        ),
        gap16,
        Expander(
          key: expanderKey,
          leading: Icon(FluentIcons.time_picker),
          header: Text("Time-Based Access"),
          enabled: timeBased == true,
          trailing: Checkbox(
            content: Text('Enable Time-Based Access'),
            checked: timeBased,
            onChanged: (value) {
              final open = expanderKey.currentState?.isExpanded ?? false;

              setState(() {
                endTime = null;
                startTime = null;
                timeBased = value;
                expanderKey.currentState?.isExpanded = !open;
              });

              ref
                  .read(createTeamsProvider.notifier)
                  .updateTeamDetails(timeBased: value);
            },
          ),
          content: SizedBox(
            height: 122,
            child: Column(
              spacing: Sizes.p12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoLabel(
                  label: "Start Time",
                  child: TimePicker(
                    selected: startTime,
                    onChanged: (value) {
                      setState(() => startTime = value);
                      ref
                          .read(createTeamsProvider.notifier)
                          .updateTeamDetails(startDate: value);
                    },
                  ),
                ),
                InfoLabel(
                  label: "End Time",
                  child: TimePicker(
                    selected: endTime,
                    onChanged: (value) {
                      setState(() => endTime = value);
                      ref
                          .read(createTeamsProvider.notifier)
                          .updateTeamDetails(endDate: value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
