import 'package:flutter/material.dart';
import '../../features/profile/views/profile_screen.dart';
import '../../features/trails/views/explore_screen.dart';
import '../theme/app_colors.dart';
import '../../features/favorites/views/favorites_screen.dart';
import '../../features/trails/views/trail_map_screen.dart';
import '../../l10n/l10n.dart';

// الهيكل الرئيسي: الصفحة الحالية + شريط التنقل السفلي
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // الترتيب من اليمين لليسار: استكشاف، الخريطة، مساراتي، حسابي
  static final _tabs = [
    _TabInfo((c) => c.l10n.tabExplore, Icons.home_outlined, Icons.home),
    _TabInfo((c) => c.l10n.tabMap, Icons.map_outlined, Icons.map),
    _TabInfo((c) => c.l10n.tabMyTrails, Icons.bookmark_border, Icons.bookmark),
    _TabInfo((c) => c.l10n.tabProfile, Icons.person_outline, Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack عشان الصفحة تحافظ على حالتها لما ننتقل بين التبويبات
      body: IndexedStack(
        index: _index,
        children: const [
          ExploreScreen(),
          TrailMapScreen(),
          FavoritesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        tabs: _tabs,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _TabInfo {
  final String Function(BuildContext) label;
  final IconData icon;
  final IconData activeIcon;

  const _TabInfo(this.label, this.icon, this.activeIcon);
}
class _BottomBar extends StatelessWidget {
  final List<_TabInfo> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
final isDark = Theme.of(context).brightness == Brightness.dark;
//عشان النافقيشن يصير يتفاعل مع الاسود والالبيض 
   final barColor = isDark ? const Color(0xFF22382B) : const Color(0xFF0F2D1C);
    final inactive = isDark ? const Color(0xFFA9B8AF) : const Color(0xFFC9D1CC);

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(32),
                 border: isDark
                  ? Border.all(color: Colors.white.withValues(alpha: 0.08))
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                for (var i = 0; i < tabs.length; i++)
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: () => onTap(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            tabs[i].icon,
                            color: i == currentIndex
                                ? AppColors.accent
                                : inactive,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tabs[i].label(context),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: i == currentIndex
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: i == currentIndex
                                  ? AppColors.accent
                                  : inactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}