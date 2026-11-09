import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/guest_login_sheet.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../favorites/viewmodels/favorites_viewmodel.dart';
import '../data/trails_repository.dart';
import '../models/trail.dart';
import '../viewmodels/trail_details_viewmodel.dart';
import 'widgets/details_bottom_bar.dart';
import 'widgets/details_hero.dart';
import 'widgets/safety_tips_card.dart';
import 'widgets/start_point_card.dart';
import 'widgets/trail_stats_row.dart';
import '../../reviews/data/reviews_repository.dart';
import '../../reviews/viewmodels/reviews_viewmodel.dart';
import '../../reviews/views/widgets/reviews_section.dart';
import 'widgets/photo_viewer.dart';
import 'trail_map_screen.dart';

// مؤقت للرسالة، عشان تطلع مرة وحدة بعد ما يسكت المستخدم

Timer? _saveToastTimer;
Timer? _completeToastTimer;

// صفحة تفاصيل المسار
// نعرض بيانات القائمة فوراً، والتفاصيل الكاملة (نبذة، صور، نصائح) تنجاب بعدين
class TrailDetailsScreen extends StatelessWidget {
  final Trail trail; // المسار اللي ضغط عليه اليوزر

  const TrailDetailsScreen({super.key, required this.trail});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) =>
              TrailDetailsViewModel(ctx.read<TrailsRepository>(), trail)
                ..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReviewsViewModel(
            ctx.read<ReviewsRepository>(),
            trail.id,
            ctx.read<AuthViewModel>().user?.id ?? 0, // الضيف = 0
          )..load(),
        ),
      ],
      child: const _DetailsView(),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView();

  // رسالة صغيرة تطلع تحت (فوق الشريط السفلي)
  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

    Future<void> _onSave(BuildContext context, Trail trail) async {
    // الضيف يطلع له تنبيه تسجيل الدخول
    if (context.read<AuthViewModel>().isGuest) {
      showGuestLoginSheet(context);
      return;
    }
    final favorites = context.read<FavoritesViewModel>();
    await favorites.toggleSaved(trail);

    _saveToastTimer?.cancel();
    _saveToastTimer = Timer(const Duration(milliseconds: 500), () {
      if (!context.mounted) return;
      _toast(
        context,
        favorites.isSaved(trail.id)
            ? 'تم الحفظ '
            : '  تم ازالة الحفظ ',
      );
    });
  }

    Future<void> _onComplete(BuildContext context, Trail trail) async {
    if (context.read<AuthViewModel>().isGuest) {
      showGuestLoginSheet(context, title: 'سجّل دخولك عشان تسجّل المسار');
      return;
    }
    final favorites = context.read<FavoritesViewModel>();
    await favorites.toggleCompleted(trail);

    _completeToastTimer?.cancel();
    _completeToastTimer = Timer(const Duration(milliseconds: 500), () {
      if (!context.mounted) return;
      _toast(
        context,
        favorites.isCompleted(trail.id)
            ? 'مبروك! اكتمل المسار  '
            : '  تم ازالة المسار',
      );
    });
  }

