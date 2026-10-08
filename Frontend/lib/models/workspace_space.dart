import 'package:flutter/material.dart';

enum WorkspaceStatus { free, occupied }

enum WorkspaceKind {
  hotDesk,
  dedicatedDesk,
  meetingRoom,
  boardRoom,
  privateSuite,
}

extension WorkspaceKindDetails on WorkspaceKind {
  String get label => switch (this) {
    WorkspaceKind.hotDesk => 'Hot Desk',
    WorkspaceKind.dedicatedDesk => 'Dedicated Desk',
    WorkspaceKind.meetingRoom => 'Meeting Room',
    WorkspaceKind.boardRoom => 'Board Room',
    WorkspaceKind.privateSuite => 'Private Suite',
  };

  IconData get icon => switch (this) {
    WorkspaceKind.hotDesk => Icons.laptop_mac_rounded,
    WorkspaceKind.dedicatedDesk => Icons.desk_rounded,
    WorkspaceKind.meetingRoom => Icons.groups_rounded,
    WorkspaceKind.boardRoom => Icons.business_center_rounded,
    WorkspaceKind.privateSuite => Icons.lock_outline_rounded,
  };
}

class WorkspaceSpace {
  const WorkspaceSpace({
    this.id,
    this.branchId,
    required this.name,
    required this.kind,
    required this.status,
    required this.occupancyNote,
    this.capacity,
  });

  final String? id;
  final String? branchId;
  final String name;
  final WorkspaceKind kind;
  final WorkspaceStatus status;
  final String occupancyNote;
  final int? capacity;

  String get typeDescription =>
      capacity == null ? kind.label : '${kind.label} · Capacity $capacity';

  factory WorkspaceSpace.fromApi(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'desk';
    final available = json['available'] as bool? ?? true;
    return WorkspaceSpace(
      id: json['_id'] as String?,
      branchId: json['branch'] is String ? json['branch'] as String : null,
      name: json['name'] as String? ?? 'Unnamed space',
      kind: type == 'meeting_room'
          ? WorkspaceKind.meetingRoom
          : WorkspaceKind.hotDesk,
      status: available ? WorkspaceStatus.free : WorkspaceStatus.occupied,
      occupancyNote: available
          ? 'Available for the selected demo slot'
          : 'Already booked for the selected demo slot',
      capacity: json['capacity'] as int?,
    );
  }
}

class WorkspaceLocation {
  const WorkspaceLocation({
    this.id,
    required this.label,
    required this.name,
    required this.spaces,
    required this.roomCount,
    required this.deskCount,
  });

  final String? id;
  final String label;
  final String name;
  final List<WorkspaceSpace> spaces;
  final int roomCount;
  final int deskCount;

  int get totalSpaces => spaces.length;
}
