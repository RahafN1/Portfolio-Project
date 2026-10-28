import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../trails/models/trail.dart';
import '../../trails/views/trail_details_screen.dart';
import '../models/completed_trail.dart';
import '../viewmodels/favorites_viewmodel.dart';
import 'widgets/completed_banner.dart';
import 'widgets/my_trail_tile.dart';
import 'widgets/my_trails_header.dart';
import 'widgets/my_trails_tabs.dart';

// مساراتي: للضيف دعوة لتسجيل الدخول، وللمسجّل تبويبين (محفوظة / مكتملة)
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // الضيف ما عنده مسارات نجيبها
      if (!context.read<AuthViewModel>().isGuest) {
        context.read<FavoritesViewModel>().load();
      }
    });
  }

  void _openDetails(Trail trail) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TrailDetailsScreen(trail: trail)),
    );
  }

  Future<void> _unsave(Trail trail) async {
    final ok = await context.read<FavoritesViewModel>().removeSaved(trail);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ما قدرنا نلغي الحفظ، حاول مرة ثانية')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = context.watch<AuthViewModel>().isGuest;

    return SafeArea(
      child: Column(
        children: [
          const MyTrailsHeader(),
          Expanded(child: isGuest ? const _GuestState() : _buildSignedIn()),
        ],
      ),
    );
  }

  Widget _buildSignedIn() {
    final vm = context.watch<FavoritesViewModel>();

    return RefreshIndicator(
      onRefresh: vm.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        // يخلي السحب للتحديث يشتغل حتى لو القائمة قصيرة
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const Text(
            'مساراتي',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          MyTrailsTabs(
            selected: vm.tab,
            savedCount: vm.saved.length,
            completedCount: vm.completed.length,
            onSelected: vm.setTab,
          ),
          const SizedBox(height: 16),
          ..._buildContent(vm),
        ],
      ),
    );
  }

  List<Widget> _buildContent(FavoritesViewModel vm) {
    if (vm.isLoading) {
      return const [LoadingIndicator(topPadding: 80)];
    }

    if (vm.errorMessage != null) {
      return [
        _Message(
          text: vm.errorMessage!,
          actionLabel: 'حاول مرة ثانية',
          onAction: vm.load,
        ),
      ];
    }

    if (vm.tab == MyTrailsTab.saved) {
      if (vm.saved.isEmpty) {
        return const [_Message(text: 'ما حفظت أي مسار للحين')];
      }
      return [
        for (final trail in vm.saved)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MyTrailTile(
              trail: trail,
              detailText: _meta(trail),
              onTap: () => _openDetails(trail),
              trailing: IconButton(
                tooltip: 'إلغاء الحفظ',
                onPressed: () => _unsave(trail),
                icon: const Icon(Icons.bookmark, color: AppColors.primary),
              ),
            ),
          ),
      ];
    }

    if (vm.completed.isEmpty) {
      return const [_Message(text: 'ما أكملت أي مسار للحين')];
    }
    return [
      CompletedBanner(
        count: vm.completed.length,
        distance: vm.completedDistance,
      ),
      const SizedBox(height: 12),
      for (final item in vm.completed)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: MyTrailTile(
            trail: item.trail,
            detailText: _completedText(item),
            onTap: () => _openDetails(item.trail),
            trailing: const _CheckBadge(),
          ),
        ),
    ];
  }

  // "8 كم · 3–4 ساعات"
  String _meta(Trail trail) {
    final km = '${trail.distanceText} كم';
    if (trail.estimatedDuration.isEmpty) return km;
    return '$km · ${trail.estimatedDuration}';
  }

  // "أكملته 12 سبتمبر 2026"
  String _completedText(CompletedTrail item) {
    final date = item.completedAtText;
    return date.isEmpty ? 'مكتمل' : 'أكملته $date';
  }
}

// حالة الضيف: دعوة لتسجيل الدخول
class _GuestState extends StatelessWidget {
  const _GuestState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const Text(
          'مساراتي',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 72),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_border,
              size: 44,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'مساراتك في مكان واحد',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'سجّل دخولك عشان تحفظ المسارات وتتابع إنجازاتك.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.grey, height: 1.6),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: SizedBox(
            width: 180,
            height: 52,
            child: FilledButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.login),
              child: const Text('تسجيل الدخول'),
            ),
          ),
        ),
      ],
    );
  }
}

// علامة الصح بالمسار المكتمل
class _CheckBadge extends StatelessWidget {
  const _CheckBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 18, color: AppColors.primary),
    );
  }
}

// رسالة وسط القائمة (فاضي أو خطأ)
class _Message extends StatelessWidget {
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _Message({required this.text, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.grey, fontSize: 15),
          ),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}