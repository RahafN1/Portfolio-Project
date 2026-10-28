import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

// الشريط الأخضر: "أنت على المسار" + آخر تحديث + زر إنهاء
class OnTrailBanner extends StatelessWidget {
  final int secondsAgo; // كم ثانية مرّت من آخر تحديث للموقع
  final VoidCallback onEnd; // وش يصير لما نضغط "إنهاء"

  const OnTrailBanner({
    super.key,
    required this.secondsAgo,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary, // أخضر غامق
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // دائرة علامة الصح (بالعربي تجي يمين)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2), // أبيض شفاف
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),

          // النصوص تاخذ المساحة الباقية
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // أنت على المسار
                const Text(
                  AppStrings.onTrailTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                // آخر تحديث: قبل 5 ث
                Text(
                  '${AppStrings.onTrailUpdated} قبل $secondsAgo ث',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // زر إنهاء (بالعربي يجي يسار)
          OutlinedButton(
            onPressed: onEnd,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white, // النص أبيض
              backgroundColor: Colors.transparent, // يلغي الخلفية البيضاء من الثيم
              side: const BorderSide(color: Colors.white70), // إطار أبيض
              padding: const EdgeInsets.symmetric(horizontal: 14),
              minimumSize: const Size(0, 40), // يلغي double.infinity من الثيم
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              AppStrings.onTrailEnd,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}