import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../reviews/views/widgets/star_rating.dart';
import '../models/admin_models.dart';
import '../viewmodels/admin_viewmodel.dart';
import 'widgets/admin_helpers.dart';

// تبويب التقييمات: الأدمن يحذف التقييم المسيء
class ManageReviewsScreen extends StatelessWidget {
  const ManageReviewsScreen({super.key});

  Future<void> _onDelete(BuildContext context, AdminReview review) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'حذف هذا التقييم؟',
      message: 'بينحذف التقييم لأنه مخالف لسياسة المحتوى، وما يقدر صاحبه يرجعه.',
      confirmText: 'حذف',
    );
    if (!confirmed || !context.mounted) return;

    final ok = await context.read<AdminViewModel>().deleteReview(review);
    if (!context.mounted) return;
    showAdminToast(
      context,
      ok ? 'تم حذف التقييم' : 'ما قدرنا نحذف التقييم، حاول مرة ثانية',
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminViewModel>();

    if (vm.reviews.isEmpty) {
      return const Center(child: Text('ما فيه تقييمات'));
    }

    return RefreshIndicator(
      onRefresh: () => vm.load(silent: true),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: vm.reviews.length,
        itemBuilder: (context, index) {
          final review = vm.reviews[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.userName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${review.trailName} · ${review.timeAgo}',
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.grey),
                ),
                const SizedBox(height: 6),
                StarRating(rating: review.rating, size: 16),
                const SizedBox(height: 8),
                Text(review.comment, style: const TextStyle(height: 1.6)),
                const SizedBox(height: 10),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.hardBg,
                    foregroundColor: adminDanger,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _onDelete(context, review),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('حذف التقييم'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}