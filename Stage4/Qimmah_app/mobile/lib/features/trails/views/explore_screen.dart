import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/explore_viewmodel.dart';
import 'widgets/trail_card.dart';

// الرئيسية: اسم المستخدم + قائمة المسارات
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    // أول ما تفتح الشاشة نجيب المسارات
  WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<ExploreViewModel>().loadTrails();
});
  }

  Future<void> _logout() async {
    await context.read<AuthViewModel>().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, AppRouter.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().user;
    final explore = context.watch<ExploreViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('قمّة'),
        actions: [
          IconButton(
            // الضيف يشوف زر دخول، المسجّل يشوف زر خروج
            icon: Icon(user?.isGuest == true ? Icons.login : Icons.logout),
            tooltip: user?.isGuest == true ? 'تسجيل الدخول' : 'تسجيل الخروج',
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أهلاً، ${user?.name ?? ''}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildTrails(explore)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrails(ExploreViewModel explore) {
    if (explore.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (explore.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(explore.errorMessage!),
            TextButton(
              onPressed: explore.loadTrails,
              child: const Text('حاول مرة ثانية'),
            ),
          ],
        ),
      );
    }

    if (explore.trails.isEmpty) {
      return const Center(child: Text('ما فيه مسارات'));
    }

    return ListView.builder(
      itemCount: explore.trails.length,
      itemBuilder: (context, index) => TrailCard(trail: explore.trails[index]),
    );
  }
}
