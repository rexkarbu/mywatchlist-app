import 'package:flutter/material.dart';

import '../models/enums.dart';

/// Bottom sheet untuk memilih filter status dan sort option.
class FilterSortSheet extends StatelessWidget {
  final WatchStatus? currentStatusFilter;
  final SortOption currentSortOption;
  final ValueChanged<WatchStatus?> onStatusChanged;
  final ValueChanged<SortOption> onSortChanged;

  const FilterSortSheet({
    super.key,
    required this.currentStatusFilter,
    required this.currentSortOption,
    required this.onStatusChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar.
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Filter section.
          Text('Filter Status', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(
                context,
                label: 'Semua',
                selected: currentStatusFilter == null,
                onTap: () => onStatusChanged(null),
              ),
              for (final status in WatchStatus.values)
                _buildFilterChip(
                  context,
                  label: status.label,
                  selected: currentStatusFilter == status,
                  onTap: () => onStatusChanged(status),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // Sort section.
          Text('Urutkan', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          RadioGroup<SortOption>(
            groupValue: currentSortOption,
            onChanged: (v) {
              if (v != null) onSortChanged(v);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in SortOption.values)
                  ListTile(
                    title: Text(option.label, style: theme.textTheme.bodyLarge),
                    leading: Radio<SortOption>(
                      value: option,
                      activeColor: theme.colorScheme.primary,
                    ),
                    onTap: () => onSortChanged(option),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: theme.colorScheme.primary,
      side: selected
          ? BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5))
          : BorderSide.none,
    );
  }
}
