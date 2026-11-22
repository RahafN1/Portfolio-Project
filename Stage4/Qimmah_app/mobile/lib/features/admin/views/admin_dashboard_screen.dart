import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/locale/locale_viewmodel.dart'; // جديد
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_viewmodel.dart'; // جديد
import '../../../l10n/l10n.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../trails/data/trails_repository.dart';
import '../data/admin_repository.dart';
import '../viewmodels/admin_viewmodel.dart';
import 'manage_reviews_screen.dart';
import 'manage_trails_screen.dart';
import 'manage_users_screen.dart';
import 'widgets/admin_helpers.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AdminViewModel(
        ctx.read<AdminRepository>(),
        ctx.read<TrailsRepository>(),
      )..load(),
      child: const _AdminView(),
    );
  }
}

class _AdminView extends StatelessWidget {
  const _AdminView();

  // الخروج: نمسح الجلسة ونرجع لصفحة البداية (بدون رجوع للأدمن)
  Future<void> _onLogout(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: context.l10n.adminLogoutConfirmTitle,
      message: context.l10n.adminLogoutConfirmMessage,
      confirmText: context.l10n.adminLogoutConfirmButton,
    );
    if (!confirmed || !context.mounted) return;

    await context.read<AuthViewModel>().logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.splash,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark; // جديد

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // زر خروج بدل سهم الرجوع (ما فيه رجوع لواجهة اليوزر)
          leading: IconButton(
            tooltip: context.l10n.logout,
            icon: const Icon(Icons.logout),
            onPressed: () => _onLogout(context),
          ),
          title: Text(
            context.l10n.adminDashboardTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // جديد: زر اللغة وزر الثيم (نفس شكل السبلاش)
          actions: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  _GlassButton(
                    isDark: isDark,
                    tooltip: 'English',
                    onTap: () => context.read<LocaleViewModel>().toggle(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'EN',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.language,
                          size: 18,
                          color: isDark
                              ? AppColors.textDark
                              : AppColors.textLight,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _GlassButton(
                    isDark: isDark,
                    tooltip: isDark ? 'الوضع الفاتح' : 'الوضع الداكن',
                    onTap: () =>
                        context.read<ThemeViewModel>().setDark(!isDark),
                    padding: const EdgeInsets.all(9),
                    child: Icon(
                      isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      size: 18,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: _buildBody(context, vm),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AdminViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(vm.errorMessage!),
            TextButton(
                onPressed: vm.load,
                child: Text(context.l10n.adminRetry)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // الأرقام
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(child: _StatCard(
                      value: vm.trailsCount,
                      label: context.l10n.adminStatTrails)),
              const SizedBox(width: 10),
              Expanded(
                  child: _StatCard(
                      value: vm.reviewsCount,
                      label: context.l10n.adminStatReviews)),
              const SizedBox(width: 10),
              Expanded(
                  child: _StatCard(
                      value: vm.usersCount,
                      label: context.l10n.adminStatUsers)),
            ],
          ),
        ),

        // التبويبات (شكل أقراص)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: context.l10n.trailsSection),
                Tab(text: context.l10n.adminTabReviews),
                Tab(text: context.l10n.adminTabUsers),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        const Expanded(
          child: TabBarView(
            children: [
              ManageTrailsScreen(),
              ManageReviewsScreen(),
              ManageUsersScreen(),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final int value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

// جديد: زر زجاجي أبيض (نفس _glassButton في السبلاش)
class _GlassButton extends StatelessWidget {
  final bool isDark;
  final String tooltip;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Widget child;

  const _GlassButton({
    required this.isDark,
    required this.tooltip,
    required this.onTap,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isDark
            ? Colors.black.withValues(alpha: 0.45)
            : Colors.white.withValues(alpha: 0.85),
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}