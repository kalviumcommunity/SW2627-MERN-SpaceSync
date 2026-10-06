import 'package:flutter/material.dart';

import '../data/space_data.dart';
import '../models/workspace_space.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class SpacesScreen extends StatefulWidget {
  const SpacesScreen({super.key});

  @override
  State<SpacesScreen> createState() => _SpacesScreenState();
}

class _SpacesScreenState extends State<SpacesScreen> {
  int _selectedLocationIndex = 0;

  @override
  Widget build(BuildContext context) {
    final location = workspaceLocations[_selectedLocationIndex];
    final colors = AppColors.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - 36).clamp(0.0, 400.0).toDouble()
            : 360.0;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeader(
                    onNotificationsTap: () => _showMessage(
                      context,
                      'You have 2 unread notifications.',
                    ),
                    onAvatarTap: () => _showMessage(context, 'Admin profile'),
                  ),
                  const SizedBox(height: 21),
                  Text(
                    'Spaces',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage workspace availability',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  _LocationSelector(
                    selectedIndex: _selectedLocationIndex,
                    onSelected: (index) =>
                        setState(() => _selectedLocationIndex = index),
                  ),
                  const SizedBox(height: 16),
                  _SpaceSummary(location: location),
                  const SizedBox(height: 23),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          location.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${location.spaces.where((space) => space.status == WorkspaceStatus.free).length} free',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: colors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 11),
                  for (final space in location.spaces)
                    _WorkspaceCard(
                      space: space,
                      onTap: () => _showSpaceDetails(context, location, space),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSpaceDetails(
    BuildContext context,
    WorkspaceLocation location,
    WorkspaceSpace space,
  ) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _SpaceDetailsSheet(location: location, space: space),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  const _LocationSelector({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: workspaceLocations.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final location = workspaceLocations[index];
          final selected = index == selectedIndex;
          return ChoiceChip(
            label: Text(location.label),
            selected: selected,
            onSelected: (_) => onSelected(index),
            showCheckmark: false,
            labelStyle: TextStyle(
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : colors.muted,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
            backgroundColor: colors.surface,
            selectedColor: Theme.of(context).colorScheme.primary,
            side: BorderSide(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : colors.outline,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          );
        },
      ),
    );
  }
}

class _SpaceSummary extends StatelessWidget {
  const _SpaceSummary({required this.location});

  final WorkspaceLocation location;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final metrics = [
      (
        location.totalSpaces.toString(),
        'Total spaces',
        Icons.grid_view_rounded,
      ),
      (location.roomCount.toString(), 'Rooms', Icons.meeting_room_outlined),
      (location.deskCount.toString(), 'Desks', Icons.desk_outlined),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outline),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var index = 0; index < metrics.length; index++) ...[
            if (index > 0)
              Container(width: 1, height: 38, color: colors.outlineSoft),
            Expanded(
              child: Column(
                children: [
                  Icon(metrics[index].$3, size: 16, color: colors.muted),
                  const SizedBox(height: 4),
                  Text(
                    metrics[index].$1,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    metrics[index].$2,
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  const _WorkspaceCard({required this.space, required this.onTap});

  final WorkspaceSpace space;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final free = space.status == WorkspaceStatus.free;
    final colors = AppColors.of(context);
    final accent = free ? colors.success : colors.danger;
    final tint = free ? colors.successContainer : colors.dangerContainer;
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        shadowColor: colors.shadow,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.outline),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colors.iconSurface,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(space.kind.icon, color: colors.info, size: 21),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        space.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        space.typeDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: tint,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    free ? 'Free' : 'Occupied',
                    style: TextStyle(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.tertiary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpaceDetailsSheet extends StatelessWidget {
  const _SpaceDetailsSheet({required this.location, required this.space});

  final WorkspaceLocation location;
  final WorkspaceSpace space;

  @override
  Widget build(BuildContext context) {
    final free = space.status == WorkspaceStatus.free;
    final colors = AppColors.of(context);
    final accent = free ? colors.success : colors.danger;
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colors.iconSurface,
                child: Icon(space.kind.icon, color: colors.info),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      space.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      space.typeDescription,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close workspace details',
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: location.name,
          ),
          _DetailRow(
            icon: Icons.circle,
            label: 'Status',
            value: free ? 'Free' : 'Occupied',
            valueColor: accent,
          ),
          if (space.capacity != null)
            _DetailRow(
              icon: Icons.groups_outlined,
              label: 'Capacity',
              value: '${space.capacity} people',
            ),
          _DetailRow(
            icon: Icons.event_available_outlined,
            label: 'Occupancy',
            value: space.occupancyNote,
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: valueColor ?? colors.muted, size: 18),
          const SizedBox(width: 11),
          SizedBox(
            width: 76,
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: valueColor, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
