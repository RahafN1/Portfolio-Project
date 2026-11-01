import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../viewmodels/explore_viewmodel.dart';

// تبويبات المناطق مع خط تحت المختار
class RegionTabs extends StatelessWidget {
  final List<String> regions;
  final String selected;
  final ValueChanged<String> onSelected;

  const RegionTabs({
    super.key,
    required this.regions,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final inactive = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            for (final region in regions)
              InkWell(
                onTap: () => onSelected(region),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: region == selected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (region != ExploreViewModel.allRegions) ...[
                        Icon(Icons.location_on_outlined,
                            size: 15, color: inactive),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        region,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: region == selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color:
                              region == selected ? AppColors.primary : inactive,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
