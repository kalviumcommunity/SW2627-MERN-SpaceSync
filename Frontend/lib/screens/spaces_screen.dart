import 'package:flutter/material.dart';

import '../models/workspace_space.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class SpacesScreen extends StatefulWidget {
  const SpacesScreen({super.key});

  @override
  State<SpacesScreen> createState() => _SpacesScreenState();
}

class _SpacesScreenState extends State<SpacesScreen> {
  int _selectedLocationIndex = 0;
  late Future<List<WorkspaceLocation>> _locationsFuture;

  @override
  void initState() {
    super.initState();
    _locationsFuture = ApiClient.instance.fetchLocationsWithSpaces();
  }

  @override
  Widget build(BuildContext context) {
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
                  FutureBuilder<List<WorkspaceLocation>>(
                    future: _locationsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const _InlineLoading(message: 'Loading spaces...');
                      }
                      if (snapshot.hasError) {
                        return _InlineError(
                          message: snapshot.error.toString(),
                          onRetry: () => setState(
                            () => _locationsFuture =
                                ApiClient.instance.fetchLocationsWithSpaces(),
                          ),
                        );
                      }

                      final locations = snapshot.data ?? [];
                      if (locations.isEmpty) {
                        return const _InlineLoading(message: 'No branches yet.');
                      }
                      final selectedIndex = _selectedLocationIndex
                          .clamp(0, locations.length - 1)
                          .toInt();
                      final location = locations[selectedIndex];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LocationSelector(
                            locations: locations,
                            selectedIndex: selectedIndex,
                            onSelected: (index) => setState(
                              () => _selectedLocationIndex = index,
                            ),
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
                              onTap: () =>
                                  _showSpaceDetails(context, location, space),
                            ),
                        ],
                      );
                    },
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
      builder: (context) => _SpaceDetailsSheet(
        location: location,
        space: space,
        onBooked: () => setState(
          () => _locationsFuture = ApiClient.instance.fetchLocationsWithSpaces(),
        ),
      ),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  const _LocationSelector({
    required this.locations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<WorkspaceLocation> locations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: locations.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final location = locations[index];
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
  const _SpaceDetailsSheet({
    required this.location,
    required this.space,
    required this.onBooked,
  });

  final WorkspaceLocation location;
  final WorkspaceSpace space;
  final VoidCallback onBooked;

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
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: free && space.id != null
                      ? () async {
                          try {
                            await ApiClient.instance.bookDemoSlot(space.id!);
                            onBooked();
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Demo booking created.'),
                                ),
                              );
                            }
                          } catch (error) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                            }
                          }
                        }
                      : null,
                  child: const Text('Book'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineLoading extends StatelessWidget {
  const _InlineLoading({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 44),
    child: Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(message),
        ],
      ),
    ),
  );
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 36),
    child: Column(
      children: [
        Text('Could not load spaces', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 14),
        FilledButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
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
