import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/explore_viewmodel.dart';
import 'widgets/difficulty_chips.dart';
import 'widgets/explore_header.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/region_tabs.dart';
import 'widgets/trail_card.dart';

// الرئيسية: ترحيب + بحث + فلاتر + المسارات
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
    final isGuest = user?.isGuest == true;
    final name = (isGuest || (user?.name ?? '').isEmpty)
    ? 'مستكشف'
    : user!.name.trim().split(' ').first;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: explore.loadTrails,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            ExploreHeader(
              userName: name,
              isGuest: user?.isGuest == true,
              onProfileTap: _logout,
            ),
            ExploreSearchBar(
              onChanged: explore.setSearch,
              onFilterTap: () => showFilterSheet(context),
              filterActive: explore.hasActiveFilters,
            ),
            DifficultyChips(
              selected: explore.selectedDifficulty,
              onSelected: explore.setDifficulty,
            ),
            RegionTabs(
              regions: explore.regions,
              selected: explore.selectedRegion,
              onSelected: explore.setRegion,
            ),
            ..._buildContent(explore),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent(ExploreViewModel explore) {
    if (explore.isLoading) {
      return const [
        SizedBox(
          height: 260,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (explore.errorMessage != null) {
      return [
        SizedBox(
          height: 260,
          child: Center(
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
          ),
        ),
      ];
    }

    if (explore.filtered.isEmpty) {
      return [
        SizedBox(
          height: 260,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('ما فيه مسارات تطابق بحثك'),
                if (explore.hasActiveFilters || explore.searchQuery.isNotEmpty)
                  TextButton(
                    onPressed: explore.resetFilters,
                    child: const Text('إعادة ضبط الفلاتر'),
                  ),
              ],
            ),
          ),
        ),
      ];
    }

    final featured = explore.featured;
    final others = explore.others;

    return [
      // مسارات مختارة (أفقي)
      const _SectionTitle(title: 'مسارات مختارة', subtitle: 'موصى بها لك'),
      SizedBox(
        height: 330,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: featured.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) => TrailCard(
            trail: featured[i],
            width: 290,
            isSaved: explore.isSaved(featured[i].id),
            onSaveTap: () => explore.toggleSaved(featured[i].id),
          ),
        ),
      ),

      // مسارات أخرى (عمودي)
      if (others.isNotEmpty) ...[
        const _SectionTitle(title: 'مسارات أخرى'),
        for (final trail in others)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TrailCard(
              trail: trail,
              isSaved: explore.isSaved(trail.id),
              onSaveTap: () => explore.toggleSaved(trail.id),
            ),
          ),
      ],
    ];
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionTitle({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null)
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFC97B47),
                fontWeight: FontWeight.w600,
              ),
            ),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
