import 'package:flutter/material.dart';

import '../routing/app_router.dart';

// تنبيه يطلع للضيف لما يحاول يسوي شي يحتاج تسجيل دخول
void showGuestLoginSheet(
  BuildContext context, {
  String title = 'سجّل دخولك عشان تحفظ المسار',
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
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // الوصف
            const Text(
              'الحفظ والتقييم وتسجيل المسارات المكتملة متاحة للمستخدمين المسجلين.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
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
                child: const Text(
                  'تسجيل الدخول',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // زر ليس الآن
            TextButton(
              onPressed: () => Navigator.pop(sheetContext), // يقفل التنبيه بس
              child: const Text(
                'ليس الآن',
                style: TextStyle(
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