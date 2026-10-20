import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

// الجزء اللي فوق في كل شاشات الدخول: صورة الجبل + الشعار
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          // غيّري الاسم إذا صورتك اسمها غير كذا
          child: Image.asset(
            'assets/images/hero.png',
            height: 155,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        const Icon(Icons.landscape_outlined, color: AppColors.orange, size: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'قمّة',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Container(
              width: 2,
              height: 24,
              color: AppColors.primary,
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            const Text(
              'Qimmah',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}