import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../models/trail.dart';
import '../utils/route_tracker.dart';
import '../viewmodels/explore_viewmodel.dart';
import 'trail_details_screen.dart';
import 'widgets/location_permission_sheet.dart';
import 'widgets/map_trail_card.dart';
import 'widgets/on_trail_banner.dart';

// صفحة الخريطة: علامات المسارات + البحث + موقعي + كروت المسار (تلف) + على المسار
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

class _TrailMapScreenState extends State<TrailMapScreen> {
  // وسط المملكة ومستوى التكبير اللي يبين المملكة كلها
  static const LatLng _saudiCenter = LatLng(24.5, 44.0);
  static const double _saudiZoom = 5.5;

  // كل كم ثانية نحدّث الموقع وإحنا على المسار
  static const int _updateEverySeconds = 10;

  // "ريموت" الخريطة: نحرّكها فيه من الكود
  final MapController _mapController = MapController();

  // مفتاح الـ carousel: نحرّكه من الكود لما نضغط علامة
  final GlobalKey<MapTrailCarouselState> _carouselKey =
      GlobalKey<MapTrailCarouselState>();

  // أثناء ما الـ carousel يتحرك بالكود، نتجاهل الصفحات اللي يمر عليها
  bool _carouselAnimating = false;

  // الخدمة اللي تجيب موقع المستخدم
  final LocationService _locationService = LocationService();

  // المسار اللي ضغطنا على علامته (null = ما اخترنا شي)
  Trail? _selected;

  // النص اللي في البحث ('' = ما كتبنا شي)
  String _query = '';

  // موقع المستخدم (null = للحين ما نعرفه)
  LatLng? _myLocation;

  // هل المستخدم بدأ المسار؟
  bool _onTrail = false;

  // الساعة اللي تنبض كل ثانية وإحنا على المسار
  Timer? _trackTimer;

  // كم ثانية مرّت من آخر تحديث للموقع
  int _secondsAgo = 0;

  // نقاط خط المسار المختار
  List<LatLng> _routePoints = [];

  // التتبّع الحي: الموقع المستمر + حساب التقدّم على الخط
  StreamSubscription<Position>? _positionSub;
  RouteTracker? _tracker;
  RouteProgress? _progress;

  // هل الكاميرا تتبع المستخدم؟ (تنطفي لو حرّك الخريطة بيده)
  bool _following = true;

  // عشان رسالة "وصلت" تطلع مرة وحدة
  bool _finishedShown = false;

