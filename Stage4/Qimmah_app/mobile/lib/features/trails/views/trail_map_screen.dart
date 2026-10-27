import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

// صفحة الخريطة: علامات المسارات + البحث + زر موقعي
class TrailMapScreen extends StatefulWidget {
  const TrailMapScreen({super.key});

  @override
  State<TrailMapScreen> createState() => _TrailMapScreenState();
}

class _TrailMapScreenState extends State<TrailMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack: طبقات فوق بعض
      body: Stack(
        children: [
          // 1) الخريطة — مؤقتاً مربع ملوّن لين نختار المكتبة
          Container(
            color: const Color(0xFFF1EADB),
            alignment: Alignment.center,
            child: const Text(
              'الخريطة هنا',
              style: TextStyle(color: AppColors.grey),
            ),
          ),

          // 2) البحث + زر EN فوق
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _SearchBar(),
            ),
          ),

          // 3) زر "موقعي" يسار تحت
          Positioned(
            left: 16,
            bottom: 90,
            child: _LocateButton(onTap: () {}),
          ),

          // 4) التلميح تحت في النص
          const Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Center(child: _HintChip()),
          ),
        ],
      ),
    );
  }
}

// ---------------- القطع الصغيرة ----------------

// شريط البحث الأبيض + زر EN
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // حقل البحث (بالعربي يجي يمين)
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.mapSearchHint,
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none, // بدون إطار
                enabledBorder: InputBorder.none, // بدون إطار في الحالة العادية
                focusedBorder: InputBorder.none, // بدون إطار لما نضغط عليه
                filled: false, // بدون لون خلفية من الثيم
              ),
            ),
          ),
          const SizedBox(width: 8),
          // زر EN (يجي يسار) — شكل بس حالياً
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'EN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// زر "موقعي" المربع الأبيض
class _LocateButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LocateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3, // ظل خفيف
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.my_location, color: AppColors.primary),
        ),
      ),
    );
  }
}

// التلميح الداكن: "اضغط على علامة لعرض المسار"
class _HintChip extends StatelessWidget {
  const _HintChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A24), // أخضر غامق جداً
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min, // بحجم محتواه بس
        children: [
          Icon(Icons.location_on_outlined, color: Colors.white, size: 16),
          SizedBox(width: 6),
          Text(
            AppStrings.mapTapHint,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}