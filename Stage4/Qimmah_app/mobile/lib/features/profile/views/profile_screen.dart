import 'package:flutter/material.dart'; // عناصر الواجهة
import 'package:provider/provider.dart'; // نقرأ الـ ViewModels

import '../../../core/routing/app_router.dart'; // أسماء الصفحات
import '../../../core/theme/app_colors.dart'; // الألوان
import '../../../core/theme/theme_viewmodel.dart'; // الوضع الداكن
import '../../auth/viewmodels/auth_viewmodel.dart'; // حالة تسجيل الدخول
import '../../favorites/viewmodels/favorites_viewmodel.dart'; // أرقام مساراتي

// صفحة حسابي: زائر أو مسجّلة
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // أول حرف من الاسم للدائرة
  String _initial(String name) =>
      name.trim().isEmpty ? '؟' : name.trim().characters.first;

  // حوار تأكيد تسجيل الخروج
  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل الخروج؟'),
        content:
            const Text('سيرجع حسابك كزائر، ومساراتك تبقى محفوظة في حسابك.'),
        actions: [
          // الزرين جنب بعض بنفس العرض
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('إلغاء'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade700),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('تسجيل الخروج'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final auth = context.read<AuthViewModel>();
    await auth.logout(); // نمسح التوكن والمستخدم
    auth.loginAsGuest(); // نرجع كزائر
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<AuthViewModel>().user;
    final loggedIn = user != null && !user.isGuest; // مسجّلة فعلاً؟

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'حسابي',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          if (loggedIn) ...[
            _userCard(context, user.name, user.email), // الاسم والإيميل
            const SizedBox(height: 12),
             _stats(context), // الإحصائيات
            const SizedBox(height: 20),
            const Text('الحساب',
                style: TextStyle(fontSize: 13, color: AppColors.grey)),
            const SizedBox(height: 8),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.border),
              ),
              leading: const Icon(Icons.edit_outlined),
              title: const Text('تعديل البيانات'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => _editSheet(context, user.name, user.email),
            ),
          ] else
            _guestCard(context),
          const SizedBox(height: 20),

          const Text('الإعدادات',
              style: TextStyle(fontSize: 13, color: AppColors.grey)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: SwitchListTile(
              title: const Text('الوضع الداكن'),
              secondary: const Icon(Icons.dark_mode_outlined),
              value: isDark,
              activeColor: AppColors.primary,
              onChanged: (v) => context.read<ThemeViewModel>().setDark(v),
            ),
          ),

          // زر تسجيل الخروج للمسجّلة فقط
          if (loggedIn) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade300),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.logout),
              label: const Text('تسجيل الخروج'),
            ),
          ],
        ],
      ),
    );
  }

  // بطاقة المسجّلة
  Widget _userCard(BuildContext context, String name, String email) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            child: Text(_initial(name),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(email,
                    textDirection: TextDirection.ltr,
                    style:
                        const TextStyle(color: AppColors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // الإحصائيات من بيانات مساراتي (محفوظة، مكتملة، مجموع الكيلومترات)
  Widget _stats(BuildContext context) {
    final fav = context.watch<FavoritesViewModel>();

    Widget item(String value, String label) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
                const SizedBox(height: 2),
                Text(label,
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.grey)),
              ],
            ),
          ),
        );
    return Row(
      children: [
        item('${fav.saved.length}', 'محفوظة'),
        const SizedBox(width: 8),
        item('${fav.completed.length}', 'مكتملة'),
        const SizedBox(width: 8),
        item(fav.completedDistance.toStringAsFixed(1), 'كم مشي'),
      ],
    );
  }

  // نافذة تعديل البيانات
  void _editSheet(BuildContext context, String name, String email) {
    final parts = name.trim().split(' ');
    final first = TextEditingController(text: parts.first);
    final last = TextEditingController(
        text: parts.length > 1 ? parts.sublist(1).join(' ') : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(sheetCtx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('تعديل البيانات',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: first,
                    decoration: const InputDecoration(labelText: 'الاسم الأول'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: last,
                    decoration:
                        const InputDecoration(labelText: 'اسم العائلة'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: email),
              enabled: false, // الإيميل ما يتغير
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                helperText: 'البريد ما يتغير',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                // TODO: نربطه بالباك اند لما نعرف مسار التعديل
                Navigator.pop(sheetCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الحفظ يحتاج ربط بالباك اند')),
                );
              },
              child: const Text('حفظ التعديلات'),
            ),
          ],
        ),
      ),
    );
  }

  // بطاقة الزائر
  Widget _guestCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryLight,
            child: Icon(Icons.person_outline, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          const Text('أنت تتصفح كزائر',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text(
            'سجّل دخولك عشان تحفظ مساراتك وتقيّمها وتتابع إنجازاتك.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () => Navigator.pushNamed(context, AppRouter.login),
              child: const Text('تسجيل الدخول'),
            ),
          ),
        ],
      ),
    );
  }
}