// المشاركة: نفتح قائمة المشاركة (واتساب، رسائل...) باسم المسار + رابط الموقع
Future<void> _onShare(BuildContext context, Trail trail) async {
  final lines = [
    trail.name,
    '${trail.region} · ${trail.distanceText} كم',
    if (trail.locationUrl != null) trail.locationUrl!,
  ];
await SharePlus.instance.share(
  ShareParams(text: lines.join('\n'), subject: trail.name),
);
}

  Future<void> _onDirections(BuildContext context, Trail trail) async {
    final url = trail.directionsUrl;
    if (url == null) return;
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
    if (!opened && context.mounted) {
      _toast(context, 'ما قدرنا نفتح تطبيق الخرائط');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TrailDetailsViewModel>();
    final favorites = context.watch<FavoritesViewModel>();
    final trail = vm.trail;
    final reviews = context.watch<ReviewsViewModel>();

    return Scaffold(
      bottomNavigationBar: DetailsBottomBar(
        isSaved: favorites.isSaved(trail.id),
        isCompleted: favorites.isCompleted(trail.id),
        onSave: () => _onSave(context, trail),
        onComplete: () => _onComplete(context, trail),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          DetailsHero(
            trail: trail,
            onBack: () => Navigator.pop(context),
            onShare: () => _onShare(context, trail),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleRow(
                trail: trail,
                   // المتوسط من التقييمات (يتحدث بعد النشر والحذف)
                rating: reviews.hasLoaded ? reviews.averageRating : trail.averageRating,
                          ),
                const SizedBox(height: 18),
                TrailStatsRow(trail: trail),
                const SizedBox(height: 24),
                const _SectionTitle('نبذة عن المسار'),
                _About(vm: vm),
                if (trail.images.length > 1) ...[
                  const SizedBox(height: 16),
                  _PhotoStrip(images: trail.images),
                ],
                         if (trail.hasStartPoint) ...[
                  const SizedBox(height: 24),
                  const _SectionTitle('نقطة البداية'),
             StartPointCard(
  point: LatLng(trail.startLat!, trail.startLng!),
  route: trail.routePoints,
  onDirections: () => _onDirections(context, trail),
  // الضغط على الخريطة: نفتح التتبّع على نفس المسار
  onMapTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TrailMapScreen(
        initialTrail: trail,
        startTracking: true,
      ),
    ),
  ),
),
                ],
                if (trail.safetyTips.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const _SectionTitle('نصائح السلامة'),
                  SafetyTipsCard(tips: trail.safetyTips),
                ],
                  const SizedBox(height: 24),
                  ReviewsSection(trailName: trail.name),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// الاسم + التقييم (لو موجود) + المنطقة
class _TitleRow extends StatelessWidget {
  final Trail trail;
  final double? rating;

  const _TitleRow({required this.trail, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                trail.name,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            if (rating != null) ...[
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      rating!.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 18, color: AppColors.accent),
                  ],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 18, color: AppColors.grey),
            const SizedBox(width: 4),
            Text(
              trail.region,
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// النبذة: النص، أو تحميل، أو خطأ مع إعادة المحاولة
class _About extends StatelessWidget {
  final TrailDetailsViewModel vm;

  const _About({required this.vm});

  @override
  Widget build(BuildContext context) {
    final trail = vm.trail;

    if (trail.description.isNotEmpty) {
      return Text(
        trail.description,
        style: TextStyle(
          fontSize: 15,
          height: 1.8,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
        ),
      );
    }

    if (vm.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.errorMessage != null) {
      return Row(
        children: [
          Text(vm.errorMessage!,
              style: const TextStyle(color: AppColors.grey, fontSize: 14)),
          TextButton(onPressed: vm.retry, child: const Text('حاول مرة ثانية')),
        ],
      );
    }

    return const Text(
      'ما فيه نبذة لهذا المسار للحين.',
      style: TextStyle(color: AppColors.grey, fontSize: 14),
    );
  }
}

// شريط الصور الأفقي
class _PhotoStrip extends StatelessWidget {
  final List<String> images;

  const _PhotoStrip({required this.images});

  // كل الصور بنفس الحجم، بنسبة ٤:٣
  static const double _height = 130;
  static const double _width = _height * 4 / 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: ListView.separated(
        // نفس بادنق الصفحة، والصور تكمل تنزلق لحافة الشاشة
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => GestureDetector(
          // الضغط يفتح الصورة بملء الشاشة على نفس الصورة
          onTap: () => showPhotoViewer(context, images, i),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: images[i],
              width: _width,
              height: _height,
              fit: BoxFit.cover,
              // نصغّر الصورة بالذاكرة (٣ أضعاف العرض) عشان ما تاكل رام
              memCacheWidth: (_width * 3).toInt(),
              placeholder: (_, __) => Container(
                color: AppColors.primaryLight,
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.primaryLight,
                child: const Icon(Icons.terrain, color: AppColors.disabled),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
