import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

// نافذة "نحتاج نعرف موقعك" اللي تطلع من تحت
// ترجّع true لو ضغط "السماح"، و false لو "ليس الآن"
class LocationPermissionSheet extends StatelessWidget {
  const LocationPermissionSheet({super.key});

  // نفتح النافذة وننتظر وش يختار المستخدم
  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true, // النافذة تاخذ الطول اللي تحتاجه
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        // زوايا دائرية من فوق بس
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const LocationPermissionSheet(),
    );
    // لو سكّرها بدون ما يختار (سحبها لتحت) = نعتبرها "لا"
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min, // النافذة بطول محتواها بس
          children: [
            // الخط الصغير اللي فوق (يوضح إن النافذة تنسحب)
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // دائرة زرقاء فاتحة فيها أيقونة الموقع
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE3ECFA), // أزرق فاتح
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 34,
                color: Color(0xFF2F6FD6), // أزرق
              ),
            ),
            const SizedBox(height: 16),

            // نحتاج نعرف موقعك
            const Text(
              AppStrings.locationTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // الشرح
            const Text(
              AppStrings.locationBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, height: 1.5),
            ),
            const SizedBox(height: 24),

            // زر السماح: يسكّر النافذة ويرجّع true
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  AppStrings.locationAllow,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ليس الآن: يسكّر النافذة ويرجّع false
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                AppStrings.locationNotNow,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}