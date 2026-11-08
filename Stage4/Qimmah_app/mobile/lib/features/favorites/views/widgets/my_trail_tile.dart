import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../trails/models/trail.dart';

// كرت أفقي صغير: صورة + اسم + منطقة + صعوبة + نص إضافي + عنصر بالنهاية
// (علامة حفظ في المحفوظة، علامة صح في المكتملة)
class MyTrailTile extends StatelessWidget {
  final Trail trail;
  final String detailText; // "8 كم · 3–4 ساعات" أو "أكملته 12 سبتمبر 2026"
  final Widget trailing;
  final VoidCallback? onTap;

  const MyTrailTile({
    super.key,
    required this.trail,
    required this.detailText,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _Thumb(url: trail.coverImage),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trail.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      trail.region,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _DifficultyPill(trail: trail),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            detailText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String? url;

  const _Thumb({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 88,
        height: 88,
        child: url != null
            ? Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _Placeholder(),
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : const _Placeholder(),
              )
            : const _Placeholder(),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryLight,
      child: const Icon(Icons.terrain, size: 32, color: AppColors.disabled),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.difficultyBg(trail.difficulty),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: fg),
          const SizedBox(width: 5),
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