import 'dart:async'; // عشان Timer

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../models/trail.dart';
import '../viewmodels/explore_viewmodel.dart';
import 'trail_details_screen.dart';
import 'widgets/location_permission_sheet.dart';
import 'widgets/map_trail_card.dart';
import 'widgets/on_trail_banner.dart';

// صفحة الخريطة: علامات المسارات + الطريق + البحث + موقعي + كرت المسار + على المسار
class TrailMapScreen extends StatefulWidget {
  const TrailMapScreen({super.key});

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

  // الخدمة اللي تجيب موقع المستخدم
  final LocationService _locationService = LocationService();

  // المسار اللي ضغطنا على علامته (null = ما اخترنا شي)
  Trail? _selected;

  // نقاط طريق المسار المختار ([] = ما فيه طريق نرسمه)
  List<LatLng> _route = [];

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

  // لما الصفحة تنقفل: نوقف الساعة عشان ما تضل شغّالة
  @override
  void dispose() {
    _trackTimer?.cancel();
    super.dispose();
  }

  // لما نضغط علامة: نختار المسار، ونجيب طريقه، ونرسمه
  Future<void> _selectTrail(Trail trail) async {
    // نختاره على طول، ونمسح أي طريق قديم
    setState(() {
      _selected = trail;
      _route = [];
    });

    try {
      // نطلب الطريق من السيرفر (عن طريق نفس Repository حق الاستكشاف)
      final points = await context
          .read<ExploreViewModel>()
          .repository
          .getTrailRoute(trail.id);

      // لو الصفحة انقفلت، أو المستخدم اختار مسار ثاني وإحنا ننتظر، نوقف
      if (!mounted || _selected?.id != trail.id) return;

      setState(() => _route = points);

      // نقرّب الخريطة لين الطريق كامل يبان
      // (padding: مسافة من الأطراف، وتحت أكبر عشان الكرت ما يغطي الطريق)
      if (points.isNotEmpty) {
        _mapController.fitCamera(
          CameraFit.coordinates(
            coordinates: points,
            padding: const EdgeInsets.fromLTRB(40, 140, 40, 280),
          ),
        );
      }
    } catch (e) {
      // لو ما قدرنا نجيب الطريق: نخلي العلامة والكرت بدون خط
    }
  }

