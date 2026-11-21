import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// يحرّك كاميرا الخريطة بسلاسة: بدل ما الخريطة تقفز، نحرّكها خطوة خطوة
// (المكان + التكبير) بمنحنى ناعم
class MapCameraAnimator {
  // الهوامش حول المسار عشان ما يختفي تحت البحث أو الكرت
  static const EdgeInsets fitPadding = EdgeInsets.fromLTRB(40, 120, 40, 280);

  final MapController mapController;
  final AnimationController _anim;

  // بداية الحركة ونهايتها
  double _fromLat = 0, _fromLng = 0, _fromZoom = 0;
  double _toLat = 0, _toLng = 0, _toZoom = 0;

  MapCameraAnimator({
    required TickerProvider vsync,
    required this.mapController,
  }) : _anim = AnimationController(vsync: vsync) {
    _anim.addListener(_onTick);
  }

  // هل فيه حركة شغّالة الحين؟
  bool get isAnimating => _anim.isAnimating;

  // اللمس يوقف الحركة التلقائية
  void stop() => _anim.stop();

  // كل إطار من الحركة: نحسب المكان بين البداية والنهاية ونحرّك الخريطة
  void _onTick() {
    final t = Curves.easeInOutCubic.transform(_anim.value);
    mapController.move(
      LatLng(
        _fromLat + (_toLat - _fromLat) * t,
        _fromLng + (_toLng - _fromLng) * t,
      ),
      _fromZoom + (_toZoom - _fromZoom) * t,
    );
  }

  // تحرّك الكاميرا بسلاسة لمكان وتكبير معيّن
  void animateTo(LatLng center, double zoom, {int ms = 700}) {
    final cam = mapController.camera;
    _fromLat = cam.center.latitude;
    _fromLng = cam.center.longitude;
    _fromZoom = cam.zoom;
    _toLat = center.latitude;
    _toLng = center.longitude;
    _toZoom = zoom;
    _anim.duration = Duration(milliseconds: ms);
    _anim.forward(from: 0); // لو فيه حركة شغّالة، تنبدّل بالجديدة
  }

  // تحرّك الكاميرا بسلاسة لين يبان المسار كامل
  void animateToFit(List<LatLng> points) {
    final fitted = CameraFit.coordinates(
      coordinates: points,
      padding: fitPadding,
    ).fit(mapController.camera);
    animateTo(fitted.center, fitted.zoom, ms: 800);
  }

  // يقرّب على المسار كامل فوراً (بدون حركة)
  void fitNow(List<LatLng> points) {
    mapController.fitCamera(
      CameraFit.coordinates(coordinates: points, padding: fitPadding),
    );
  }

  void dispose() => _anim.dispose();
}