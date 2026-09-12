import 'dart:async';

import 'package:flutter/material.dart';

import '../models/api_search_result.dart';
import '../models/enums.dart';
import '../services/anilist_api_service.dart';
import '../services/tmdb_api_service.dart';

/// Modal bottom sheet untuk mencari metadata secara online (AniList & TMDB).
class ApiSearchDialog extends StatefulWidget {
  final ItemType type;
  final String? initialQuery;

  const ApiSearchDialog({super.key, required this.type, this.initialQuery});

  /// Helper statis untuk menampilkan modal bottom sheet pencarian online.
  static Future<ApiSearchResult?> show(
    BuildContext context, {
    required ItemType type,
    String? initialQuery,
  }) {
    return showModalBottomSheet<ApiSearchResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ApiSearchDialog(type: type, initialQuery: initialQuery),
    );
  }

  @override
  State<ApiSearchDialog> createState() => _ApiSearchDialogState();
}

class _ApiSearchDialogState extends State<ApiSearchDialog> {
  late final TextEditingController _controller;
  final AniListApiService _anilistService = AniListApiService();
  final TmdbApiService _tmdbService = TmdbApiService();

  Timer? _debounce;
  bool _isLoading = false;
  String? _errorMessage;
  List<ApiSearchResult> _results = [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    if (_controller.text.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearch(_controller.text.trim());
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = null;
        _results = [];
        _hasSearched = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasSearched = true;
    });

    try {
      List<ApiSearchResult> items;
      switch (widget.type) {
        case ItemType.anime:
          items = await _anilistService.searchAnime(query);
          break;
        case ItemType.reading:
          items = await _anilistService.searchReading(query);
          break;
        case ItemType.movie:
          items = await _tmdbService.searchMovie(query);
          break;
        case ItemType.series:
          items = await _tmdbService.searchSeries(query);
          break;
      }

      if (mounted) {
        setState(() {
          _results = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.85,
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: mediaQuery.viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Cari Online — ${widget.type.label}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search Field
          TextField(
            controller: _controller,
            autofocus: widget.initialQuery?.isEmpty ?? true,
            decoration: InputDecoration(
              hintText: 'Ketik judul ${widget.type.label.toLowerCase()}...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _controller.clear();
                        _onQueryChanged('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: _onQueryChanged,
            onSubmitted: (q) => _performSearch(q.trim()),
          ),
          const SizedBox(height: 16),

          // Content list or state
          Expanded(child: _buildContent(theme)),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Mencari data ${widget.type.label.toLowerCase()}...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Terjadi Kesalahan',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _performSearch(_controller.text.trim()),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasSearched || _controller.text.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.manage_search_rounded,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Cari metadata otomatis dari internet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              (widget.type == ItemType.anime || widget.type == ItemType.reading)
                  ? 'Sumber data: AniList API'
                  : 'Sumber data: The Movie Database (TMDB)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Tidak ada hasil ditemukan',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Coba gunakan kata kunci yang lebih spesifik',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = _results[index];
        return _buildResultCard(context, item, theme);
      },
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    ApiSearchResult item,
    ThemeData theme,
  ) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pop(context, item),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Thumbnail (2:3 aspect ratio)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 60,
                  height: 90,
                  child: item.posterUrl != null
                      ? Image.network(
                          item.posterUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              _buildPlaceholderPoster(theme),
                        )
                      : _buildPlaceholderPoster(theme),
                ),
              ),
              const SizedBox(width: 12),

              // Metadata info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Year & Episodes
                    Row(
                      children: [
                        if (item.year != null) ...[
                          Text(
                            '${item.year}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (item.totalEpisodes != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${item.totalEpisodes} ${widget.type.progressUnit.toLowerCase()}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (item.format != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.format!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Genres
                    if (item.genres.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: item.genres.take(3).map((g) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              g,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),

              // Select icon indicator
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderPoster(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
