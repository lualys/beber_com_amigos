import 'package:flutter/material.dart';

class FilterOption {
  final String id;
  final String label;
  const FilterOption(this.id, this.label);
}

class FilterChips extends StatelessWidget {
  final String title;
  final List<FilterOption> values;
  final Set<String> selected;
  final void Function(String id) onToggle;

  const FilterChips({
    super.key,
    required this.title,
    required this.values,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleSmall?.copyWith(color: Colors.white)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((v) {
            final bool isSel = selected.contains(v.id);
            return FilterChip(
              label: Text(v.label),
              selected: isSel,
              onSelected: (_) => onToggle(v.id),
            );
          }).toList(),
        ),
      ],
    );
  }
}
