import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/services/location_service.dart';
import '../utils/route_tracker.dart';

// تتبّع المستخدم وهو على المسار: موقعه، تقدّمه على الخط، وكم مرّ من آخر تحديث
// ما يعرف شي عن الخريطة ولا الشاشة؛ الشاشة تسمعه وتتصرف
class TrailTrackingViewModel extends ChangeNotifier {
  final LocationService _locationService;

  TrailTrackingViewModel(this._locationService);

  // موقع المستخدم (null = للحين ما نعرفه)
  LatLng? myLocation;

  // هل المستخدم بدأ المسار؟
  bool onTrail = false;

  // هل الكاميرا تتبع المستخدم؟ (تنطفي لو حرّك الخريطة بيده)
  bool following = true;

  // وين المستخدم بالنسبة للخط (null = ما حسبناه)
  RouteProgress? progress;

  // كم ثانية مرّت من آخر تحديث للموقع.
  // ValueNotifier لحاله عشان الشريط بس يتحدّث كل ثانية، مو الشاشة كلها
  final ValueNotifier<int> secondsAgo = ValueNotifier<int>(0);

  // الشاشة تحدد وش يصير لما توصل هذي الأحداث
  void Function(LatLng here)? onPosition; // وصل موقع جديد (الكاميرا تتبعه)
  VoidCallback? onFinished; // وصل نهاية المسار
  VoidCallback? onLocationError; // انقطعت قناة الموقع

  RouteTracker? _tracker;
  StreamSubscription<Position>? _positionSub;
  Timer? _timer;
  bool _finishedShown = false; // عشان رسالة "وصلت" تطلع مرة وحدة
  bool _disposed = false;

  // يجيب موقع المستخدم الحالي ويحفظه. يرجّع false لو ما قدرنا (رفض أو GPS طافي)
  Future<bool> findMyLocation() async {
    final position = await _locationService.getCurrentLocation();
    if (_disposed || position == null) return false;

    myLocation = LatLng(position.latitude, position.longitude);
    _notify();
    return true;
  }

  // يبدأ التتبّع على خط المسار (لازم نكون جبنا الموقع قبل)
  void start(List<LatLng> route) {
    final here = myLocation;
    if (here == null) return;

    _tracker = RouteTracker(route);
    progress = _tracker!.locate(here);
    _finishedShown = false;
    onTrail = true;
    following = true;
    secondsAgo.value = 0;

    // الموقع المستمر: كل ما يتحرك المستخدم نحدّث
    _positionSub?.cancel();
    _positionSub = _locationService.positionStream().listen(
          _handlePosition,
          onError: (_) => onLocationError?.call(),
        );

    // الساعة: بس تعدّ "آخر تحديث قبل كم ثانية"
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => secondsAgo.value++,
    );

    _notify();
  }

  // ينهي التتبّع (النقطة الزرقاء تبقى مكانها)
  void end() {
    _timer?.cancel();
    _positionSub?.cancel();
    _positionSub = null;
    _tracker = null;
    progress = null;
    onTrail = false;
    _notify();
  }

  void setFollowing(bool value) {
    if (following == value) return;
    following = value;
    _notify();
  }

  // كل ما توصل نقطة موقع جديدة
  void _handlePosition(Position pos) {
    if (_disposed) return;
    final here = LatLng(pos.latitude, pos.longitude);
    final newProgress = _tracker?.locate(here, previous: progress);

    myLocation = here;
    progress = newProgress;
    secondsAgo.value = 0;
    _notify();

    onPosition?.call(here);

    // وصل النهاية (أكثر من 97% وباقي أقل من 30 متر)
    if (newProgress != null &&
        !_finishedShown &&
        newProgress.fraction >= 0.97 &&
        newProgress.remainingMeters < 30) {
      _finishedShown = true;
      onFinished?.call();
    }
  }

  // ما نبلّغ أحد بعد ما تنقفل الشاشة
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _positionSub?.cancel(); // يوقف القناة لما تنقفل الصفحة
    secondsAgo.dispose();
    super.dispose();
  }
}