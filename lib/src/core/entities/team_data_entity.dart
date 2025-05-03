class TeamData {
  final String? id;
  final String name;
  final String description;
  final String roleId;
  final String roleName;
  final List<String> userIds;
  final List<String>? unselectedMember;
  List<String> permissions;
  String? timeBasedId;
  bool? timeBased;
  DateTime? startDate;
  DateTime? endDate;

  TeamData({
    this.id,
    required this.name,
    required this.description,
    required this.roleId,
    required this.roleName,
    required this.userIds,
    required this.permissions,
    this.unselectedMember,
    this.timeBasedId,
    this.timeBased,
    this.startDate,
    this.endDate,
  });

  TeamData copyWith({
    String? id,
    String? name,
    String? description,
    String? roleId,
    String? roleName,
    List<String>? userIds,
    List<String>? permissions,
    bool? timeBased,
    String? timeBasedId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? unselectedMember,
  }) {
    return TeamData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      userIds: userIds ?? this.userIds,
      permissions: permissions ?? this.permissions,
      timeBased: timeBased ?? this.timeBased,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timeBasedId: timeBasedId ?? this.timeBasedId,
      unselectedMember: unselectedMember ?? this.unselectedMember,
    );
  }
}
