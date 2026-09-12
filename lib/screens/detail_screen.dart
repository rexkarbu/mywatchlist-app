import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums.dart';
import '../models/watch_item.dart';
import '../providers/database_provider.dart';
import '../providers/watch_item_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import '../widgets/rating_bar.dart';
import 'add_edit_screen.dart';

/// Screen detail item — poster besar, info lengkap, ubah status/rating/progress.
class DetailScreen extends ConsumerStatefulWidget {
  final int itemId;
  final ItemType type;

  const DetailScreen({super.key, required this.itemId, required this.type});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool _isProcessing = false;

  Future<void> _withProcessing(Future<void> Function() action) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(watchItemsProvider(widget.type));

    return itemsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
      data: (items) {
        final item = items.cast<WatchItem?>().firstWhere(
          (i) => i!.id == widget.itemId,
          orElse: () => null,
        );

        if (item == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Item tidak ditemukan.')),
          );
        }

        return _buildContent(context, item);
      },
    );
  }

  Widget _buildContent(BuildContext context, WatchItem item) {
    final theme = Theme.of(context);
    final repo = ref.read(watchItemRepositoryProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Poster header.
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildPosterHeader(context, item),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddEditScreen(type: widget.type, existingItem: item),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: theme.colorScheme.error,
                ),
                tooltip: 'Hapus',
                onPressed: () => _confirmDelete(item, repo),
              ),
            ],
          ),

          // Content.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & year.
                  Text(
                    item.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.year != null) ...[
                    const SizedBox(height: 4),
                    Text('${item.year}', style: theme.textTheme.bodyMedium),
                  ],

                  const SizedBox(height: 12),

                  // Genre chips.
                  if (item.genres.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: item.genres
                          .map(
                            (g) => Chip(
                              label: Text(g),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),

                  const SizedBox(height: 20),

                  // Status segmented button.
                  Text('Status', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<WatchStatus>(
                      segments: WatchStatus.values
                          .map(
                            (s) => ButtonSegment(
                              value: s,
                              label: Text(
                                s.label,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                          .toList(),
                      selected: {item.status},
                      onSelectionChanged: (selected) {
                        _withProcessing(() async {
                          await repo.updateItem(item, status: selected.first);
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Progress (anime/series/reading).
                  if (item.type.hasProgress) ...[
                    Text(
                      'Progress ${item.type.progressUnit}',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    _buildProgressSection(context, item, repo),
                    const SizedBox(height: 20),
                  ],

                  // Rating (hanya saat completed).
                  Text('Rating', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  if (item.status == WatchStatus.completed)
                    RatingBar(
                      rating: item.rating,
                      interactive: true,
                      onChanged: (value) {
                        _withProcessing(() async {
                          if (value == null) {
                            await repo.updateItem(item, clearRating: true);
                          } else {
                            await repo.updateItem(item, rating: value);
                          }
                        });
                      },
                    )
                  else
                    Text(
                      'Rating hanya tersedia untuk status "Sudah Ditonton".',
                      style: theme.textTheme.bodyMedium,
                    ),

                  const SizedBox(height: 20),

                  // Notes.
                  if (item.notes != null && item.notes!.isNotEmpty) ...[
                    Text('Catatan', style: theme.textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.notes!,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],

                  // Date info.
                  const SizedBox(height: 20),
                  _buildDateInfo(context, item),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterHeader(BuildContext context, WatchItem item) {
    Widget poster;

    if (item.posterPath != null) {
      poster = Image.file(
        File(item.posterPath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => _buildPosterPlaceholder(context, item),
      );
    } else {
      poster = _buildPosterPlaceholder(context, item);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        poster,
        // Gradient overlay.
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
        ),
        // Status badge.
        Positioned(
          bottom: 16,
          left: 16,
          child: StatusBadge(status: item.status),
        ),
      ],
    );
  }

  Widget _buildPosterPlaceholder(BuildContext context, WatchItem item) {
    final colors = [
      const Color(0xFF3A3A6A),
      const Color(0xFF2D4A5A),
      const Color(0xFF4A2D5A),
    ];
    final color = colors[item.title.hashCode.abs() % colors.length];

    return Container(
      color: color,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 64,
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    WatchItem item,
    dynamic repo,
  ) {
    final theme = Theme.of(context);
    final current = item.progressCurrent ?? 0;
    final total = item.progressTotal;
    final canIncrement = total == null || current < total;
    final canDecrement = current > 0;

    return Row(
      children: [
        // Decrement button.
        IconButton.filled(
          onPressed: canDecrement
              ? () => _withProcessing(() => repo.decrementProgress(item))
              : null,
          icon: const Icon(Icons.remove_rounded),
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            foregroundColor: theme.colorScheme.onSurface,
            disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(width: 12),

        // Progress text.
        Text(
          '$current',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (total != null)
          Text(
            ' / $total',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          )
        else
          Text(
            ' ${item.type.progressUnit.toLowerCase()}',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

        const SizedBox(width: 12),

        // Increment button.
        IconButton.filled(
          onPressed: canIncrement
              ? () => _withProcessing(() => repo.incrementProgress(item))
              : null,
          icon: const Icon(Icons.add_rounded),
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
        ),

        // Progress bar (jika total diketahui).
        if (total != null && total > 0) ...[
          const SizedBox(width: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: current / total,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateInfo(BuildContext context, WatchItem item) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              'Ditambahkan: ${_formatDate(item.dateAdded)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (item.dateCompleted != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 14,
                color: AppTheme.completedColor,
              ),
              const SizedBox(width: 6),
              Text(
                'Selesai: ${_formatDate(item.dateCompleted!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _confirmDelete(WatchItem item, dynamic repo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Item'),
        content: Text('Yakin ingin menghapus "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await repo.deleteItem(item.id);
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}
