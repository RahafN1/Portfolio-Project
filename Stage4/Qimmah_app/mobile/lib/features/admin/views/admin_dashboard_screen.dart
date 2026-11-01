import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
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
      title: 'تسجيل الخروج؟',
      message: 'بترجعين لصفحة البداية.',
      confirmText: 'خروج',
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // زر خروج بدل سهم الرجوع (ما فيه رجوع لواجهة اليوزر)
          leading: IconButton(
            tooltip: 'تسجيل الخروج',
            icon: const Icon(Icons.logout),
            onPressed: () => _onLogout(context),
          ),
          title: const Text(
            'لوحة التحكم',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
            TextButton(onPressed: vm.load, child: const Text('حاول مرة ثانية')),
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
              Expanded(child: _StatCard(value: vm.trailsCount, label: 'مسارات')),
              const SizedBox(width: 10),
              Expanded(
                  child: _StatCard(value: vm.reviewsCount, label: 'تقييمات')),
              const SizedBox(width: 10),
              Expanded(
                  child: _StatCard(value: vm.usersCount, label: 'مستخدمين')),
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
              tabs: const [
                Tab(text: 'المسارات'),
                Tab(text: 'التقييمات'),
                Tab(text: 'المستخدمين'),
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