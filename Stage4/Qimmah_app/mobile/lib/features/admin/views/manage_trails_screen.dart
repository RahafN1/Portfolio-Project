import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../trails/models/trail.dart';
import '../viewmodels/admin_viewmodel.dart';
import 'add_trail_screen.dart';
import 'widgets/admin_helpers.dart';

// تبويب المسارات: قائمة مع إضافة وتعديل وحذف
class ManageTrailsScreen extends StatelessWidget {
  const ManageTrailsScreen({super.key});

  Future<void> _onDelete(BuildContext context, Trail trail) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'حذف المسار؟',
      message: 'بينحذف "${trail.name}" مع كل تقييماته ومفضلاته نهائياً.',
      confirmText: 'حذف',
    );
    if (!confirmed || !context.mounted) return;

    final ok = await context.read<AdminViewModel>().deleteTrail(trail);
    if (!context.mounted) return;
    showAdminToast(
      context,
      ok ? 'تم حذف المسار' : 'ما قدرنا نحذف المسار، حاول مرة ثانية',
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminViewModel>();

    if (vm.trails.isEmpty) {
      return const Center(child: Text('ما فيه مسارات'));
    }

    return Column(
      children: [
        // زر إضافة مسار
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // نمرر الـ ViewModel للصفحة الجديدة
                    builder: (_) => ChangeNotifierProvider.value(
                      value: vm,
                      child: const AddTrailScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('إضافة مسار'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),

        // القائمة
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => vm.load(silent: true),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: vm.trails.length,
              itemBuilder: (context, index) {
                final trail = vm.trails[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: trail.coverImage != null
                              ? Image.network(
                                  trail.coverImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const _Thumb(),
                                )
                              : const _Thumb(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trail.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            // المنطقة ثم الشارة (مثل التصميم)
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    trail.region,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13, color: AppColors.grey),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _DifficultyBadge(label: trail.difficultyArabic),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // زر التعديل (أخضر): يفتح صفحة الإضافة بوضع التعديل
                      _SquareIconButton(
                        tooltip: 'تعديل المسار',
                        icon: Icons.edit_outlined,
                        color: AppColors.primary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // نمرر الـ ViewModel والمسار للصفحة الجديدة
                              builder: (_) => ChangeNotifierProvider.value(
                                value: vm,
                                child: AddTrailScreen(trail: trail),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      // زر الحذف (أحمر)
                      _SquareIconButton(
                        tooltip: 'حذف المسار',
                        icon: Icons.delete_outline,
                        color: adminDanger,
                        onTap: () => _onDelete(context, trail),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// زر مربع صغير بخلفية خفيفة (للتعديل والحذف)
class _SquareIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SquareIconButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}

// شارة الصعوبة الصغيرة
class _DifficultyBadge extends StatelessWidget {
  final String label;

  const _DifficultyBadge({required this.label});

  // اللون حسب الصعوبة
  Color get _color {
    switch (label) {
      case 'سهل':
        return Colors.green;
      case 'متوسط':
        return Colors.blue;
      case 'صعب':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: _color,
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryLight,
      child: const Icon(Icons.terrain, color: AppColors.disabled),
    );
  }
}