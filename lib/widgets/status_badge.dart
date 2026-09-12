import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../theme/app_theme.dart';

/// Badge/chip berwarna untuk menampilkan status tontonan.
class StatusBadge extends StatelessWidget {
  final WatchStatus status;
  final bool small;

  const StatusBadge({super.key, required this.status, this.small = false});

  Color get _color {
    switch (status) {
      case WatchStatus.planToWatch:
        return AppTheme.planToWatchColor;
      case WatchStatus.watching:
        return AppTheme.watchingColor;
      case WatchStatus.completed:
        return AppTheme.completedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: _color,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
