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
    required this.name,
    required this.kind,
    required this.status,
    required this.occupancyNote,
    this.capacity,
  });

  final String name;
  final WorkspaceKind kind;
  final WorkspaceStatus status;
  final String occupancyNote;
  final int? capacity;

  String get typeDescription =>
      capacity == null ? kind.label : '${kind.label} · Capacity $capacity';
}

class WorkspaceLocation {
  const WorkspaceLocation({
    required this.label,
    required this.name,
    required this.spaces,
    required this.roomCount,
    required this.deskCount,
  });

  final String label;
  final String name;
  final List<WorkspaceSpace> spaces;
  final int roomCount;
  final int deskCount;

  int get totalSpaces => spaces.length;
}
