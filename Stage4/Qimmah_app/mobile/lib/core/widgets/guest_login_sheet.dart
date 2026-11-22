import 'package:flutter/material.dart';

import '../routing/app_router.dart';
import '../../l10n/l10n.dart';

// تنبيه يطلع للضيف لما يحاول يسوي شي يحتاج تسجيل دخول
void showGuestLoginSheet(
  BuildContext context, {
   String? title,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true, // الخط الصغير اللي فوق التنبيه
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ياخذ مساحة على قد محتواه بس
          children: [
            // دائرة الأيقونة
            const CircleAvatar(
              radius: 36,
              backgroundColor: Color(0xFFE3EEE6),
              child: Icon(
                Icons.person_outline,
                size: 36,
                color: Color(0xFF1F5233),
              ),
            ),
            const SizedBox(height: 16),

            // العنوان
            Text(
                            title ?? context.l10n.coreGuestSheetTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // الوصف
             Text(
              context.l10n.coreGuestSheetBody,
              textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // زر تسجيل الدخول
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1F5233),
                ),
                onPressed: () {
                  Navigator.pop(sheetContext); // نقفل التنبيه أول
                  Navigator.pushNamed(context, AppRouter.login); // نروح للدخول
                },
                child: Text(
                  context.l10n.login,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // زر ليس الآن
            TextButton(
              onPressed: () => Navigator.pop(sheetContext), // يقفل التنبيه بس
              child: Text(
                context.l10n.coreNotNow,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1F5233),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}