import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/storage/image_cache.dart';
// ../../../../ = نطلع 4 مجلدات (widgets ← views ← trails ← features) لين نوصل lib
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
// ../../ = نطلع لـ trails، وبعدها ندخل models
import '../../models/trail.dart';
import 'package:mobile/core/utils/difficulty_label.dart';

// الكرت اللي يطلع تحت لما نضغط على علامة مسار
class MapTrailCard extends StatelessWidget {
  final Trail trail; // المسار اللي نعرضه
  final bool isOnTrail; // هل المستخدم بدأ المسار؟
  final VoidCallback onClose; // زر X
  final VoidCallback onDirections; // زر الاتجاهات
  final VoidCallback onStart; // زر ابدأ المسار
  final VoidCallback onDetails; // زر عرض التفاصيل

  const MapTrailCard({
    super.key,
    required this.trail,
    this.isOnTrail = false, // افتراضياً: ما بدأ
    required this.onClose,
    required this.onDirections,
    required this.onStart,
    required this.onDetails,
  });

  // ---------- الأرقام الثابتة (الكرت والـ carousel يستخدمونها مع بعض) ----------
  static const double _titleFontSize = 16;
  static const double _smallFontSize = 12;
  static const double _chipFontSize = 11;
  static const double _lineHeight = 1.4; // ارتفاع السطر لكل النصوص
  static const double _coverSize = 80;
  static const double _closeButtonSize = 40; // حجم زر X (compact)
  static const double _buttonsHeight = 44; // ارتفاع صف الأزرار
  static const double _cardPadding = 14;
  static const double _cardMarginV = 10;
  static const double _gapBeforeButtons = 14;

  // ارتفاع الكرت الكامل حسب تكبير الخط في الجهاز
  // الـ carousel ينادي هذي الدالة عشان يعرف كم يحجز له
  static double heightOf(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);

    final title = scaler.scale(_titleFontSize) * _lineHeight * 2; // سطرين دايماً
    final region = scaler.scale(_smallFontSize) * _lineHeight;
    final chip = math.max(
      scaler.scale(_chipFontSize) * _lineHeight + 6, // +6 = padding الشارة
      scaler.scale(_smallFontSize) * _lineHeight,
    );
    final info = title + 2 + region + 8 + chip;
    final topRow = math.max(math.max(_coverSize, info), _closeButtonSize);

