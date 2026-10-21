import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

// أعلى الصفحة: الشعار + زر الحساب + الترحيب
class ExploreHeader extends StatelessWidget {
  final String userName;
  final bool isGuest;
  final VoidCallback onProfileTap;

  const ExploreHeader({
    super.key,
    required this.userName,
    required this.isGuest,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // الشعار (يمين)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo_mountains.png', height: 22),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        AppStrings.appNameAr,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: AppColors.disabled,
                      ),
                      const Text(
                        AppStrings.appNameEn,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // زر الحساب (يسار): الضيف يدخل، المسجّل يطلع
              InkWell(
                onTap: onProfileTap,
                customBorder: const CircleBorder(),
                child: Tooltip(
                  message: isGuest ? 'تسجيل الدخول' : 'تسجيل الخروج',
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'أهلاً، $userName',
            style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.75)),
          ),
          const SizedBox(height: 4),
          Text(
            'مسارك...للقمة',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// شريط البحث + زر الفلتر
class ExploreSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final bool filterActive;

  const ExploreSearchBar({
    super.key,
    required this.onChanged,
    required this.onFilterTap,
    this.filterActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'ابحث عن مسار...',
                prefixIcon: Icon(Icons.search, color: AppColors.grey),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          // زر الفلتر، نقطة برتقالية لو فيه فلتر مفعّل
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.tune, color: AppColors.primary),
                ),
                if (filterActive)
                  const PositionedDirectional(
                    top: -2,
                    end: -2,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: AppColors.accent,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
