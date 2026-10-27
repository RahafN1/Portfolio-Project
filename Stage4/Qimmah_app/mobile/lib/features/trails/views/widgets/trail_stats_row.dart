import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/trail.dart';

// الكروت الثلاثة: المسافة / المدة / الصعوبة (الصعوبة ملوّنة حسب مستواها)
class TrailStatsRow extends StatelessWidget {
  final Trail trail;

  const TrailStatsRow({super.key, required this.trail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.route,
            value: '${trail.distanceText} كم',
            label: 'المسافة',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.schedule,
            value: trail.estimatedDuration.isEmpty
                ? '-'
                : trail.estimatedDuration,
            label: 'المدة المتوقعة',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.landscape,
            value: trail.difficultyArabic,
            label: 'الصعوبة',
            fg: AppColors.difficultyFg(trail.difficulty),
            bg: AppColors.difficultyBg(trail.difficulty),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? fg; // لون مخصص (للصعوبة)
  final Color? bg;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.fg,
    this.bg,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final iconColor = fg ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      decoration: BoxDecoration(
        color: bg ?? cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: bg == null ? Border.all(color: AppColors.border) : null,
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: fg?.withOpacity(0.8) ?? AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}