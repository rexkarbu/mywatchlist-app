import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/enums.dart';
import '../models/watch_item.dart';
import '../providers/database_provider.dart';
import '../widgets/api_search_dialog.dart';
import '../widgets/genre_chip_input.dart';

/// Form screen untuk menambah atau mengedit item.
/// Shared untuk add (existingItem == null) dan edit.
class AddEditScreen extends ConsumerStatefulWidget {
  final ItemType type;
  final WatchItem? existingItem;

  const AddEditScreen({super.key, required this.type, this.existingItem});

  bool get isEditing => existingItem != null;

  @override
  ConsumerState<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends ConsumerState<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _notesController = TextEditingController();
  final _progressCurrentController = TextEditingController();
  final _progressTotalController = TextEditingController();

  late WatchStatus _status;
  List<String> _genres = [];
  String? _posterPath; // Path ke file poster (di app dir).
  String? _originalPosterPath; // Untuk tracking perubahan poster.
  File? _newPosterFile; // File poster baru yang belum di-copy ke app dir.
  bool _isSubmitting = false;
  bool _isAutoFilling = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      final item = widget.existingItem!;
      _titleController.text = item.title;
      _yearController.text = item.year?.toString() ?? '';
      _notesController.text = item.notes ?? '';
      _status = item.status;
      _genres = List.from(item.genres);
      _posterPath = item.posterPath;
      _originalPosterPath = item.posterPath;

