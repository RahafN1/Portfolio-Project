import 'package:latlong2/latlong.dart';

// وين المستخدم بالنسبة لخط المسار
class RouteProgress {
  final int nearestIndex; // أقرب نقطة على الخط
  final double distanceFromRoute; // كم متر بعيد عن الخط
  final double coveredMeters; // كم قطع من المسار
  final double totalMeters; // طول المسار كامل

  const RouteProgress({
    required this.nearestIndex,
    required this.distanceFromRoute,
    required this.coveredMeters,
    required this.totalMeters,
  });

  // أبعد من كذا = طلع عن المسار
  static const double offRouteMeters = 40;

  bool get isOffRoute => distanceFromRoute > offRouteMeters;
  double get remainingMeters =>
      (totalMeters - coveredMeters).clamp(0, totalMeters).toDouble();
  double get fraction =>
      totalMeters == 0 ? 0 : (coveredMeters / totalMeters).clamp(0, 1).toDouble();
}

// يحسب تقدّم المستخدم على المسار
class RouteTracker {
  final List<LatLng> points;
  static const Distance _distance = Distance();

  // المسافة التراكمية عند كل نقطة (من البداية)
  late final List<double> _cumulative;

  RouteTracker(this.points) {
    _cumulative = List<double>.filled(points.length, 0);
    for (var i = 1; i < points.length; i++) {
      _cumulative[i] =
          _cumulative[i - 1] + _distance.distance(points[i - 1], points[i]);
    }
  }

  double get totalMeters => _cumulative.isEmpty ? 0 : _cumulative.last;

  RouteProgress? locate(LatLng position, {RouteProgress? previous}) {
    if (points.length < 2) return null;

    // 1) نبحث قريب من آخر نقطة (يمنع القفز لو المسار يرجع لنفس المكان)
    if (previous != null) {
      final from = (previous.nearestIndex - 20).clamp(0, points.length - 1);
      final to = (previous.nearestIndex + 300).clamp(0, points.length - 1);
      final near = _nearest(position, from, to);
      if (near.$2 <= 60) return _build(near.$1, near.$2);
    }

    // 2) وإلا نبحث في المسار كامل
    final all = _nearest(position, 0, points.length - 1);
    return _build(all.$1, all.$2);
  }

  // (index, distance) لأقرب نقطة ضمن نطاق
  (int, double) _nearest(LatLng p, int from, int to) {
    var bestIndex = from;
    var bestDistance = double.infinity;
    for (var i = from; i <= to; i++) {
      final d = _distance.distance(p, points[i]);
      if (d < bestDistance) {
        bestDistance = d;
        bestIndex = i;
      }
    }
    return (bestIndex, bestDistance);
  }

  RouteProgress _build(int index, double distance) => RouteProgress(
        nearestIndex: index,
        distanceFromRoute: distance,
        coveredMeters: _cumulative[index],
        totalMeters: totalMeters,
      );
}