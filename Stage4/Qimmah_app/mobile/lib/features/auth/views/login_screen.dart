import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/l10n.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage(context.l10n.authFillEmailPassword);
      return;
    }

    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.login(email, password);
    if (!mounted) return;

    if (success) {
      if (viewModel.isAdmin) {
        // نمسح كل الصفحات اللي قبلها، فما فيه رجوع لواجهة اليوزر
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.admin,
          (route) => false,
        );
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.explore);
      }
    } else {
      _showMessage(viewModel.errorMessage!);
    }
  }
  void _browseAsGuest() {
    context.read<AuthViewModel>().loginAsGuest();
    Navigator.pushReplacementNamed(context, AppRouter.explore);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // العنوان الصغير فوق كل حقل
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(),

              Text(
                context.l10n.authLoginTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                context.l10n.authLoginSubtitle,
                style: const TextStyle(color: AppColors.grey),
              ),

              _label(context.l10n.email),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(hintText: 'name@example.com'),
              ),

              _label(context.l10n.authPassword),
              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  // زر العين يظهر ويخفي كلمة المرور
                  suffixIcon: IconButton(
                    icon: Icon(hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () {
                      setState(() => hidePassword = !hidePassword);
                    },
                  ),
                ),
              ),

              // رابط نسيت كلمة المرور
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRouter.forgotPassword),
                  child: Text(
                    context.l10n.authForgotPassword,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: context.l10n.login,
                isLoading: viewModel.isLoading,
                onPressed: _login,
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.l10n.authNoAccount),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRouter.signup),
                    child: Text(
                      context.l10n.authCreateAccount,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              // خط "أو"
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(context.l10n.authOr),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: _browseAsGuest,
                child: Text(context.l10n.authBrowseAsGuest),
              ),
            ],
          ),
        ),
      ),
    );
  }
}