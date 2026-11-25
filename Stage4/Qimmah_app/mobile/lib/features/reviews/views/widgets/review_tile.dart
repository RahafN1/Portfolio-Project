import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../models/review.dart';
import 'star_rating.dart';

// كرت تقييم واحد. زر التعديل والحذف يطلعون بس لو التقييم تقييمي
class ReviewTile extends StatelessWidget {
  final Review review;
  final bool isMine;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onReport;

  const ReviewTile({
    super.key,
    required this.review,
    this.isMine = false,
    this.onDelete,
    this.onEdit,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final name = review.userName.isEmpty
        ? context.l10n.reviewsAnonymousUser
        : review.userName;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  name.characters.first,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMine ? context.l10n.reviewsNameYou(name) : name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        StarRating(rating: review.rating, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          review.dateText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isMine && onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.primary),
                ),
              if (isMine && onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  tooltip: context.l10n.reviewsDeleteYours,
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.hardFg),
                ),
              if (!isMine && onReport != null)
                IconButton(
                  onPressed: onReport,
                  tooltip: context.l10n.reportReview,
                  icon: const Icon(Icons.flag_outlined, color: AppColors.grey),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}