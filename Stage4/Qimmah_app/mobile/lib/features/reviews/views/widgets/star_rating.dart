import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

// نجوم التقييم. لو حطيتي onChanged تصير قابلة للضغط، وإلا للعرض فقط
class StarRating extends StatelessWidget {
  final int rating; // من 0 إلى 5
  final double size;
  final ValueChanged<int>? onChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 18,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final star = Icon(
          Icons.star_rounded,
          size: size,
          color: i < rating ? AppColors.accent : AppColors.border,
        );
        if (onChanged == null) return star;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged!(i + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: star,
          ),
        );
      }),
    );
  }
}