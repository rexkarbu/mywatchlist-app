import 'package:flutter/material.dart';

/// Rating bar widget — skala 1–10, langkah 0.5.
/// Bisa dalam mode display (read-only) atau input (interaktif).
class RatingBar extends StatelessWidget {
  final double? rating;
  final bool interactive;
  final ValueChanged<double?>? onChanged;

  const RatingBar({
    super.key,
    this.rating,
    this.interactive = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!interactive) {
      return _buildDisplay(theme);
    }

    return _buildInteractive(context, theme);
  }

  Widget _buildDisplay(ThemeData theme) {
    if (rating == null) {
      return Text(
        '—',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 20),
        const SizedBox(width: 4),
        Text(
          _formatRating(rating!),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          ' / 10',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractive(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 22),
            const SizedBox(width: 6),
            Text(
              rating != null ? _formatRating(rating!) : '—',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              ' / 10',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            if (rating != null)
              IconButton(
                icon: Icon(
                  Icons.clear_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () => onChanged?.call(null),
                tooltip: 'Hapus rating',
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Slider(
          value: rating ?? 5.0,
          min: 1.0,
          max: 10.0,
          divisions: 18, // (10-1) / 0.5 = 18 divisions
          label: rating != null ? _formatRating(rating!) : null,
          onChanged: (value) {
            // Bulatkan ke 0.5 terdekat.
            final rounded = (value * 2).roundToDouble() / 2;
            onChanged?.call(rounded);
          },
        ),
      ],
    );
  }

  String _formatRating(double r) {
    return r == r.roundToDouble() ? r.toInt().toString() : r.toStringAsFixed(1);
  }
}
