import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/difficulty_label.dart';

// شرائح الصعوبة: الكل / سهل / متوسط / صعب
class DifficultyChips extends StatelessWidget {
  final String? selected; // null = الكل
  final ValueChanged<String?> onSelected;

  const DifficultyChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  // المفاتيح بس، النص المعروض يجي من الترجمة
  static const _items = <String?>[null, 'easy', 'moderate', 'hard'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          for (final key in _items) ...[
            Expanded(
              child: _Chip(
                difficulty: key,
                label: key == null ? l10n.all : difficultyLabel(context, key),
                isSelected: selected == key,
                onTap: () => onSelected(key),
              ),
            ),
            if (key != _items.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String? difficulty;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.difficulty,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAll = difficulty == null;
    final fg = isAll ? Colors.white : AppColors.difficultyFg(difficulty!);
    final bg = isAll
        ? (isSelected ? AppColors.primary : AppColors.primaryLight)
        : AppColors.difficultyBg(difficulty!);
    final textColor = isAll && !isSelected ? AppColors.primary : fg;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          // الشريحة المختارة لها إطار بلونها
          border: Border.all(
            color: isSelected && !isAll ? fg : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isAll) ...[
              CircleAvatar(radius: 3.5, backgroundColor: fg),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}