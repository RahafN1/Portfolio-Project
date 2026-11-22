import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/l10n.dart';
import '../models/trail.dart';
import '../utils/map_camera_animator.dart';
import '../viewmodels/explore_viewmodel.dart';
import '../viewmodels/trail_tracking_viewmodel.dart';
import 'trail_details_screen.dart';
import 'widgets/location_permission_sheet.dart';
import 'widgets/map_overlays.dart';
import 'widgets/map_trail_card.dart';
import 'widgets/on_trail_banner.dart';

// صفحة الخريطة: علامات المسارات + البحث + موقعي + كروت المسار (تلف) + على المسار
// الشاشة هنا بس توصّل القطع ببعض:
//   - حركة الكاميرا      ← MapCameraAnimator
//   - التتبّع والموقع    ← TrailTrackingViewModel
//   - القطع الصغيرة      ← widgets/map_overlays.dart
class TrailMapScreen extends StatefulWidget {
  // لو جينا من صفحة التفاصيل: نفتح الخريطة على هذا المسار
  final Trail? initialTrail;

  // نبدأ التتبّع مباشرة أول ما تنفتح الشاشة
  final bool startTracking;

  const TrailMapScreen({
    super.key,
    this.initialTrail,
    this.startTracking = false,
  });

  @override
  State<TrailMapScreen> createState() => _TrailMapScreenState();
}

