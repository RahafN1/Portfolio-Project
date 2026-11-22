import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';



import '../../../../core/theme/app_colors.dart';
import '../../models/trail.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/storage/image_cache.dart';   

// صورة المسار الكبيرة + أزرار (رجوع / مشاركة) + شارة "معتمد"
// SliverAppBar: لما تنزّل تتقلص الصورة، ويثبت الشريط فوق
// وفيه زر الرجوع والمشاركة واسم المسار
class DetailsHero extends StatelessWidget {
  final Trail trail;
  final VoidCallback onBack;
  final VoidCallback onShare;

  const DetailsHero({
    super.key,
    required this.trail,
    required this.onBack,
    required this.onShare,
  });

  static const double _height = 320;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final background = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final image = trail.images.isNotEmpty ? trail.images.first : trail.coverImage;
    final collapsedHeight = kToolbarHeight + topPad;

    return SliverAppBar(
      pinned: true, // يثبت الشريط فوق ولا يختفي
      automaticallyImplyLeading: false,
      expandedHeight: _height - topPad,
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 74,
      // زر الرجوع (يمين بالعربي)
      leading: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: _CircleButton(icon: Icons.chevron_left, onTap: onBack),
        ),
      ),
      // مشاركة (يسار بالعربي)
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 16),
          child: _CircleButton(icon: Icons.ios_share, onTap: onShare),
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // t = 1 الصورة كاملة، t = 0 الشريط متقلص
          final t = ((constraints.maxHeight - collapsedHeight) /
                  (_height - collapsedHeight))
              .clamp(0.0, 1.0);
          // الاسم يبدأ يظهر لما الصورة تقارب تختفي
          final titleOpacity = ((0.4 - t) / 0.4).clamp(0.0, 1.0);

          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: _height,
                child: image != null
                    ? CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        cacheManager: AppImageCache.instance,
                        errorWidget: (_, __, ___) => const _Placeholder(),
                      )
                    : const _Placeholder(),
              ),

              // لون الخلفية يغطي الصورة تدريجياً لما الشريط يتقلص
              Positioned.fill(
                child: ColoredBox(color: background.withValues(alpha: 1 - t)),
              ),

              // الحافة الدائرية أسفل الصورة
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: t,
                  child: Container(
                    height: 28,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                  ),
                ),
              ),

              // شارة "معتمد"
              if (trail.isCertified)
                PositionedDirectional(
                  start: 16,
                  bottom: 44,
                  child: Opacity(
                    opacity: t,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified,
                              size: 18, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.trailsCertified,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // اسم المسار داخل الشريط (يظهر بس لما يتقلص)
              PositionedDirectional(
                top: topPad,
                start: 74,
                end: 74,
                height: kToolbarHeight,
                child: Opacity(
                  opacity: titleOpacity,
                  child: Center(
                    child: Text(
                      trail.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
        child: Icon(icon, size: 22, color: AppColors.primary),
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