import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BookingFilterChip extends StatelessWidget {
  const BookingFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        labelStyle: TextStyle(
          color: selected
              ? Theme.of(context).colorScheme.onPrimary
              : colors.muted,
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        ),
        backgroundColor: colors.surface,
        selectedColor: color,
        side: BorderSide(color: selected ? color : colors.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}
