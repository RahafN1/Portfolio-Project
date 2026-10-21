import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
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
      _showMessage('عبّ الإيميل وكلمة المرور');
      return;
    }

    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.login(email, password);
    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRouter.explore);
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

              const Text(
                'أهلًا من جديد',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                'سجّل دخولك عشان تحفظ مساراتك وتقيّمها.',
                style: TextStyle(color: AppColors.grey),
              ),

              _label('البريد الإلكتروني'),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(hintText: 'name@example.com'),
              ),

              _label('كلمة المرور'),
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
              const SizedBox(height: 24),

              PrimaryButton(
                text: 'تسجيل الدخول',
                isLoading: viewModel.isLoading,
                onPressed: _login,
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ما عندك حساب؟'),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRouter.signup),
                    child: const Text(
                      'أنشئ حساب جديد',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              // خط "أو"
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('أو'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: _browseAsGuest,
                child: const Text('تصفّح كزائر'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
