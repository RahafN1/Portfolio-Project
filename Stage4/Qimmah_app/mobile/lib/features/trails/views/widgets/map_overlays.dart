import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

// القطع الصغيرة اللي تنرسم فوق الخريطة (علامات، أزرار، بحث، تلميح)

// علامة المسار: أخضر عادي، وبرتقالي لو مختارة
class TrailPin extends StatelessWidget {
  final bool isSelected;

  const TrailPin({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.accent : AppColors.primary;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // شكل الدبوس
        Icon(Icons.location_on, size: 44, color: color),
        // أيقونة جبل صغيرة داخل الدبوس
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(Icons.terrain, size: 16, color: Colors.white),
        ),
      ],
    );
  }
}

// علامة نهاية المسار: دبوس أبيض وفيه علم أخضر
class EndPin extends StatelessWidget {
  const EndPin({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.topCenter,
      children: [
        // ظل خفيف عشان الدبوس الأبيض يبان على الخريطة
        Icon(Icons.location_on, size: 44, color: Colors.black38),
        // الدبوس الأبيض
        Icon(Icons.location_on, size: 42, color: Colors.white),
        // علم أخضر داخل الدبوس
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(Icons.flag, size: 16, color: AppColors.primary),
        ),
      ],
    );
  }
}

// النقطة الزرقاء: موقع المستخدم
class MyLocationDot extends StatelessWidget {
  const MyLocationDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F6FD6), // أزرق
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3), // إطار أبيض
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6),
        ],
      ),
    );
  }
}

// شريط البحث
class MapSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged; // يُنادى كل ما تتغيّر الكتابة

  const MapSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        onChanged: onChanged, // نرسل النص للصفحة
        decoration: InputDecoration(
          hintText: context.l10n.searchHint,
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }
}

// زر مربع أبيض بأيقونة: يستخدم لـ "موقعي" ولزر الرجوع
class MapSquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const MapSquareButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3, // ظل خفيف
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }
}

// التلميح الداكن: "اضغط على علامة لعرض المسار"
class MapHintChip extends StatelessWidget {
  const MapHintChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A24), // أخضر غامق جداً
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // بحجم محتواه بس
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            context.l10n.mapTapHint,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}