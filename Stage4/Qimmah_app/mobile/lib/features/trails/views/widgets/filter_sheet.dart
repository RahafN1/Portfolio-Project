import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../viewmodels/explore_viewmodel.dart';

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

  static const _difficulties = <MapEntry<String?, String>>[
    MapEntry(null, 'الكل'),
    MapEntry('easy', 'سهل'),
    MapEntry('moderate', 'متوسط'),
    MapEntry('hard', 'صعب'),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExploreViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'تصفية المسارات',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: vm.hasActiveFilters ? vm.resetFilters : null,
                  child: const Text('إعادة ضبط'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('الصعوبة',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final d in _difficulties)
                  ChoiceChip(
                    label: Text(d.value),
                    selected: vm.selectedDifficulty == d.key,
                    selectedColor: AppColors.primaryLight,
                    onSelected: (_) => vm.setDifficulty(d.key),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('المنطقة',
                style: TextStyle(fontWeight: FontWeight.bold)),
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
              child: Text('عرض ${vm.filtered.length} مسار'),
            ),
          ],
        ),
      ),
    );
  }
}
