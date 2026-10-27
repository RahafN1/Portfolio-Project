import 'package:flutter/material.dart';
import '../../features/profile/views/profile_screen.dart';
import '../../features/trails/views/explore_screen.dart';
import '../theme/app_colors.dart';
import '../../features/favorites/views/favorites_screen.dart';
import '../../features/trails/views/trail_map_screen.dart';
// الهيكل الرئيسي: الصفحة الحالية + شريط التنقل السفلي
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // الترتيب من اليمين لليسار: استكشاف، الخريطة، مساراتي، حسابي
  static const _tabs = [
    _TabInfo('استكشف', Icons.home_outlined, Icons.home),
    _TabInfo('الخريطة', Icons.map_outlined, Icons.map),
    _TabInfo('مساراتي', Icons.bookmark_border, Icons.bookmark),
    _TabInfo('حسابي', Icons.person_outline, Icons.person),
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
  final String label;
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
    final cs = Theme.of(context).colorScheme;
    final inactive = cs.onSurface.withOpacity(0.55);

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          i == currentIndex ? tabs[i].activeIcon : tabs[i].icon,
                          color:
                              i == currentIndex ? AppColors.primary : inactive,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tabs[i].label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: i == currentIndex
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: i == currentIndex
                                ? AppColors.primary
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
    );
  }
}

// مكان مؤقت للصفحات اللي ما انبنت للحين
class _ComingSoon extends StatelessWidget {
  final String title;

  const _ComingSoon({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Center(child: Text('$title — قريباً')));
  }
}
