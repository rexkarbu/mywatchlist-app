import 'dart:io';

import 'package:flutter/material.dart';

import '../models/watch_item.dart';
import '../models/enums.dart';
import 'status_badge.dart';

/// Item grid poster dengan overlay judul dan badge status.
/// Rasio poster 2:3.
class PosterGridItem extends StatelessWidget {
  final WatchItem item;
  final VoidCallback onTap;

  const PosterGridItem({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster image atau placeholder.
              _buildPoster(context),

              // Gradient overlay di bawah.
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
              ),

              // Title di bawah.
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    height: 1.2,
                  ),
                ),
              ),

              // Status badge di kiri atas.
              Positioned(
                top: 6,
                left: 6,
                child: StatusBadge(status: item.status, small: true),
              ),

              // Rating di kanan atas (jika ada).
              if (item.rating != null)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFC107),
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          item.rating!.toStringAsFixed(
                            item.rating! == item.rating!.roundToDouble()
                                ? 0
                                : 1,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Progress di bawah badge status (anime/series).
              if (item.type.hasProgress && item.progressCurrent != null)
                Positioned(
                  top: 30,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.progressTotal != null
                          ? '${item.progressCurrent}/${item.progressTotal}'
                          : '${item.progressCurrent} ep',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoster(BuildContext context) {
    if (item.posterPath != null) {
      final file = File(item.posterPath!);
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildPlaceholder(context),
      );
    }
    return _buildPlaceholder(context);
  }

  Widget _buildPlaceholder(BuildContext context) {
    // Warna placeholder berdasarkan hash judul.
    final colors = [
      const Color(0xFF3A3A6A),
      const Color(0xFF2D4A5A),
      const Color(0xFF4A2D5A),
      const Color(0xFF2D5A4A),
      const Color(0xFF5A3A2D),
      const Color(0xFF3A5A2D),
    ];
    final color = colors[item.title.hashCode.abs() % colors.length];

    return Container(
      color: color,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _typeIcon,
                color: Colors.white.withValues(alpha: 0.4),
                size: 36,
              ),
              const SizedBox(height: 4),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData get _typeIcon {
    switch (item.type) {
      case ItemType.anime:
        return Icons.animation_rounded;
      case ItemType.movie:
        return Icons.movie_rounded;
      case ItemType.series:
        return Icons.tv_rounded;
    }
  }
}
