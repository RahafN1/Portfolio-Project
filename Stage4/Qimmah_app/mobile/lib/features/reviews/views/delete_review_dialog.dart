import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/l10n.dart';

const Color _danger = Color(0xFFA6382A);

// يسأل اليوزر: تبي تحذف تقييمك؟ يرجّع true لو أكد الحذف
Future<bool> showDeleteReviewDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.hardBg,
              child: Icon(Icons.delete_outline, color: _danger, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              ctx.l10n.reviewsDeleteTitle,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              ctx.l10n.reviewsDeleteMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Expanded لأن الأزرار عرضها الافتراضي لا نهائي
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(ctx.l10n.reviewsCancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: _danger),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(ctx.l10n.reviewsDelete),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false; // لو ضغط برا النافذة = إلغاء
}