  // لما نسكّر الكرت: نلغي الاختيار ونمسح الخط
  void _closeCard() {
    setState(() {
      _selected = null;
      _route = [];
    });
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
    // نحفظ النص، ونسكّر الكرت، ونمسح الخط
    setState(() {
      _query = value;
      _selected = null;
      _route = [];
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
  Future<bool> _findMyLocation({bool silent = false}) async {
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
    if (!silent) _mapController.move(here, 13);
    return true;
  }

  // لما نضغط "ابدأ المسار"
  Future<void> _startTrail() async {
    // 1) نافذتنا: نشرح ليش نحتاج الموقع
    final allowed = await LocationPermissionSheet.show(context);

    // 2) لو ضغط "ليس الآن": نوقف وما نزعجه
    if (!allowed) return;

    // 3) لو ضغط "السماح": نطلب الموقع الحقيقي
    final found = await _findMyLocation();

    // 4) لو ما قدرنا نجيب الموقع، ما نبدأ المسار
    if (!found || !mounted) return;

    // 5) نبدأ: يطلع الشريط، والعدّاد من صفر
    setState(() {
      _onTrail = true;
      _secondsAgo = 0;
    });

    // 6) نشغّل الساعة: تنبض كل ثانية
    _trackTimer?.cancel(); // لو فيه ساعة قديمة نوقفها أول
    _trackTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  // كل ثانية: نزيد العدّاد، ولما يوصل 10 نحدّث الموقع
  void _tick() {
    setState(() => _secondsAgo++);

    if (_secondsAgo >= _updateEverySeconds) {
      _secondsAgo = 0; // نرجّع العدّاد صفر
      _findMyLocation(silent: true); // تحديث هادي للنقطة الزرقاء
    }
  }

  // لما نضغط "إنهاء"
  void _endTrail() {
    _trackTimer?.cancel(); // نوقف الساعة
    setState(() => _onTrail = false); // نخفي الشريط
  }

  @override
  Widget build(BuildContext context) {
    // نجيب المسارات من نفس ViewModel صفحة الاستكشاف
    final vm = context.watch<ExploreViewModel>();

    // نخلي بس المسارات اللي عندها نقطة بداية، واسمها فيه نص البحث
    final trails = vm.filtered
        .where((t) => t.startLat != null && t.startLng != null)
        .where((t) => t.name.contains(_query.trim()))
        .toList();

    return Scaffold(
      // Stack: طبقات فوق بعض
      body: Stack(
        children: [
          // 1) الخريطة الحقيقية (OpenStreetMap)
          FlutterMap(
            mapController: _mapController, // نربط "الريموت" بالخريطة
            options: const MapOptions(
              initialCenter: _saudiCenter, // وسط المملكة تقريباً
              initialZoom: _saudiZoom, // نشوف المملكة كلها
            ),
            children: [
              // صور الخريطة نفسها (الشوارع والأحياء)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.qimmah.app',
              ),

              // طريق المسار المختار: خط برتقالي متقطع
              // (قبل العلامات، عشان العلامات تطلع فوقه)
              if (_route.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _route,
                      color: AppColors.accent, // برتقالي
                      strokeWidth: 4, // سماكة الخط
                      pattern: StrokePattern.dashed(segments: const [10, 6]),
                    ),
                  ],
                ),

              // العلامات: المسارات + موقعي
              MarkerLayer(
                markers: [
                  // علامات المسارات
                  for (final trail in trails)
                    Marker(
                      point: LatLng(trail.startLat!, trail.startLng!),
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter, // رأس الدبوس على النقطة
                      child: GestureDetector(
                        // لما نضغط العلامة: نختاره ونجيب طريقه
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
                  _SearchBar(
                    onChanged: (value) => _onSearch(value, vm.filtered),
                  ),
                  // الشريط: يطلع بس وإحنا على المسار
                  if (_onTrail) ...[
                     const SizedBox(height: 10),
                     ConstrainedBox(
                       constraints: const BoxConstraints(maxHeight: 64),
                       child: OnTrailBanner(
                          secondsAgo: _secondsAgo,
                          onEnd: _endTrail,
                       ),
                   ),
    ],
              ),
            ),
          ),

          // 3) زر "موقعي" يسار — يطلع فوق لو الكرت ظاهر
          Positioned(
            left: 16,
            bottom: _selected == null ? 90 : 230,
            child: _LocateButton(onTap: () => _findMyLocation()),
          ),

          // 4) تحت: التلميح لو ما اخترنا مسار، والكرت لو اخترنا
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
              child: MapTrailCard(
                trail: _selected!,
                // وإحنا على المسار: يختفي زر "ابدأ المسار"
                isOnTrail: _onTrail,
                // X: نسكّر الكرت ونمسح الخط
                onClose: _closeCard,
                // الاتجاهات: يفتح Google Maps
                onDirections: () => _openDirections(_selected!),
                // ابدأ المسار: نافذة الإذن ثم الموقع الحقيقي ثم الشريط
                onStart: () => _startTrail(),
                // عرض التفاصيل: يفتح صفحة التفاصيل بنفس طريقة الاستكشاف
                onDetails: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrailDetailsScreen(trail: _selected!),
                  ),
                ),
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

// شريط البحث الأبيض + زر EN
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
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // حقل البحث (بالعربي يجي يمين)
          Expanded(
            child: TextField(
              onChanged: onChanged, // نرسل النص للصفحة
              decoration: const InputDecoration(
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