import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/l10n.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_header.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  String code = '';
  bool hidePassword = true;
  int seconds = 60; // السيرفر ما يسمح بطلب رمز جديد قبل دقيقة
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    passwordController.dispose();
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

  // نفس شروط الباك اند: 8 أحرف + حرف كبير + حرف صغير + رقم
  bool _isStrong(String p) =>
      p.length >= 8 &&
      RegExp(r'[A-Z]').hasMatch(p) &&
      RegExp(r'[a-z]').hasMatch(p) &&
      RegExp(r'\d').hasMatch(p);

  Future<void> _reset() async {
    final password = passwordController.text;
    if (!_isStrong(password)) {
      _showMessage(context.l10n.authPasswordRules);
      return;
    }

    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.resetPassword(code, password);
    if (!mounted) return;

    if (success) {
      final messenger = ScaffoldMessenger.of(context);
      final text = context.l10n.authResetSuccess;
      Navigator.pushNamedAndRemoveUntil(
          context, AppRouter.login, (route) => false);
      messenger.showSnackBar(SnackBar(content: Text(text)));
    } else {
      _showMessage(viewModel.errorMessage!);
    }
  }

  Future<void> _resend() async {
    final viewModel = context.read<AuthViewModel>();
    final email = viewModel.emailToReset;
    if (email == null) return;

    final success = await viewModel.forgotPassword(email);
    if (!mounted) return;

    if (success) {
      _showMessage(context.l10n.authNewCodeSent);
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(),
              Text(
                context.l10n.authResetTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                context.l10n.authOtpSentTo,
                style: const TextStyle(color: AppColors.grey),
              ),
              Text(
                viewModel.emailToReset ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              Text(context.l10n.authOtpLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 6,
                  defaultPinTheme: boxTheme,
                  focusedPinTheme: focusedBoxTheme,
                  onChanged: (value) => setState(() => code = value),
                ),
              ),
              const SizedBox(height: 20),

              Text(context.l10n.authNewPassword,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  helperText: context.l10n.authPasswordRules,
                  helperMaxLines: 2,
                  suffixIcon: IconButton(
                    icon: Icon(hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              PrimaryButton(
                text: context.l10n.authResetButton,
                isLoading: viewModel.isLoading,
                onPressed: code.length == 6 ? _reset : null,
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.l10n.authOtpNotReceived),
                  TextButton(
                    onPressed: seconds > 0 ? null : _resend,
                    child: Text(
                      seconds > 0
                          ? context.l10n.authOtpResendIn(seconds)
                          : context.l10n.authOtpResend,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}