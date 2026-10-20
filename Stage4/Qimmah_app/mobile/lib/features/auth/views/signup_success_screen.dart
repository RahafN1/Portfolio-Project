import 'package:flutter/material.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import 'widgets/auth_header.dart';

// تطلع بعد ما يدخل الرمز صح
class SignupSuccessScreen extends StatelessWidget {
  const SignupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(),

              // دائرة الصح
              const CircleAvatar(
                radius: 45,
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.check, color: AppColors.primary, size: 40),
              ),
              const SizedBox(height: 16),

              const Text(
                'تم إنشاء حسابك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                'كل شي جاهز، يلا نطلع للقمّة.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                text: 'متابعة',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRouter.explore, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