class _TrailMapScreenState extends State<TrailMapScreen>
    with SingleTickerProviderStateMixin {
  // وسط المملكة ومستوى التكبير اللي يبين المملكة كلها
  static const LatLng _saudiCenter = LatLng(24.5, 44.0);
  static const double _saudiZoom = 5.5;

  // لون خط المسار
  static const Color _routeColor = Color(0xFF1E5BFF);

  // "ريموت" الخريطة، ومحرّك الكاميرا اللي يستخدمه
  final MapController _mapController = MapController();
  late final MapCameraAnimator _camera =
      MapCameraAnimator(vsync: this, mapController: _mapController);

  // التتبّع الحي (الموقع، التقدّم، العدّاد)
  final TrailTrackingViewModel _tracking =
      TrailTrackingViewModel(LocationService());

  // مفتاح الـ carousel: نحرّكه من الكود لما نضغط علامة
  final GlobalKey<MapTrailCarouselState> _carouselKey =
      GlobalKey<MapTrailCarouselState>();

  // نأخّر اختيار المسار لين يستقر الكرت (عشان ما نثقل الشاشة أثناء السحب)
  Timer? _swipeDebounce;

  // أثناء ما الـ carousel يتحرك بالكود، نتجاهل الصفحات اللي يمر عليها
  bool _carouselAnimating = false;

  // المسار اللي ضغطنا على علامته (null = ما اخترنا شي)
  Trail? _selected;

  // النص اللي في البحث ('' = ما كتبنا شي)
  String _query = '';

  // نقاط خط المسار المختار
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();

    // نسمع التتبّع: كل تغيير نعيد رسم الشاشة، والأحداث نتصرف فيها هنا
    _tracking.addListener(_refresh);
    _tracking.onPosition = _followUser;
    _tracking.onFinished = () {
      _showMessage(context.l10n.mapOnTrailFinished);
    };
    _tracking.onLocationError = () {
      _showMessage(context.l10n.mapLocationError);
    };

    // الخريطة تحتاج كل العلامات، فنجيبها لوحدها (بدون صفحات)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreViewModel>().loadMapTrails();
      _openInitialTrail();
    });
  }

  // لما الصفحة تنقفل: نوقف كل شي شغّال عشان ما يضل شغّال
  @override
  void dispose() {
    _swipeDebounce?.cancel();
    _camera.dispose();
    _tracking
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // ---------- اختيار المسار ----------

  // لو جينا من التفاصيل: نختار المسار، نرسم خطه، ونبدأ التتبّع
  Future<void> _openInitialTrail() async {
    final trail = widget.initialTrail;
    if (trail == null) return;

    if (trail.routePoints.length > 1) {
      // الخط جاهز من صفحة التفاصيل، ما نحتاج طلب جديد
      setState(() {
        _selected = trail;
        _routePoints = trail.routePoints;
      });
      _camera.fitNow(trail.routePoints);
    } else {
      await _selectTrail(trail); // نجيب الخط من الباك إند
    }

    if (widget.startTracking && mounted) await _startTrail();
  }

  // المسارات الظاهرة على الخريطة: عندها نقطة بداية، واسمها فيه نص البحث
  List<Trail> _visibleTrails(ExploreViewModel vm) {
    final query = _query.trim();
    return vm.mapTrails
        .where((t) => t.startLat != null && t.startLng != null)
        .where((t) => t.name.contains(query))
        .toList();
  }

  // المسارات اللي يلف بينها الكرت:
  // - وإحنا على المسار: كرت واحد بس (ما نخلي المستخدم يلف)
  // - لو المسار المختار مو في القائمة (مثلاً جينا من التفاصيل): نضيفه أول القائمة
  List<Trail> _carouselTrails(ExploreViewModel vm) {
    final selected = _selected;
    if (selected == null) return const [];
    if (_tracking.onTrail) return [selected];

    final list = _visibleTrails(vm);
    if (!list.any((t) => t.id == selected.id)) {
      return [selected, ...list];
    }
    return list;
  }

  // لما نضغط علامة (أو نلف الكرت): نعرض الكرت، ونجيب خط المسار ونرسمه
  Future<void> _selectTrail(Trail trail, {bool fromCarousel = false}) async {
    // لو على المسار، ما نغيّر المسار المختار
    if (_tracking.onTrail) return;

    final wasShowing = _selected != null;

    setState(() {
      _selected = trail;
      _routePoints = [];
    });

    // لو الكرت ظاهر والمستخدم ضغط علامة: نحرّك الـ carousel للكرت الجديد
    if (wasShowing && !fromCarousel) {
      final list = _carouselTrails(context.read<ExploreViewModel>());
      final index = list.indexWhere((t) => t.id == trail.id);
      if (index >= 0) unawaited(_moveCarouselTo(index));
    }

    // المرحلة 1: الكاميرا تنزلق لبداية المسار فوراً (بدون ما ننتظر الخط)
    if (trail.startLat != null && trail.startLng != null) {
      _camera.animateTo(
        LatLng(trail.startLat!, trail.startLng!),
        _mapController.camera.zoom,
        ms: 500,
      );
    }

    try {
      final full =
          await context.read<ExploreViewModel>().loadTrailDetails(trail.id);

      // لو اختار مسار ثاني أو سكّر الكرت وإحنا ننتظر، نتجاهل
      if (!mounted || _selected?.id != trail.id) return;

      setState(() => _routePoints = full.routePoints);

      // المرحلة 2: لما يوصل الخط، نقرّب بسلاسة لين يبان كامل
      if (full.routePoints.length > 1) {
        _camera.animateToFit(full.routePoints);
      }
    } catch (_) {
      // لو فشل الجلب، يبقى الكرت والعلامة بدون خط
    }
  }

  // نحرّك الـ carousel بالكود، ونتجاهل الصفحات اللي يمر عليها أثناء الحركة
  Future<void> _moveCarouselTo(int index) async {
    _carouselAnimating = true;
    try {
      await _carouselKey.currentState?.goTo(index);
    } finally {
      _carouselAnimating = false;
    }
  }

  // لما يلف المستخدم الكرت: ننتظر لين يستقر، وبعدين نختار المسار
  void _onCarouselChanged(Trail t) {
    if (_carouselAnimating) return;
    _swipeDebounce?.cancel();
    _swipeDebounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      if (_selected?.id != t.id) _selectTrail(t, fromCarousel: true);
    });
  }

  // ---------- البحث ----------

  // كل ما تتغيّر الكتابة في البحث
  void _onSearch(String value) {
    // نحفظ النص ونسكّر الكرت
    setState(() {
      _query = value;
      _selected = null;
    });

    // لو البحث فاضي: نرجع للمملكة كلها
    if (value.trim().isEmpty) {
      _camera.animateTo(_saudiCenter, _saudiZoom);
      return;
    }

    // لو مسار واحد بس يطابق: نقرّب عليه
    final matches = _visibleTrails(context.read<ExploreViewModel>());
    if (matches.length == 1) {
      final trail = matches.first;
      _camera.animateTo(LatLng(trail.startLat!, trail.startLng!), 11);
    }
  }

  // ---------- الموقع والتتبّع ----------

  // يجيب موقع المستخدم ويحط النقطة الزرقاء
  // move = true: نقرّب الكاميرا عليه. يرجّع true لو نجح
  Future<bool> _findMyLocation({bool move = true}) async {
    final found = await _tracking.findMyLocation();

    // لو الصفحة انقفلت وإحنا ننتظر، نوقف
    if (!mounted) return false;

    // ما قدرنا نجيب الموقع (رفض، أو GPS طافي)
    if (!found) {
      _showMessage(context.l10n.mapLocationError);
      return false;
    }

    if (move) _camera.animateTo(_tracking.myLocation!, 13);
    return true;
  }

  // لما نضغط "ابدأ المسار"
  Future<void> _startTrail() async {
    // لازم يكون للمسار خط نتبعه
    if (_routePoints.length < 2) {
      _showMessage(context.l10n.mapNoRoute);
      return;
    }

    // 1) نافذتنا: نشرح ليش نحتاج الموقع
    final allowed = await LocationPermissionSheet.show(context);

    // 2) لو ضغط "ليس الآن": نوقف وما نزعجه
    if (!allowed || !mounted) return;

    // 3) لو ضغط "السماح": نطلب الموقع الحقيقي (وهنا يتأكد الإذن)
    final found = await _findMyLocation(move: false);

    // 4) لو ما قدرنا نجيب الموقع، ما نبدأ المسار
    if (!found || !mounted) return;

    // 5) نبدأ التتبّع ونقرّب على المستخدم
    _tracking.start(_routePoints);
    _camera.animateTo(_tracking.myLocation!, 17);
  }

  // كل ما يتحرك المستخدم: الكاميرا تتبعه (ما نصغّر التكبير لو كان مقرّب)
  void _followUser(LatLng here) {
    if (_tracking.following && !_camera.isAnimating) {
      _mapController.move(here, math.max(_mapController.camera.zoom, 16));
    }
  }

  // ---------- أزرار الكرت ----------

  // يفتح Google Maps على الطريق لين بداية المسار
  Future<void> _openDirections(Trail trail) async {
    // نركّب الرابط: destination = خط العرض,خط الطول
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${trail.startLat},${trail.startLng}',
    );

    // نفتحه برّا التطبيق (تطبيق Google Maps أو المتصفح)
    final opened = await launchUrl(url, mode: LaunchMode.externalApplication);

    // لو ما انفتح، نطلع رسالة تحت
  if (!opened && mounted) _showMessage(context.l10n.mapDirectionsError);
  }

  // فتح صفحة التفاصيل
  void _openDetails(Trail trail) {
    if (widget.initialTrail != null) {
      Navigator.of(context).pop(); // نرجع للتفاصيل
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrailDetailsScreen(trail: trail),
        ),
      );
    }
  }

  // ---------- الرسم ----------

  @override
  Widget build(BuildContext context) {
    // نجيب المسارات من نفس ViewModel صفحة الاستكشاف
    final vm = context.watch<ExploreViewModel>();

    // مكان الأزرار العائمة: فوق الكرت لو ظاهر
    final floatingBottom = _selected == null ? 90.0 : 260.0;

    return Scaffold(
      // Stack: طبقات فوق بعض
      body: Stack(
        children: [
          // 1) الخريطة الحقيقية (OpenStreetMap)
          _buildMap(_visibleTrails(vm)),

          // 2) فوق: البحث، وتحته الشريط الأخضر لو على المسار
          _buildTopBar(),

          // 3) زر "موقعي" يسار — يطلع فوق لو الكرت ظاهر
          Positioned(
            left: 16,
            bottom: floatingBottom,
            child: MapSquareButton(
              icon: Icons.my_location,
              onTap: () => _findMyLocation(),
            ),
          ),
          // زر "تتبّعني": يطلع لو حرّك الخريطة وإحنا على المسار
          if (_tracking.onTrail && !_tracking.following)
            Positioned(
              right: 16,
              bottom: floatingBottom,
              child: FloatingActionButton.extended(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                onPressed: _recenter,
                icon: const Icon(Icons.navigation),
                label: Text(context.l10n.mapRecenter),
              ),
            ),

          // 4) تحت: التلميح لو ما اخترنا مسار، والكروت (تلف) لو اخترنا
          _buildBottom(_carouselTrails(vm)),
        ],
      ),
    );
  }

  // زر "تتبّعني": الكاميرا ترجع تتبع المستخدم
  void _recenter() {
    _tracking.setFollowing(true);
    final here = _tracking.myLocation;
    if (here != null) _camera.animateTo(here, 17);
  }

  Widget _buildMap(List<Trail> trails) {
    return FlutterMap(
      mapController: _mapController, // نربط "الريموت" بالخريطة
      options: MapOptions(
        initialCenter: _saudiCenter, // وسط المملكة تقريباً
        initialZoom: _saudiZoom, // نشوف المملكة كلها
        // لو حرّك الخريطة بيده: نوقف الحركة التلقائية،
        // ولو إحنا نتتبعه نوقف التتبّع ونطلع زر "تتبّعني"
        onPositionChanged: (camera, hasGesture) {
          if (!hasGesture) return;
          _camera.stop();
          if (_tracking.onTrail) _tracking.setFollowing(false);
        },
      ),
      children: [
        // صور الخريطة نفسها (الشوارع والأحياء)
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.qimmah.app',
        ),
        // خط المسار
        if (_routePoints.length > 1) PolylineLayer(polylines: _routeLines()),
        // العلامات: المسارات + موقعي
        MarkerLayer(markers: _markers(trails)),
        // ذكر مصدر الخريطة (شرط من OpenStreetMap)
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap contributors'),
        ),
      ],
    );
  }

  // خط المسار: الباقي أزرق، والمقطوع رمادي (وإحنا على المسار)
  List<Polyline> _routeLines() {
    Polyline line(List<LatLng> points, Color color) => Polyline(
          points: points,
          strokeWidth: 5,
          color: color,
          borderStrokeWidth: 2,
          borderColor: Colors.white,
        );

    final progress = _tracking.progress;
    if (progress == null) return [line(_routePoints, _routeColor)];

    return [
      line(_routePoints.sublist(0, progress.nearestIndex + 1), Colors.grey),
      line(_routePoints.sublist(progress.nearestIndex), _routeColor),
    ];
  }

  List<Marker> _markers(List<Trail> trails) {
    final myLocation = _tracking.myLocation;

    return [
      // نقطة النهاية: تطلع بس لما يكون فيه مسار مختار وخطه محمّل
      if (_selected != null && _routePoints.length > 1)
        Marker(
          point: _routePoints.last,
          width: 44,
          height: 44,
          alignment: Alignment.topCenter, // رأس الدبوس على النقطة
          child: const EndPin(),
        ),

      // علامات المسارات
      for (final trail in trails)
        Marker(
          point: LatLng(trail.startLat!, trail.startLng!),
          width: 44,
          height: 44,
          alignment: Alignment.topCenter, // رأس الدبوس على النقطة
          child: GestureDetector(
            // لما نضغط العلامة: نحفظ المسار المختار
            onTap: () => _selectTrail(trail),
            child: TrailPin(isSelected: _selected?.id == trail.id),
          ),
        ),

      // النقطة الزرقاء: تطلع بس لو عرفنا الموقع
      if (myLocation != null)
        Marker(
          point: myLocation,
          width: 22,
          height: 22,
          child: const MyLocationDot(),
        ),
    ];
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // بطول محتواه بس
          children: [
            Row(
              children: [
                // زر الرجوع يطلع بس لو جينا من صفحة التفاصيل
                if (widget.initialTrail != null) ...[
                  MapSquareButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(child: MapSearchBar(onChanged: _onSearch)),
              ],
            ),
            // الشريط: يطلع بس وإحنا على المسار
            if (_tracking.onTrail) ...[
              const SizedBox(height: 10),
              // العدّاد يتحدّث كل ثانية، فنعيد رسم الشريط بس (مو الشاشة كلها)
              ValueListenableBuilder<int>(
                valueListenable: _tracking.secondsAgo,
                builder: (context, seconds, _) => OnTrailBanner(
                  secondsAgo: seconds,
                  onEnd: _tracking.end,
                  remainingMeters: _tracking.progress?.remainingMeters,
                  fraction: _tracking.progress?.fraction,
                  offRoute: _tracking.progress?.isOffRoute ?? false,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottom(List<Trail> carouselTrails) {
    final selected = _selected;

    if (selected == null) {
      return const Positioned(
        left: 0,
        right: 0,
        bottom: 24,
        child: Center(child: MapHintChip()),
      );
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: MapTrailCarousel(
        key: _carouselKey,
        trails: carouselTrails,
        initialIndex: math.max(
          0,
          carouselTrails.indexWhere((t) => t.id == selected.id),
        ),
        // وإحنا على المسار: يختفي زر "ابدأ المسار"
        isOnTrail: _tracking.onTrail,
        // لما يلف المستخدم: نختار المسار ونجيب خطه ونحرّك الكاميرا
        onTrailChanged: _onCarouselChanged,
        // X: نسكّر الكرت ونرجّع العلامة خضراء
        onClose: () => setState(() {
          _selected = null;
          if (!_tracking.onTrail) _routePoints = [];
        }),
        // الأزرار تشتغل على المسار اللي في الكرت
        onDirections: _openDirections,
        onStart: (_) => _startTrail(),
        onDetails: _openDetails,
      ),
    );
  }
}