    return _cardMarginV * 2 +
        _cardPadding * 2 +
        topRow +
        _gapBeforeButtons +
        _buttonsHeight +
        4; // هامش أمان صغير
  }

  @override
  Widget build(BuildContext context) {
    // ارتفاع سطرين بالضبط، مع احترام تكبير الخط في الجهاز
    final titleBoxHeight =
        MediaQuery.textScalerOf(context).scale(_titleFontSize) *
            _lineHeight *
            2;

    return Container(
      // أفقي صغير عشان الفراغ بين الكروت في الـ carousel ما يكبر
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: _cardMarginV,
      ),
      padding: const EdgeInsets.all(_cardPadding), // مسافة داخل الكرت
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // الكرت بطول محتواه بس
        children: [
          // ---------- الجزء الأول: الصورة + المعلومات + X ----------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المسار (بالعربي تجي يمين)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _cover(),
              ),
              const SizedBox(width: 12),

              // المعلومات تاخذ المساحة الباقية
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المسار: نحجز له سطرين دايماً عشان الكروت كلها تتساوى
                    SizedBox(
                      height: titleBoxHeight,
                      child: Text(
                        trail.name,
                        maxLines: 2, // سطرين بالكثير
                        overflow: TextOverflow.ellipsis, // لو أطول نحط ...
                        strutStyle: const StrutStyle(
                          fontSize: _titleFontSize,
                          height: _lineHeight,
                          forceStrutHeight: true,
                        ),
                        style: const TextStyle(
                          fontSize: _titleFontSize,
                          height: _lineHeight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // المنطقة
                    Text(
                      trail.region,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: _smallFontSize,
                        height: _lineHeight,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // الصعوبة + المسافة والمدة
                    Row(
                      children: [
                        _DifficultyChip(
                          difficulty: trail.difficulty,
                          label: difficultyLabel(context, trail.difficulty),
                        ),
                        const SizedBox(width: 6),
                        // Flexible + FittedBox: النص يصغّر لين يتسع بدل ما يتقص بـ ...
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown, // يصغّر بس، ما يكبّر
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              context.l10n.mapDistanceAndDuration(
                                trail.distanceText,
                                trail.estimatedDuration,
                              ),
                              maxLines: 1,
                              softWrap: false,
                              style: const TextStyle(
                                fontSize: _smallFontSize,
                                height: _lineHeight,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // زر X (بالعربي يجي يسار)
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, size: 20),
                visualDensity: VisualDensity.compact, // زر أصغر
              ),
            ],
          ),
          const SizedBox(height: _gapBeforeButtons),

          // ---------- الجزء الثاني: الأزرار ----------
          // ارتفاع ثابت، والأزرار تتمدد تملأه
          SizedBox(
            height: _buttonsHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // الاتجاهات (أخضر فاتح)
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onDirections,
                    icon: const Icon(Icons.near_me_outlined, size: 16),
                    label: _ButtonText(context.l10n.mapDirections),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                  ),
                ),

                // ابدأ المسار (أخضر غامق) — يختفي لو المستخدم بدأ
                if (!isOnTrail) ...[
                  const SizedBox(width: 6),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onStart,
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: _ButtonText(context.l10n.mapStartTrail),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 6),

                // عرض التفاصيل (أبيض بإطار)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDetails,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    child: _ButtonText(context.l10n.mapViewDetails),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // صورة المسار، ولو ما فيه صورة نحط أيقونة جبل
  Widget _cover() {
    final placeholder = Container(
      width: _coverSize,
      height: _coverSize,
      color: AppColors.primaryLight,
      child: const Icon(Icons.landscape, color: AppColors.primary),
    );

    if (trail.coverImage == null) return placeholder;

return CachedNetworkImage(
  imageUrl: trail.coverImage!,
  width: _coverSize,
  height: _coverSize,
  fit: BoxFit.cover,
  memCacheWidth: 300,
  cacheManager: AppImageCache.instance,
  placeholder: (_, __) => placeholder,
  errorWidget: (_, __, ___) => placeholder,
);
  }
}

// نص الزر: يصغر لحاله لو المكان ضيق بدل ما يطلع برّا
class _ButtonText extends StatelessWidget {
  final String text;

  const _ButtonText(this.text);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown, // يصغّر النص بس، ما يكبّره
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// شارة الصعوبة: لونها يتغيّر حسب سهل/متوسط/صعب
class _DifficultyChip extends StatelessWidget {
  final String difficulty; // easy أو moderate أو hard
  final String label; // سهل أو متوسط أو صعب

  const _DifficultyChip({required this.difficulty, required this.label});

  @override
  Widget build(BuildContext context) {
    // نختار اللون حسب الصعوبة
    Color color;
    if (difficulty == 'easy') {
      color = AppColors.primary; // أخضر
    } else if (difficulty == 'hard') {
      color = AppColors.orange; // برتقالي
    } else {
      color = const Color(0xFF3B6BB5); // أزرق للمتوسط
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12), // نفس اللون بس فاتح
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // النقطة الصغيرة
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- الـ Carousel: يلف بين الكروت ----------
class MapTrailCarousel extends StatefulWidget {
  final List<Trail> trails;
  final int initialIndex;
  final bool isOnTrail;
  final ValueChanged<Trail> onTrailChanged; // حرّك الكاميرا + حدّد المؤشر
  final VoidCallback onClose;
  final ValueChanged<Trail> onDirections;
  final ValueChanged<Trail> onStart;
  final ValueChanged<Trail> onDetails;

  const MapTrailCarousel({
    super.key,
    required this.trails,
    required this.onTrailChanged,
    required this.onClose,
    required this.onDirections,
    required this.onStart,
    required this.onDetails,
    this.initialIndex = 0,
    this.isOnTrail = false,
  });

  @override
  State<MapTrailCarousel> createState() => MapTrailCarouselState();
}

class MapTrailCarouselState extends State<MapTrailCarousel> {
  late final PageController _controller = PageController(
    viewportFraction: 0.92, // يبان طرف الكرت اللي بعده
    initialPage: widget.initialIndex,
  );

  // تناديها من برّا لما المستخدم يضغط مؤشر في الخريطة
  Future<void> goTo(int index) async {
    if (!_controller.hasClients) return;
    await _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // نحدد أقصى تكبير للخط (1.3) عشان التصميم ما ينفلت
    return MediaQuery(
      data: mq.copyWith(
        textScaler: mq.textScaler.clamp(maxScaleFactor: 1.3),
      ),
      // Builder: عشان heightOf يقرأ الـ MediaQuery الجديد (المحدود)
      child: Builder(
        builder: (context) {
          return SizedBox(
            // الارتفاع يتحسب تلقائياً من حجم الخط، بدون رقم ثابت
            height: MapTrailCard.heightOf(context),
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.trails.length,
              onPageChanged: (i) => widget.onTrailChanged(widget.trails[i]),
              itemBuilder: (context, i) {
                final t = widget.trails[i];
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: MapTrailCard(
                    trail: t,
                    isOnTrail: widget.isOnTrail,
                    onClose: widget.onClose,
                    onDirections: () => widget.onDirections(t),
                    onStart: () => widget.onStart(t),
                    onDetails: () => widget.onDetails(t),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}