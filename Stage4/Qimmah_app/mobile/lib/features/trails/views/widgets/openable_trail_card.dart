import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../models/trail.dart';
import '../trail_details_screen.dart';
import 'trail_card.dart';

// كرت المسار اللي يتحول لصفحة التفاصيل بأنيميشن (Container Transform)
class OpenableTrailCard extends StatelessWidget {
  final Trail trail;
  final bool isSaved;
  final VoidCallback? onSaveTap;

  const OpenableTrailCard({
    super.key,
    required this.trail,
    this.isSaved = false,
    this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 400),
      tappable: false, // الضغط يجي من الكرت نفسه عشان زر الحفظ ما يفتح الصفحة
      closedElevation: 2,
      closedColor: theme.colorScheme.surface,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22), // نفس زوايا الكرت
      ),
      openElevation: 0,
      openColor: theme.scaffoldBackgroundColor,
      closedBuilder: (context, openContainer) => TrailCard(
        trail: trail,
        isSaved: isSaved,
        onSaveTap: onSaveTap,
        onTap: openContainer, // الضغط يشغّل الأنيميشن
        elevation: 0, // الشادو يرسمه OpenContainer
      ),
      openBuilder: (context, _) => TrailDetailsScreen(trail: trail),
    );
  }
}