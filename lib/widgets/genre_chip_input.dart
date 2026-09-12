import 'package:flutter/material.dart';

/// Input widget untuk genre — ketik teks, tekan enter/submit → jadi chip.
/// Genre di-trim, tidak boleh kosong, deduplicate case-insensitive.
class GenreChipInput extends StatefulWidget {
  final List<String> genres;
  final ValueChanged<List<String>> onChanged;

  const GenreChipInput({
    super.key,
    required this.genres,
    required this.onChanged,
  });

  @override
  State<GenreChipInput> createState() => _GenreChipInputState();
}

class _GenreChipInputState extends State<GenreChipInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addGenre(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    // Cek duplikat case-insensitive.
    final exists = widget.genres.any(
      (g) => g.toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) {
      _controller.clear();
      return;
    }

    final updated = [...widget.genres, trimmed];
    widget.onChanged(updated);
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _removeGenre(int index) {
    final updated = [...widget.genres]..removeAt(index);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Genre chips.
        if (widget.genres.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (int i = 0; i < widget.genres.length; i++)
                InputChip(
                  label: Text(widget.genres[i]),
                  onDeleted: () => _removeGenre(i),
                  deleteIconColor: theme.colorScheme.onSurfaceVariant,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
        if (widget.genres.isNotEmpty) const SizedBox(height: 8),

        // Text field.
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: const InputDecoration(
            hintText: 'Tambah genre, tekan Enter',
            prefixIcon: Icon(Icons.label_outline_rounded),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: _addGenre,
        ),
      ],
    );
  }
}
