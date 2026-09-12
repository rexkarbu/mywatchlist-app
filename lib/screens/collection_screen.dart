import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums.dart';
import '../models/watch_item.dart';
import '../providers/watch_item_provider.dart';
import '../widgets/poster_grid_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/filter_sort_sheet.dart';
import 'add_edit_screen.dart';
import 'detail_screen.dart';

/// Screen daftar koleksi (dipakai untuk Anime, Film, dan Series).
/// Grid poster 2 kolom, search, filter/sort, FAB.
class CollectionScreen extends ConsumerStatefulWidget {
  final ItemType type;

  const CollectionScreen({super.key, required this.type});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        ref.read(searchQueryProvider(widget.type).notifier).state = '';
      }
    });
  }

  void _openFilterSheet() {
    final statusFilter = ref.read(statusFilterProvider(widget.type));
    final sortOption = ref.read(sortOptionProvider(widget.type));

    showModalBottomSheet(
      context: context,
      builder: (_) => FilterSortSheet(
        currentStatusFilter: statusFilter,
        currentSortOption: sortOption,
        onStatusChanged: (status) {
          ref.read(statusFilterProvider(widget.type).notifier).state = status;
          Navigator.pop(context);
        },
        onSortChanged: (sort) {
          ref.read(sortOptionProvider(widget.type).notifier).state = sort;
          Navigator.pop(context);
        },
      ),
    );
  }

  void _navigateToAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditScreen(type: widget.type)),
    );
  }

  void _navigateToDetail(WatchItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(itemId: item.id, type: widget.type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = ref.watch(filteredItemsProvider(widget.type));
    final statusFilter = ref.watch(statusFilterProvider(widget.type));
    final searchQuery = ref.watch(searchQueryProvider(widget.type));

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Cari ${widget.type.label.toLowerCase()}...',
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  ref.read(searchQueryProvider(widget.type).notifier).state =
                      value;
                },
              )
            : Text(widget.type.label),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search_rounded),
            onPressed: _toggleSearch,
            tooltip: _isSearching ? 'Tutup pencarian' : 'Cari',
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: statusFilter != null,
              smallSize: 8,
              child: const Icon(Icons.tune_rounded),
            ),
            onPressed: _openFilterSheet,
            tooltip: 'Filter & urutkan',
          ),
        ],
      ),
      body: filteredItems.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 12),
                Text(
                  'Terjadi kesalahan',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            // Bedakan empty collection vs hasil pencarian kosong.
            if (searchQuery.isNotEmpty || statusFilter != null) {
              return EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Tidak ditemukan',
                subtitle: 'Coba ubah kata kunci atau filter.',
              );
            }
            return EmptyState(
              icon: _typeIcon,
              title: 'Belum ada ${widget.type.label.toLowerCase()}',
              subtitle:
                  'Tambahkan ${widget.type.label.toLowerCase()} pertamamu!',
              actionLabel: 'Tambah',
              onAction: _navigateToAdd,
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // 2 kolom untuk ponsel standar, sesuaikan untuk layar lebar.
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return PosterGridItem(
                    item: items[index],
                    onTap: () => _navigateToDetail(items[index]),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        tooltip: 'Tambah ${widget.type.label}',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  IconData get _typeIcon {
    switch (widget.type) {
      case ItemType.anime:
        return Icons.animation_rounded;
      case ItemType.movie:
        return Icons.movie_rounded;
      case ItemType.series:
        return Icons.tv_rounded;
      case ItemType.reading:
        return Icons.auto_stories_rounded;
    }
  }
}
