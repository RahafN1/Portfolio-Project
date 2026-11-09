import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

// الشريط الأخضر: "أنت على المسار" + المتبقي + تقدّم + زر إنهاء
class OnTrailBanner extends StatelessWidget {
  final int secondsAgo; // كم ثانية مرّت من آخر تحديث للموقع
  final VoidCallback onEnd; // وش يصير لما نضغط "إنهاء"
  final double? remainingMeters; // المتبقي من المسار (null = ما حسبناه)
  final double? fraction; // نسبة المقطوع 0..1
  final bool offRoute; // هل ابتعد عن المسار؟

  const OnTrailBanner({
    super.key,
    required this.secondsAgo,
    required this.onEnd,
    this.remainingMeters,
    this.fraction,
    this.offRoute = false,
  });

  String _format(double meters) => meters < 1000
      ? '${meters.round()} م'
      : '${(meters / 1000).toStringAsFixed(1)} كم';

  @override
  Widget build(BuildContext context) {
    final subtitle = offRoute
        ? AppStrings.onTrailOffRoute
        : remainingMeters != null
            ? '${AppStrings.onTrailRemaining} ${_format(remainingMeters!)}'
            : '${AppStrings.onTrailUpdated} قبل $secondsAgo ث';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: offRoute ? AppColors.accent : AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  offRoute ? Icons.warning_amber_rounded : Icons.check,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      AppStrings.onTrailTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
OutlinedButton(
  onPressed: onEnd,
  style: OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,   // يلغي الأبيض من الثيم
    foregroundColor: Colors.white,
    minimumSize: const Size(0, 36),        // يلغي infinity و56 من الثيم
    side: const BorderSide(color: Colors.white70),
    padding: const EdgeInsets.symmetric(horizontal: 14),
  ),
  child: const Text(
    AppStrings.onTrailEnd,
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
),
            ],
          ),
          // شريط التقدّم
          if (fraction != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}