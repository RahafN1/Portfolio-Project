import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/l10n.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_header.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose(); // نفضّي الحقل لما نطلع من الشاشة
    super.dispose();
  }

  Future<void> _send() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showMessage(context.l10n.authEnterEmail);
      return;
    }

    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.forgotPassword(email);
    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(context, AppRouter.resetPassword);
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primary, // سهم الرجوع أخضر
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(),

              Text(
                context.l10n.authForgotPassword,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                context.l10n.authForgotSubtitle,
                style: const TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 24),

              Text(
                context.l10n.email,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(hintText: 'name@example.com'),
              ),
              const SizedBox(height: 24),

              PrimaryButton(
                text: context.l10n.authSendResetCode,
                isLoading: viewModel.isLoading,
                onPressed: _send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}