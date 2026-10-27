import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/trail.dart';

// صورة المسار الكبيرة + أزرار (رجوع / مشاركة / لغة) + شارة "معتمد"
// الحافة السفلية الدائرية هي شريط بلون الخلفية فوق أسفل الصورة
class DetailsHero extends StatelessWidget {
  final Trail trail;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback? onLanguageTap; // نربطه لما يضاف دعم الإنجليزي

  const DetailsHero({
    super.key,
    required this.trail,
    required this.onBack,
    required this.onShare,
    this.onLanguageTap,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 8;
    final background = Theme.of(context).scaffoldBackgroundColor;
    final image = trail.images.isNotEmpty ? trail.images.first : trail.coverImage;

    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          Positioned.fill(
            child: image != null
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const _Placeholder(),
                  )
                : const _Placeholder(),
          ),

          // الحافة الدائرية أسفل الصورة
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: background,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
            ),
          ),

          // شارة "معتمد"
          if (trail.isCertified)
            PositionedDirectional(
              start: 16,
              bottom: 44,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // زر الرجوع (يمين)
          PositionedDirectional(
            top: top,
            start: 16,
            child: _CircleButton(icon: Icons.chevron_right, onTap: onBack),
          ),

          // مشاركة + لغة (يسار)
          PositionedDirectional(
            top: top,
            end: 16,
            child: Row(
              children: [
                _LanguageButton(onTap: onLanguageTap),
                const SizedBox(width: 8),
                _CircleButton(icon: Icons.share_outlined, onTap: onShare),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 22, color: Colors.black87),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _LanguageButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Center(
            child: Text(
              'EN',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
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
      child: const Icon(Icons.landscape, size: 64, color: AppColors.primary),
    );
  }
}