import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/trail.dart';

// كرت المسار: صورة + اسم + تقييم + منطقة + صعوبة
// width = عرض ثابت للكروت الأفقية (المختارة)، وبدونه ياخذ العرض كامل
class TrailCard extends StatelessWidget {
  final Trail trail;
  final double? width;
  final bool isSaved;
  final VoidCallback? onSaveTap;
  final VoidCallback? onTap;

  const TrailCard({
    super.key,
    required this.trail,
    this.width,
    this.isSaved = false,
    this.onSaveTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      child: Material(
        color: cs.surface,
        elevation: 2,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImage(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trail.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (trail.averageRating != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            trail.averageRating!.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.star,
                              size: 16, color: AppColors.accent),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 16, color: AppColors.grey),
                        const SizedBox(width: 4),
                        Text(
                          trail.region,
                          style: const TextStyle(
                              color: AppColors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _DifficultyPill(trail: trail),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            _meta(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.grey, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // "9 كم · 3–4 ساعات"
  String _meta() {
    final km = '${trail.distanceText} كم';
    if (trail.estimatedDuration.isEmpty) return km;
    return '$km · ${trail.estimatedDuration}';
  }

  Widget _buildImage() {
    return Stack(
      children: [
        SizedBox(
          height: 180,
          width: double.infinity,
          child: trail.coverImage != null
              ? Image.network(
                  trail.coverImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : _placeholder(),
                )
              : _placeholder(),
        ),
        // شارة "معتمد" (يمين)
        if (trail.isCertified)
          PositionedDirectional(
            top: 12,
            start: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 18, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'معتمد',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        // زر الحفظ (يسار)
        PositionedDirectional(
          top: 12,
          end: 12,
          child: InkWell(
            onTap: onSaveTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.primaryLight,
      child: const Icon(Icons.terrain, size: 56, color: AppColors.disabled),
    );
  }
}

// حبة الصعوبة الملوّنة
class _DifficultyPill extends StatelessWidget {
  final Trail trail;

  const _DifficultyPill({required this.trail});

  @override
  Widget build(BuildContext context) {
    final fg = AppColors.difficultyFg(trail.difficulty);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.difficultyBg(trail.difficulty),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: fg),
          const SizedBox(width: 6),
          Text(
            trail.difficultyArabic,
            style:
                TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
