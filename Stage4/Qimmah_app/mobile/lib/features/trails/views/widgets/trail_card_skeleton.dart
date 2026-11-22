import 'package:flutter/material.dart';

import '../../../../core/widgets/shimmer_box.dart';

// هيكل تحميل بشكل كرت المسار (نفس مقاسات TrailCard)
class TrailCardSkeleton extends StatelessWidget {
  const TrailCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      // نفس الهوامش اللي في explore_screen حول الكرت
      padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: 180, radius: 22), // الصورة
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 190, height: 18), // اسم المسار
                SizedBox(height: 10),
                SkeletonBox(width: 110, height: 13), // المنطقة
                SizedBox(height: 14),
                Row(
                  children: [
                    SkeletonBox(width: 70, height: 26, radius: 20), // الصعوبة
                    SizedBox(width: 10),
                    SkeletonBox(width: 100, height: 13), // المسافة والمدة
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}