import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_header.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;

  Future<void> _signup() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('عبّ كل الحقول');
      return;
    }
    if (password.length < 8) {
      _showMessage('كلمة المرور 8 أحرف على الأقل');
      return;
    }

    // الباك اند يستقبل name واحد، فنجمع الاسم الأول والعائلة
    final name = '$firstName $lastName';

    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.register(name, email, password);
    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(context, AppRouter.otp);
    } else {
      _showMessage(viewModel.errorMessage!);
    }
  }

  void _browseAsGuest() {
    context.read<AuthViewModel>().loginAsGuest();
    Navigator.pushNamedAndRemoveUntil(
        context, AppRouter.explore, (route) => false);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

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
                'أنشئ حسابك',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                'حساب واحد تحفظ فيه مساراتك وإنجازاتك.',
                style: TextStyle(color: AppColors.grey),
              ),

              // الاسم الأول واسم العائلة جنب بعض
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('الاسم الأول'),
                        TextField(controller: firstNameController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('اسم العائلة'),
                        TextField(controller: lastNameController),
                      ],
                    ),
                  ),
                ],
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
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  '8 أحرف على الأقل',
                  style: TextStyle(color: AppColors.primary, fontSize: 12),
                ),
              ),
              const SizedBox(height: 24),

              PrimaryButton(
                text: 'إنشاء حساب',
                isLoading: viewModel.isLoading,
                onPressed: _signup,
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('عندك حساب؟'),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'سجّل دخولك',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

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