  @override
  void initState() {
    super.initState();
    // الخريطة تحتاج كل العلامات، فنجيبها لوحدها (بدون صفحات)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreViewModel>().loadMapTrails();
      _openInitialTrail();
    });
  }

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
      _mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: trail.routePoints,
          padding: const EdgeInsets.fromLTRB(40, 120, 40, 280),
        ),
      );
    } else {
      await _selectTrail(trail); // نجيب الخط من الباك إند
    }

    if (widget.startTracking && mounted) await _startTrail();
  }

  // لما الصفحة تنقفل: نوقف الساعة عشان ما تضل شغّالة
  @override
  void dispose() {
    _trackTimer?.cancel();
    _positionSub?.cancel(); // يوقف القناة لما تنقفل الصفحة
    super.dispose();
  }

  // المسارات الظاهرة على الخريطة: عندها نقطة بداية، واسمها فيه نص البحث
  List<Trail> _visibleTrails(ExploreViewModel vm) {
    return vm.mapTrails
        .where((t) => t.startLat != null && t.startLng != null)
        .where((t) => t.name.contains(_query.trim()))
        .toList();
  }

  // المسارات اللي يلف بينها الكرت:
  // - وإحنا على المسار: كرت واحد بس (ما نخلي المستخدم يلف)
  // - لو المسار المختار مو في القائمة (مثلاً جينا من التفاصيل): نضيفه أول القائمة
  List<Trail> _carouselTrails(ExploreViewModel vm) {
    final selected = _selected;
    if (selected == null) return const [];
    if (_onTrail) return [selected];

    final list = _visibleTrails(vm);
    if (!list.any((t) => t.id == selected.id)) {
      return [selected, ...list];
    }
    return list;
  }

  // لما نضغط علامة (أو نلف الكرت): نعرض الكرت، ونجيب خط المسار ونرسمه
  Future<void> _selectTrail(Trail trail, {bool fromCarousel = false}) async {
    // لو على المسار، ما نغيّر المسار المختار
    if (_onTrail) return;

    final wasShowing = _selected != null;

    setState(() {
      _selected = trail;
      _routePoints = [];
    });

    // لو الكرت ظاهر والمستخدم ضغط علامة: نحرّك الـ carousel للكرت الجديد
    if (wasShowing && !fromCarousel) {
      final list = _carouselTrails(context.read<ExploreViewModel>());
      final index = list.indexWhere((t) => t.id == trail.id);
      if (index >= 0) {
        // نتجاهل الصفحات اللي يمر عليها أثناء الحركة
        _carouselAnimating = true;
        _carouselKey.currentState?.goTo(index);
        Future.delayed(const Duration(milliseconds: 400), () {
          _carouselAnimating = false;
        });
      }
    }

    try {
      final full =
          await context.read<ExploreViewModel>().loadTrailDetails(trail.id);

      // لو اختار مسار ثاني أو سكّر الكرت وإحنا ننتظر، نتجاهل
      if (!mounted || _selected?.id != trail.id) return;

      setState(() => _routePoints = full.routePoints);

      // نقرّب الخريطة على المسار كامل
      if (full.routePoints.length > 1) {
        _mapController.fitCamera(
          CameraFit.coordinates(
            coordinates: full.routePoints,
            padding: const EdgeInsets.fromLTRB(40, 120, 40, 280),
          ),
        );
      }
    } catch (_) {
      // لو فشل الجلب، يبقى الكرت والعلامة بدون خط
    }
  }

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
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.mapDirectionsError)),
      );
    }
  }

  // كل ما تتغيّر الكتابة في البحث
  void _onSearch(String value, List<Trail> allTrails) {
    // نحفظ النص ونسكّر الكرت
    setState(() {
      _query = value;
      _selected = null;
    });

    // لو البحث فاضي: نرجع للمملكة كلها
    if (value.trim().isEmpty) {
      _mapController.move(_saudiCenter, _saudiZoom);
      return;
    }

    // المسارات اللي اسمها فيه النص وعندها إحداثيات
    final matches = allTrails
        .where((t) => t.startLat != null && t.startLng != null)
        .where((t) => t.name.contains(value.trim()))
        .toList();

    // لو مسار واحد بس: نقرّب عليه
    if (matches.length == 1) {
      final trail = matches.first;
      _mapController.move(LatLng(trail.startLat!, trail.startLng!), 11);
    }
  }

  // يجيب موقع المستخدم ويحط النقطة الزرقاء
  // silent = true: تحديث هادي (بدون رسالة خطأ، وبدون ما نحرّك الخريطة)
  // يرجّع true لو نجح، و false لو ما قدرنا
  Future<bool> _findMyLocation({bool silent = false, bool move = true}) async {
    final position = await _locationService.getCurrentLocation();

    // لو الصفحة انقفلت وإحنا ننتظر، نوقف
    if (!mounted) return false;

    // ما قدرنا نجيب الموقع (رفض، أو GPS طافي)
    if (position == null) {
      if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.locationError)),
        );
      }
      return false;
    }

    // نحفظ الموقع، ولو مو تحديث هادي نقرّب عليه
    final here = LatLng(position.latitude, position.longitude);
    setState(() => _myLocation = here);
    if (!silent && move) _mapController.move(here, 13);
    return true;
  }

  // لما نضغط "ابدأ المسار"
  Future<void> _startTrail() async {
    // لازم يكون للمسار خط نتبعه
    if (_routePoints.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.mapNoRoute)),
      );
      return;
    }

    // 1) نافذتنا: نشرح ليش نحتاج الموقع
    final allowed = await LocationPermissionSheet.show(context);

    // 2) لو ضغط "ليس الآن": نوقف وما نزعجه
    if (!allowed) return;

    // 3) لو ضغط "السماح": نطلب الموقع الحقيقي (وهنا يتأكد الإذن)
    final found = await _findMyLocation(move: false);

    // 4) لو ما قدرنا نجيب الموقع، ما نبدأ المسار
    if (!found || !mounted) return;

    // 5) نجهّز الحساب ونبدأ
    _tracker = RouteTracker(_routePoints);
    _progress = _tracker!.locate(_myLocation!);
    _finishedShown = false;
    setState(() {
      _onTrail = true;
      _following = true;
      _secondsAgo = 0;
    });
    _mapController.move(_myLocation!, 17);

    // 6) الموقع المستمر: كل ما يتحرك المستخدم نحدّث
    _positionSub?.cancel();
    _positionSub = _locationService.positionStream().listen(
      _onPosition,
      onError: (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.locationError)),
        );
      },
    );

    // 7) الساعة: بس تعدّ "آخر تحديث قبل كم ثانية"
    _trackTimer?.cancel();
    _trackTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _secondsAgo++),
    );
  }

  // كل ما توصل نقطة موقع جديدة
  void _onPosition(Position pos) {
    if (!mounted) return;
    final here = LatLng(pos.latitude, pos.longitude);
    final progress = _tracker?.locate(here, previous: _progress);

    setState(() {
      _myLocation = here;
      _progress = progress;
      _secondsAgo = 0;
    });

    // الكاميرا تتبعه (ما نصغّر التكبير لو كان مقرّب)
    if (_following) {
      _mapController.move(
        here,
        math.max(_mapController.camera.zoom, 16),
      );
    }

    // وصل النهاية (أكثر من 97% وباقي أقل من 30 متر)
    if (progress != null &&
        !_finishedShown &&
        progress.fraction >= 0.97 &&
        progress.remainingMeters < 30) {
      _finishedShown = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.onTrailFinished)),
      );
    }
  }

  // لما نضغط "إنهاء"
  void _endTrail() {
    _trackTimer?.cancel();
    _positionSub?.cancel();
    _positionSub = null;
    setState(() {
      _onTrail = false;
      _tracker = null;
      _progress = null;
    });
  }

  // فتح صفحة التفاصيل (نفس الكود القديم)
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

  @override
  Widget build(BuildContext context) {
    // نجيب المسارات من نفس ViewModel صفحة الاستكشاف
    final vm = context.watch<ExploreViewModel>();

    // نخلي بس المسارات اللي عندها نقطة بداية، واسمها فيه نص البحث
    final trails = _visibleTrails(vm);

    // قائمة الكروت اللي يلف بينها المستخدم
    final carouselTrails = _carouselTrails(vm);

    // مكان الأزرار العائمة: فوق الكرت لو ظاهر
    final floatingBottom = _selected == null ? 90.0 : 260.0;

    return Scaffold(
      // Stack: طبقات فوق بعض
      body: Stack(
        children: [
          // 1) الخريطة الحقيقية (OpenStreetMap)
          FlutterMap(
            mapController: _mapController, // نربط "الريموت" بالخريطة
            options: MapOptions(
              initialCenter: _saudiCenter, // وسط المملكة تقريباً
              initialZoom: _saudiZoom, // نشوف المملكة كلها
              // لو حرّك الخريطة بيده وإحنا نتتبعه: نوقف التتبّع ونطلع زر "تتبّعني"
              onPositionChanged: (camera, hasGesture) {
                if (hasGesture && _onTrail && _following) {
                  setState(() => _following = false);
                }
              },
            ),
            children: [
              // صور الخريطة نفسها (الشوارع والأحياء)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.qimmah.app',
              ),
              // خط المسار: الباقي أزرق، والمقطوع رمادي (وإحنا على المسار)
              if (_routePoints.length > 1)
                PolylineLayer(
                  polylines: [
                    if (_progress != null) ...[
                      Polyline(
                        points: _routePoints.sublist(
                            0, _progress!.nearestIndex + 1),
                        strokeWidth: 5,
                        color: Colors.grey,
                        borderStrokeWidth: 2,
                        borderColor: Colors.white,
                      ),
                      Polyline(
                        points: _routePoints.sublist(_progress!.nearestIndex),
                        strokeWidth: 5,
                        color: const Color(0xFF1E5BFF),
                        borderStrokeWidth: 2,
                        borderColor: Colors.white,
                      ),
                    ] else
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 5,
                        color: const Color(0xFF1E5BFF),
                        borderStrokeWidth: 2,
                        borderColor: Colors.white,
                      ),
                  ],
                ),
              // العلامات: المسارات + موقعي
              MarkerLayer(
                markers: [
                  // نقطة النهاية: تطلع بس لما يكون فيه مسار مختار وخطه محمّل
                  if (_selected != null && _routePoints.length > 1)
                    Marker(
                      point: _routePoints.last,
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter, // رأس الدبوس على النقطة
                      child: const _EndPin(),
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
                        child: _TrailPin(
                          isSelected: _selected?.id == trail.id,
                        ),
                      ),
                    ),

                  // النقطة الزرقاء: تطلع بس لو عرفنا الموقع
                  if (_myLocation != null)
                    Marker(
                      point: _myLocation!,
                      width: 22,
                      height: 22,
                      child: const _MyLocationDot(),
                    ),
                ],
              ),

              // ذكر مصدر الخريطة (شرط من OpenStreetMap)
              const SimpleAttributionWidget(
                source: Text('OpenStreetMap contributors'),
              ),
            ],
          ),

          // 2) فوق: البحث، وتحته الشريط الأخضر لو على المسار
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min, // بطول محتواه بس
                children: [
                  Row(
                    children: [
                      // زر الرجوع يطلع بس لو جينا من صفحة التفاصيل
                      if (widget.initialTrail != null) ...[
                        _BackButton(onTap: () => Navigator.of(context).pop()),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: _SearchBar(
                          onChanged: (value) => _onSearch(value, vm.mapTrails),
                        ),
                      ),
                    ],
                  ),
                  // الشريط: يطلع بس وإحنا على المسار
                  if (_onTrail) ...[
                    const SizedBox(height: 10),
                    OnTrailBanner(
                      secondsAgo: _secondsAgo,
                      onEnd: _endTrail,
                      remainingMeters: _progress?.remainingMeters,
                      fraction: _progress?.fraction,
                      offRoute: _progress?.isOffRoute ?? false,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 3) زر "موقعي" يسار — يطلع فوق لو الكرت ظاهر
          Positioned(
            left: 16,
            bottom: floatingBottom,
            child: _LocateButton(onTap: () => _findMyLocation()),
          ),
          // زر "تتبّعني": يطلع لو حرّك الخريطة وإحنا على المسار
          if (_onTrail && !_following)
            Positioned(
              right: 16,
              bottom: floatingBottom,
              child: FloatingActionButton.extended(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                onPressed: () {
                  setState(() => _following = true);
                  if (_myLocation != null) {
                    _mapController.move(_myLocation!, 17);
                  }
                },
                icon: const Icon(Icons.navigation),
                label: const Text(AppStrings.mapRecenter),
              ),
            ),

          // 4) تحت: التلميح لو ما اخترنا مسار، والكروت (تلف) لو اخترنا
          if (_selected == null)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Center(child: _HintChip()),
            )
          else
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MapTrailCarousel(
                key: _carouselKey,
                trails: carouselTrails,
                initialIndex: math.max(
                  0,
                  carouselTrails.indexWhere((t) => t.id == _selected!.id),
                ),
                // وإحنا على المسار: يختفي زر "ابدأ المسار"
                isOnTrail: _onTrail,
                // لما يلف المستخدم: نختار المسار ونجيب خطه ونحرّك الكاميرا
                onTrailChanged: (t) {
                  if (_carouselAnimating) return;
                  if (_selected?.id != t.id) {
                    _selectTrail(t, fromCarousel: true);
                  }
                },
                // X: نسكّر الكرت ونرجّع العلامة خضراء
                onClose: () => setState(() {
                  _selected = null;
                  if (!_onTrail) _routePoints = [];
                }),
                // الأزرار تشتغل على المسار اللي في الكرت
                onDirections: (t) => _openDirections(t),
                onStart: (_) => _startTrail(),
                onDetails: (t) => _openDetails(t),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------- القطع الصغيرة ----------------

// علامة المسار: أخضر عادي، وبرتقالي لو مختارة
class _TrailPin extends StatelessWidget {
  final bool isSelected;

  const _TrailPin({required this.isSelected});

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
class _EndPin extends StatelessWidget {
  const _EndPin();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // ظل خفيف عشان الدبوس الأبيض يبان على الخريطة
        const Icon(Icons.location_on, size: 44, color: Colors.black38),
        // الدبوس الأبيض
        const Icon(Icons.location_on, size: 42, color: Colors.white),
        // علم أخضر داخل الدبوس
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Icon(Icons.flag, size: 16, color: AppColors.primary),
        ),
      ],
    );
  }
}

// النقطة الزرقاء: موقع المستخدم
class _MyLocationDot extends StatelessWidget {
  const _MyLocationDot();

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

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged; // يُنادى كل ما تتغيّر الكتابة

  const _SearchBar({required this.onChanged});

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
        decoration: const InputDecoration(
          hintText: AppStrings.mapSearchHint,
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
        ),
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

// زر الرجوع المربع الأبيض
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.arrow_back, color: AppColors.primary),
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