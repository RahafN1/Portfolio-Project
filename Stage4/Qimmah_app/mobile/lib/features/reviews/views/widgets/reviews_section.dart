import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/guest_login_sheet.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import '../../models/review.dart';
import '../../viewmodels/reviews_viewmodel.dart';
import '../delete_review_dialog.dart';
import '../write_review_sheet.dart';
import 'review_tile.dart';

// قسم التقييمات في صفحة التفاصيل
class ReviewsSection extends StatelessWidget {
  final String trailName;

  const ReviewsSection({super.key, required this.trailName});

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _onWrite(BuildContext context) async {
    // الضيف يطلع له تنبيه تسجيل الدخول
    if (context.read<AuthViewModel>().isGuest) {
      showGuestLoginSheet(context, title: 'سجّل دخولك عشان تقيّم المسار');
      return;
    }
    final vm = context.read<ReviewsViewModel>();
    final posted = await showWriteReviewSheet(
      context,
      vm: vm,
      trailName: trailName,
    );
    if (posted == true && context.mounted) {
      _toast(context, 'تم نشر تقييمك، شكراً لك!');
    }
  }

  Future<void> _onDelete(BuildContext context, Review review) async {
    final confirmed = await showDeleteReviewDialog(context);
    if (!confirmed || !context.mounted) return;

    final ok = await context.read<ReviewsViewModel>().deleteReview(review);
    if (!context.mounted) return;
    _toast(
      context,
      ok ? 'تم حذف تقييمك' : 'ما قدرنا نحذف التقييم، حاول مرة ثانية',
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReviewsViewModel>();
    final mine = vm.myReview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                vm.total > 0 ? 'التقييمات (${vm.total})' : 'التقييمات',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // زر الكتابة يختفي لو كتبت تقييم من قبل
            if (vm.hasLoaded && mine == null)
              TextButton.icon(
                onPressed: () => _onWrite(context),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('اكتب تقييمك'),
              ),
          ],
        ),
        const SizedBox(height: 6),
        if (vm.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (vm.errorMessage != null && vm.reviews.isEmpty)
          Row(
            children: [
              Text(
                vm.errorMessage!,
                style: const TextStyle(color: AppColors.grey, fontSize: 14),
              ),
              TextButton(
                onPressed: vm.retry,
                child: const Text('حاول مرة ثانية'),
              ),
            ],
          )
        else if (vm.reviews.isEmpty)
          const Text(
            'ما فيه تقييمات للحين، كن أول من يقيّم هذا المسار.',
            style: TextStyle(color: AppColors.grey, fontSize: 14),
          )
        else ...[
          // تقييمي أول القائمة
          if (mine != null)
            ReviewTile(
              review: mine,
              isMine: true,
              onDelete: () => _onDelete(context, mine),
            ),
          for (final review in vm.reviews)
            if (review.id != mine?.id) ReviewTile(review: review),
        ],
      ],
    );
  }
}