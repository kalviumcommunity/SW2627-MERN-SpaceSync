import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../theme/app_theme.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onTap});

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final accent = switch (booking.status) {
      BookingStatus.active => colors.success,
      BookingStatus.confirmed => colors.info,
      BookingStatus.conflict => colors.danger,
      BookingStatus.walkIn || BookingStatus.pending => colors.warning,
      BookingStatus.cancelled => colors.tertiary,
    };
    final tint = switch (booking.status) {
      BookingStatus.active => colors.successContainer,
      BookingStatus.confirmed => colors.infoContainer,
      BookingStatus.conflict => colors.dangerContainer,
      BookingStatus.walkIn || BookingStatus.pending => colors.warningContainer,
      BookingStatus.cancelled => colors.surfaceRaised,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        elevation: 1,
        shadowColor: colors.shadow,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.fromLTRB(13, 13, 10, 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: booking.status == BookingStatus.conflict
                    ? colors.danger.withValues(alpha: 0.4)
                    : colors.outline,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: tint,
                  child: Text(
                    booking.initials,
                    style: TextStyle(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        booking.workspace,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.muted,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelMedium?.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: colors.tertiary,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '${booking.date} · ${booking.time}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.labelMedium?.copyWith(
                                color: colors.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: tint,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        booking.status.label,
                        style: TextStyle(
                          color: accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colors.tertiary,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