      if (widget.type.hasProgress) {
        _progressCurrentController.text =
            item.progressCurrent?.toString() ?? '0';
        _progressTotalController.text = item.progressTotal?.toString() ?? '';
      }
    } else {
      _status = WatchStatus.planToWatch;
      if (widget.type.hasProgress) {
        _progressCurrentController.text = '0';
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _notesController.dispose();
    _progressCurrentController.dispose();
    _progressTotalController.dispose();
    // Bersihkan file poster baru jika form dibatalkan tanpa save.
    _cleanupOnCancel();
    super.dispose();
  }

  void _cleanupOnCancel() {
    // Jika ada poster baru yang sudah di-copy tapi form dibatalkan,
    // bersihkan hanya jika belum di-save (poster path masih beda dari yang di DB).
    // Logika cleanup yang aman ditangani di repository saat save.
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() {
          _newPosterFile = File(picked.path);
          _posterPath = picked.path; // Temporary, akan di-copy saat save.
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $e')));
      }
    }
  }

  void _removePoster() {
    setState(() {
      _newPosterFile = null;
      _posterPath = null;
    });
  }

  Future<void> _openOnlineSearch() async {
    final result = await ApiSearchDialog.show(
      context,
      type: widget.type,
      initialQuery: _titleController.text.trim(),
    );

    if (result == null || !mounted) return;

    setState(() => _isAutoFilling = true);

    try {
      _titleController.text = result.title;

      if (result.year != null) {
        _yearController.text = result.year.toString();
      }

      if (result.genres.isNotEmpty) {
        final existingLower = _genres.map((g) => g.toLowerCase()).toSet();
        for (final g in result.genres) {
          final trimmed = g.trim();
          if (trimmed.isNotEmpty && existingLower.add(trimmed.toLowerCase())) {
            _genres.add(trimmed);
          }
        }
      }

      if (widget.type.hasProgress && result.totalEpisodes != null) {
        _progressTotalController.text = result.totalEpisodes.toString();
      }

      if (result.synopsis != null &&
          result.synopsis!.trim().isNotEmpty &&
          _notesController.text.trim().isEmpty) {
        _notesController.text = result.synopsis!;
      }

      if (result.posterUrl != null && result.posterUrl!.isNotEmpty) {
        final repo = ref.read(watchItemRepositoryProvider);
        final localPath = await repo.downloadPosterToAppDir(result.posterUrl!);
        if (mounted) {
          setState(() {
            _posterPath = localPath;
            _newPosterFile = null;
          });
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Metadata "${result.title}" berhasil diisi otomatis'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal auto-fill metadata: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAutoFilling = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(watchItemRepositoryProvider);

      // Copy poster baru ke app dir jika ada.
      String? finalPosterPath = _posterPath;
      if (_newPosterFile != null) {
        finalPosterPath = await repo.copyPosterToAppDir(_newPosterFile!.path);
      }

      final year = _yearController.text.isNotEmpty
          ? int.tryParse(_yearController.text)
          : null;
      final notes = _notesController.text.isNotEmpty
          ? _notesController.text
          : null;

      int? progressCurrent;
      int? progressTotal;
      if (widget.type.hasProgress) {
        progressCurrent = int.tryParse(_progressCurrentController.text) ?? 0;
        progressTotal = _progressTotalController.text.isNotEmpty
            ? int.tryParse(_progressTotalController.text)
            : null;
      }

      if (widget.isEditing) {
        final item = widget.existingItem!;
        final posterChanged = finalPosterPath != _originalPosterPath;

        await repo.updateItem(
          item,
          title: _titleController.text,
          year: year,
          genres: _genres,
          status: _status,
          posterPath: posterChanged ? finalPosterPath : null,
          clearPoster: _posterPath == null && _originalPosterPath != null,
          notes: notes,
          progressCurrent: progressCurrent,
          progressTotal: progressTotal,
        );
      } else {
        await repo.addItem(
          type: widget.type,
          title: _titleController.text,
          year: year,
          genres: _genres,
          status: _status,
          posterPath: finalPosterPath,
          notes: notes,
          progressCurrent: progressCurrent,
          progressTotal: progressTotal,
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing
              ? 'Edit ${widget.type.label}'
              : 'Tambah ${widget.type.label}',
        ),
        actions: [
          FilledButton(
            onPressed: _isSubmitting ? null : _save,
            child: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Simpan'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Poster.
            _buildPosterSection(theme),
            const SizedBox(height: 16),

            // Tombol Cari Online (Auto-fill).
            FilledButton.tonalIcon(
              onPressed: _isSubmitting || _isAutoFilling
                  ? null
                  : _openOnlineSearch,
              icon: _isAutoFilling
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome_rounded),
              label: Text(
                _isAutoFilling
                    ? 'Mengunduh Metadata & Poster...'
                    : 'Cari Online (Auto-fill)',
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Judul.
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul *',
                prefixIcon: Icon(Icons.title_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),

            // Tahun.
            TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Tahun Rilis',
                prefixIcon: Icon(Icons.calendar_today_rounded),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final y = int.tryParse(value);
                  if (y == null || y < 1900 || y > 2100) {
                    return 'Tahun tidak valid';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // Genre.
            Text('Genre', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            GenreChipInput(
              genres: _genres,
              onChanged: (updated) => setState(() => _genres = updated),
            ),
            const SizedBox(height: 20),

            // Status.
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
                selected: {_status},
                onSelectionChanged: (selected) {
                  setState(() => _status = selected.first);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Progress (anime/series/reading).
            if (widget.type.hasProgress) ...[
              Text(
                'Progress ${widget.type.progressUnit}',
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _progressCurrentController,
                      decoration: InputDecoration(
                        labelText: '${widget.type.progressUnit} saat ini',
                        prefixIcon: Icon(
                          widget.type == ItemType.reading
                              ? Icons.menu_book_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final n = int.tryParse(value);
                          if (n == null || n < 0) {
                            return 'Tidak valid';
                          }
                          final total = int.tryParse(
                            _progressTotalController.text,
                          );
                          if (total != null && n > total) {
                            return 'Melebihi total';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('/', style: TextStyle(fontSize: 20)),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _progressTotalController,
                      decoration: InputDecoration(
                        labelText: 'Total ${widget.type.progressUnit} (opsional)',
                        prefixIcon: const Icon(Icons.format_list_numbered_rounded),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final n = int.tryParse(value);
                          if (n == null || n <= 0) {
                            return 'Harus > 0';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Catatan.
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Catatan (opsional)',
                prefixIcon: Icon(Icons.notes_rounded),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Poster', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster preview.
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 100,
                height: 150,
                child: _buildPosterPreview(theme),
              ),
            ),
            const SizedBox(width: 14),

            // Buttons.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library_rounded),
                  label: Text(
                    _posterPath != null ? 'Ganti Poster' : 'Pilih Poster',
                  ),
                ),
                if (_posterPath != null) ...[
                  const SizedBox(height: 6),
                  TextButton.icon(
                    onPressed: _removePoster,
                    icon: Icon(
                      Icons.close_rounded,
                      color: theme.colorScheme.error,
                      size: 18,
                    ),
                    label: Text(
                      'Hapus Poster',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPosterPreview(ThemeData theme) {
    if (_newPosterFile != null) {
      return Image.file(_newPosterFile!, fit: BoxFit.cover);
    }
    if (_posterPath != null) {
      return Image.file(
        File(_posterPath!),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildPlaceholder(theme),
      );
    }
    return _buildPlaceholder(theme);
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.cardTheme.color,
      child: Icon(
        Icons.image_outlined,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        size: 32,
      ),
    );
  }
}
