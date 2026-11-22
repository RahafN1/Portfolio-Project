import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../viewmodels/explore_viewmodel.dart';
import 'package:mobile/l10n/app_localizations.dart';

// ورقة الفلتر اللي تنفتح من زر الضبط جنب البحث
void showFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => const _FilterSheet(),
  );
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  static const _difficulties = <String?>[null, 'easy', 'moderate', 'hard'];

  String _difficultyLabel(BuildContext context, String? key) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'easy':
        return l10n.difficultyEasy;
      case 'moderate':
        return l10n.difficultyModerate;
      case 'hard':
        return l10n.difficultyHard;
      default:
        return l10n.all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExploreViewModel>();
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.filterTrails,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: vm.hasActiveFilters ? vm.resetFilters : null,
                  child: Text(l10n.resetShort),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(l10n.difficulty,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final key in _difficulties)
                  ChoiceChip(
                    label: Text(_difficultyLabel(context, key)),
                   selected: vm.selectedDifficulty == key,
                    onSelected: (_) => vm.setDifficulty(key),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.region,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final r in vm.regions)
                  ChoiceChip(
                    label: Text(r),
                    selected: vm.selectedRegion == r,
                    selectedColor: AppColors.primaryLight,
                    onSelected: (_) => vm.setRegion(r),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.showTrails(vm.total)),
            ),
          ],
        ),
      ),
    );
  }
}