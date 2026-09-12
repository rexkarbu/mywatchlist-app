import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/enums.dart';
import '../models/watch_item.dart';
import '../providers/database_provider.dart';
import '../providers/stats_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import 'detail_screen.dart';

/// Stats dashboard screen.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stats) => _buildContent(context, ref, stats),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, AllStats stats) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(statsProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Total overview cards.
          Text('Ringkasan', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.3,
            children: [
              StatCard(
                label: 'Total Tontonan',
                value: '${stats.totalAll}',
                icon: Icons.collections_bookmark_rounded,
                iconColor: theme.colorScheme.primary,
              ),
              StatCard(
                label: 'Sudah Ditonton',
                value: '${stats.totalCompleted}',
                icon: Icons.check_circle_rounded,
                iconColor: AppTheme.completedColor,
              ),
              StatCard(
                label: 'Sedang Ditonton',
                value: '${stats.totalWatching}',
                icon: Icons.play_circle_rounded,
                iconColor: AppTheme.watchingColor,
              ),
              StatCard(
                label: 'Mau Ditonton',
                value: '${stats.totalPlanToWatch}',
                icon: Icons.bookmark_rounded,
                iconColor: AppTheme.planToWatchColor,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Per-category breakdown.
          Text('Per Kategori', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          _buildCategoryCard(context, stats.anime),
          const SizedBox(height: 10),
          _buildCategoryCard(context, stats.movie),
          const SizedBox(height: 10),
          _buildCategoryCard(context, stats.series),

          const SizedBox(height: 28),

          // Currently watching.
          Text('Sedang Ditonton', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          if (stats.currentlyWatching.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Belum ada yang sedang ditonton.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: stats.currentlyWatching.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return _buildWatchingCard(
                    context,
                    stats.currentlyWatching[index],
                  );
                },
              ),
            ),

          const SizedBox(height: 24),
          _buildBackupRestoreCard(context, ref),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBackupRestoreCard(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.backup_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Cadangan Data',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Ekspor seluruh riwayat watchlist ke file JSON atau pulihkan data dari file cadangan sebelumnya.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _exportData(context, ref),
                    icon: const Icon(Icons.upload_rounded),
                    label: const Text('Ekspor JSON'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => _importData(context, ref),
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Impor JSON'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      final repo = ref.read(watchItemRepositoryProvider);
      final jsonString = await repo.exportDatabaseToJson();
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final file = File('${tempDir.path}/mywatchlist_backup_$timestamp.json');
      await file.writeAsString(jsonString);

      await Share.shareXFiles([
        XFile(file.path, mimeType: 'application/json'),
      ], subject: 'Backup MyWatchlist ($timestamp)');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengekspor data: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) return;

      final path = result.files.single.path;
      String jsonString;
      if (path != null) {
        jsonString = await File(path).readAsString();
      } else if (result.files.single.bytes != null) {
        jsonString = utf8.decode(result.files.single.bytes!);
      } else {
        throw Exception('Tidak dapat membaca file backup yang dipilih.');
      }

      final repo = ref.read(watchItemRepositoryProvider);
      final count = await repo.importDatabaseFromJson(jsonString);

      ref.invalidate(statsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil mengimpor $count item!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengimpor data: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildCategoryCard(BuildContext context, CategoryStats cat) {
    final theme = Theme.of(context);

    IconData icon;
    switch (cat.type) {
      case ItemType.anime:
        icon = Icons.animation_rounded;
        break;
      case ItemType.movie:
        icon = Icons.movie_rounded;
        break;
      case ItemType.series:
        icon = Icons.tv_rounded;
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text(cat.type.label, style: theme.textTheme.titleMedium),
                const Spacer(),
                Text('${cat.total} total', style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 14),
            // Status breakdown.
            Row(
              children: [
                _buildStatusItem(
                  context,
                  label: 'Mau',
                  value: cat.planToWatch,
                  color: AppTheme.planToWatchColor,
                ),
                const SizedBox(width: 16),
                _buildStatusItem(
                  context,
                  label: 'Sedang',
                  value: cat.watching,
                  color: AppTheme.watchingColor,
                ),
                const SizedBox(width: 16),
                _buildStatusItem(
                  context,
                  label: 'Sudah',
                  value: cat.completed,
                  color: AppTheme.completedColor,
                ),
                const Spacer(),
                // Average rating.
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFC107),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      cat.averageRating != null
                          ? cat.averageRating!.toStringAsFixed(1)
                          : '—',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Progress bar.
            if (cat.total > 0) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: SizedBox(
                  height: 4,
                  child: Row(
                    children: [
                      if (cat.completed > 0)
                        Flexible(
                          flex: cat.completed,
                          child: Container(color: AppTheme.completedColor),
                        ),
                      if (cat.watching > 0)
                        Flexible(
                          flex: cat.watching,
                          child: Container(color: AppTheme.watchingColor),
                        ),
                      if (cat.planToWatch > 0)
                        Flexible(
                          flex: cat.planToWatch,
                          child: Container(color: AppTheme.planToWatchColor),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildWatchingCard(BuildContext context, WatchItem item) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(itemId: item.id, type: item.type),
          ),
        );
      },
      child: SizedBox(
        width: 120,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster mini.
              SizedBox(
                height: 90,
                width: double.infinity,
                child: item.posterPath != null
                    ? Image.file(
                        File(item.posterPath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: const Color(0xFF3A3A6A),
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      )
                    : Container(
                        color: const Color(0xFF3A3A6A),
                        child: Center(
                          child: Icon(
                            item.type == ItemType.anime
                                ? Icons.animation_rounded
                                : item.type == ItemType.movie
                                ? Icons.movie_rounded
                                : Icons.tv_rounded,
                            color: Colors.white.withValues(alpha: 0.3),
                            size: 28,
                          ),
                        ),
                      ),
              ),
              // Title & progress.
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (item.type.hasProgress &&
                        item.progressCurrent != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.progressTotal != null
                            ? '${item.progressCurrent}/${item.progressTotal} ep'
                            : '${item.progressCurrent} ep',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
