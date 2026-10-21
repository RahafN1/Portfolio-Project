import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_header.dart';
import '../../../core/constants/app_strings.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String code = ''; // الأرقام اللي كتبها المستخدم
  int seconds = 60; // العداد قبل إعادة الإرسال
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel(); // نوقف العداد لما نطلع من الشاشة
    super.dispose();
  }

  void _startTimer() {
    seconds = 60;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
      } else {
        setState(() => seconds--);
      }
    });
  }

  Future<void> _verify() async {
    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.verifyEmail(code);
    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRouter.signupSuccess, (route) => false);
    } else {
      _showMessage(viewModel.errorMessage!);
    }
  }

  Future<void> _resend() async {
    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.resendCode();
    if (!mounted) return;

    if (success) {
      _showMessage('أرسلنا رمز جديد');
      setState(() => _startTimer());
    } else {
      _showMessage(viewModel.errorMessage!);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    // شكل مربعات الأرقام
    final boxTheme = PinTheme(
      width: 52,
      height: 58,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
    );
    final focusedBoxTheme = boxTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(),

              // دائرة الإيميل
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.mail_outline,
                    color: AppColors.primary, size: 32),
              ),
              const SizedBox(height: 16),

              const Text(
                'تحقق من بريدك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                'أرسلنا رمز من 6 أرقام إلى',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.grey),
              ),
              Text(
                viewModel.emailToVerify ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              const Text('رمز التحقق',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // الأرقام من اليسار لليمين حتى لو التطبيق عربي
              Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 6,
                  defaultPinTheme: boxTheme,
                  focusedPinTheme: focusedBoxTheme,
                  onChanged: (value) => setState(() => code = value),
                ),
              ),
              const SizedBox(height: 24),

              // الزر مقفل لين تكتمل الست أرقام
              PrimaryButton(
                text: 'تأكيد',
                isLoading: viewModel.isLoading,
                onPressed: code.length == 6 ? _verify : null,
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ما وصلك الرمز؟'),
                  TextButton(
                    onPressed: seconds > 0 ? null : _resend,
                    child: Text(
                      seconds > 0
                          ? 'إعادة الإرسال بعد $seconds ث'
                          : 'إعادة الإرسال',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              // يرجع لشاشة التسجيل عشان يعدل الإيميل
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'تغيير البريد الإلكتروني',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// صفحة "تم إنشاء حسابك": تطلع بعد ما الرمز يتأكد
class SignupSuccessScreen extends StatelessWidget {
  const SignupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // العناصر بعرض كامل
            children: [
              const AuthHeader(), // الصورة والشعار

              // دائرة علامة الصح
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.check, color: AppColors.primary, size: 36),
              ),
              const SizedBox(height: 16),

              // تم إنشاء حسابك
              const Text(
                AppStrings.accountCreatedTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),

              // كل شي جاهز، يلا نطلع للقمّة.
              const Text(
                AppStrings.accountCreatedSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 32),

              // زر متابعة: يروح للاستكشاف ويمسح الصفحات اللي قبل
              PrimaryButton(
                text: AppStrings.continueText,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.explore,
                  (route) => false,
                ),
              ),
              const SizedBox(height: 12),

              // رجوع للنموذج: يرجع لصفحة التسجيل
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRouter.signup),
                child: const Text(
                  AppStrings.backToForm,
                  style: TextStyle(color: AppColors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
