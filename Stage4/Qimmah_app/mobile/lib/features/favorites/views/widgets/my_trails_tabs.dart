import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../viewmodels/favorites_viewmodel.dart';

// تبويبين: المحفوظة (يمين) / المكتملة (يسار) مع العدد
class MyTrailsTabs extends StatelessWidget {
  final MyTrailsTab selected;
  final int savedCount;
  final int completedCount;
  final ValueChanged<MyTrailsTab> onSelected;

  const MyTrailsTabs({
    super.key,
    required this.selected,
    required this.savedCount,
    required this.completedCount,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'المحفوظة ($savedCount)',
            active: selected == MyTrailsTab.saved,
            onTap: () => onSelected(MyTrailsTab.saved),
          ),
          _TabItem(
            label: 'المكتملة ($completedCount)',
            active: selected == MyTrailsTab.completed,
            onTap: () => onSelected(MyTrailsTab.completed),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              // النص الأخضر داخل التبويب الأبيض فقط، فما يتأثر بالوضع الداكن
              color: active ? AppColors.primary : AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}