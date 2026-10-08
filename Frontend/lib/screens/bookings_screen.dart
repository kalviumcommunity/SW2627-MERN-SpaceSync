import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_filter_chip.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  static const _filters = <(String, BookingStatus?)>[
    ('All', null),
    ('Active', BookingStatus.active),
    ('Confirmed', BookingStatus.confirmed),
    ('Conflict', BookingStatus.conflict),
    ('Walk-in', BookingStatus.walkIn),
    ('Pending', BookingStatus.pending),
    ('Cancelled', BookingStatus.cancelled),
  ];

  BookingStatus? _selectedStatus;
  String _searchQuery = '';
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = ApiClient.instance.fetchBookings();
  }

  List<Booking> _filteredBookings(List<Booking> bookings) {
    final query = _searchQuery.trim().toLowerCase();
    return bookings.where((booking) {
      final matchesStatus =
          _selectedStatus == null || booking.status == _selectedStatus;
      final matchesQuery =
          query.isEmpty ||
          booking.name.toLowerCase().contains(query) ||
          booking.workspace.toLowerCase().contains(query) ||
          booking.location.toLowerCase().contains(query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(
                  onNotificationsTap: () =>
                      _showMessage(context, 'You have 2 unread notifications.'),
                  onAvatarTap: () => _showMessage(context, 'Admin profile'),
                ),
                const SizedBox(height: 21),
                Text(
                  'Bookings',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  "Manage today's workspace bookings",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search bookings...',
                    hintStyle: TextStyle(color: colors.tertiary, fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: colors.muted),
                    filled: true,
                    fillColor: colors.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final filter in _filters)
                        BookingFilterChip(
                          label: filter.$1,
                          selected: _selectedStatus == filter.$2,
                          onTap: () =>
                              setState(() => _selectedStatus = filter.$2),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FutureBuilder<List<Booking>>(
                  future: _bookingsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const _BookingsLoading();
                    }
                    if (snapshot.hasError) {
                      return _BookingsError(
                        message: snapshot.error.toString(),
                        onRetry: () => setState(
                          () => _bookingsFuture =
                              ApiClient.instance.fetchBookings(),
                        ),
                      );
                    }
                    final visibleBookings = _filteredBookings(snapshot.data ?? []);
                    final conflicts = visibleBookings
                        .where((booking) => booking.status == BookingStatus.conflict)
                        .length;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${visibleBookings.length} bookings',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 15,
                              color: conflicts == 0
                                  ? colors.success
                                  : colors.danger,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              conflicts == 0
                                  ? 'No conflicts'
                                  : '$conflicts conflicts',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: conflicts == 0
                                        ? colors.success
                                        : colors.danger,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 11),
                        if (visibleBookings.isEmpty)
                          _EmptyBookings(searchQuery: _searchQuery)
                        else
                          ...visibleBookings.map(
                            (booking) => BookingCard(
                              booking: booking,
                              onTap: () => _showBookingDetails(context, booking),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showBookingDetails(BuildContext context, Booking booking) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BookingDetailsSheet(booking: booking),
    );
  }
}

class _BookingsLoading extends StatelessWidget {
  const _BookingsLoading();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 44),
    child: Center(child: CircularProgressIndicator()),
  );
}

class _BookingsError extends StatelessWidget {
  const _BookingsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 36),
    child: Column(
      children: [
        Text('Could not load bookings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 14),
        FilledButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}

class _BookingDetailsSheet extends StatelessWidget {
  const _BookingDetailsSheet({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final accent = switch (booking.status) {
      BookingStatus.active => colors.success,
      BookingStatus.confirmed => colors.info,
      BookingStatus.conflict => colors.danger,
      BookingStatus.walkIn || BookingStatus.pending => colors.warning,
      BookingStatus.cancelled => colors.tertiary,
    };
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
                radius: 25,
                backgroundColor: colors.infoContainer,
                child: Text(
                  booking.initials,
                  style: TextStyle(color: accent, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      booking.status.label,
                      style: TextStyle(
                        color: accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close booking details',
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _BookingDetailRow(
            icon: Icons.meeting_room_outlined,
            label: 'Workspace',
            value: booking.workspace,
          ),
          _BookingDetailRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: booking.location,
          ),
          _BookingDetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: booking.date,
          ),
          _BookingDetailRow(
            icon: Icons.schedule_rounded,
            label: 'Time',
            value: booking.time,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _BookingDetailRow extends StatelessWidget {
  const _BookingDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: colors.muted, size: 19),
          const SizedBox(width: 12),
          SizedBox(
            width: 72,
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings({required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.event_busy_outlined, color: colors.tertiary, size: 32),
            const SizedBox(height: 10),
            Text(
              searchQuery.isEmpty ? 'Nothing here yet' : 'No matches found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Try changing your filters.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
