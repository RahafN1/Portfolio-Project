import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../trails/models/trail.dart';
import '../viewmodels/admin_viewmodel.dart';
import 'widgets/admin_helpers.dart';

// تبويب المسارات: قائمة مع حذف
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

    return RefreshIndicator(
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
                      Text(
                        '${trail.region} · ${trail.difficultyArabic}',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'حذف المسار',
                  onPressed: () => _onDelete(context, trail),
                  icon: const Icon(Icons.delete_outline, color: adminDanger),
                ),
              ],
            ),
          );
        },
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