import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart'; 
import '../../../../core/constants/app_strings.dart';

// الجزء اللي فوق في كل شاشات الدخول: صورة الجبل + الشعار
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          // صورة الرجال
          child: Image.asset(
            'assets/images/splash_hero.jpg',
            height: 155,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        Image.asset('assets/images/logo_mountains.png', height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
               AppStrings.appNameAr,
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
              AppStrings.appNameEn,
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