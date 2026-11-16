import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

// الشريط الأخضر: "أكملت مسارين · 17 كم مشي"
class CompletedBanner extends StatelessWidget {
  final int count;
  final double distance;

  const CompletedBanner({
    super.key,
    required this.count,
    required this.distance,
  });

  String get _distanceText =>
      distance % 1 == 0 ? distance.toStringAsFixed(0) : distance.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.favoritesCompletedBanner(count, _distanceText),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Opacity(
            opacity: 0.85,
            child: Image.asset('assets/images/logo_mountains.png', height: 22),
          ),
        ],
      ),
    );
  }
}