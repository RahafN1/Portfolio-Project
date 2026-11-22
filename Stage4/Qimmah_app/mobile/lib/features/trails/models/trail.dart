import 'dart:convert';

import 'package:latlong2/latlong.dart';
import '../../../l10n/l10n.dart'; // جديد: عشان نعرف اللغة الحالية

class Trail {
  final int id;
  final String difficulty; // easy أو moderate أو hard
  final double distance;
  final double? averageRating; // null لين تنضاف التقييمات
  final bool isCertified; // مسار معتمد
  final String? coverImage;

  // النصوص بلغتين (الباك إند يرجّعهم مع بعض)
  final String nameAr, nameEn;
  final String regionAr, regionEn;
  final String durationAr, durationEn; // مثل: "3 ساعات"
  final String descriptionAr, descriptionEn;
  final List<String> tipsAr, tipsEn;

  // تفاصيل المسار (تجي كاملة من صفحة التفاصيل بس)
  final List<String> images;
  final double? startLat;
  final double? startLng;
  final List<LatLng> routePoints; // نقاط خط المسار (من GeoJSON)

  Trail({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.regionAr,
    required this.regionEn,
    required this.difficulty,
    required this.distance,
    this.durationAr = '',
    this.durationEn = '',
    this.averageRating,
    this.isCertified = false,
    this.coverImage,
    this.descriptionAr = '',
    this.descriptionEn = '',
    this.images = const [],
    this.startLat,
    this.startLng,
    this.tipsAr = const [],
    this.tipsEn = const [],
    this.routePoints = const [],
  });

  // ---------- تختار حسب اللغة الحالية (الشاشات تستخدم هذي) ----------
  String get name => L10n.isEnglish ? nameEn : nameAr;
  String get region => L10n.isEnglish ? regionEn : regionAr;
  String get estimatedDuration => L10n.isEnglish ? durationEn : durationAr;
  String get description => L10n.isEnglish ? descriptionEn : descriptionAr;
  List<String> get safetyTips => L10n.isEnglish ? tipsEn : tipsAr;

  factory Trail.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List?)?.map((e) => e.toString()).toList() ??
        const <String>[];
    final start = json['start_point'];

    return Trail(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? json['name'] ?? '',
      nameEn: json['name_en'] ?? json['name'] ?? '',
      regionAr: json['region_ar'] ?? json['region'] ?? '',
      regionEn: json['region_en'] ?? json['region'] ?? '',
      difficulty: json['difficulty'] ?? '',
      // double.tryParse لأن DECIMAL ممكن يوصل كنص
      distance: double.tryParse(json['distance'].toString()) ?? 0,
      durationAr:
          json['estimated_duration_ar'] ?? json['estimated_duration'] ?? '',
      durationEn:
          json['estimated_duration_en'] ?? json['estimated_duration'] ?? '',
      averageRating: double.tryParse(json['average_rating'].toString()),
      isCertified: json['is_certified'] == true,
      coverImage:
          json['cover_image'] ?? (images.isNotEmpty ? images.first : null),
      descriptionAr: json['description_ar'] ?? json['description'] ?? '',
      descriptionEn: json['description_en'] ?? json['description'] ?? '',
      images: images,
      startLat: start is Map ? (start['lat'] as num?)?.toDouble() : null,
      startLng: start is Map ? (start['lng'] as num?)?.toDouble() : null,
      tipsAr: _parseTips(json['safety_tips_ar'] ?? json['safety_tips']),
      tipsEn: _parseTips(json['safety_tips_en'] ?? json['safety_tips']),
      routePoints: _parseRoute(json['route_coordinates']),
    );
  }

  // route_coordinates = GeoJSON FeatureCollection فيه LineString
  // الإحداثيات بالترتيب [lng, lat]، نقلبها لـ LatLng(lat, lng)
  static List<LatLng> _parseRoute(dynamic raw) {
    try {
      final data = raw is String ? jsonDecode(raw) : raw;
      if (data is! Map) return const [];
      for (final feature in (data['features'] as List? ?? const [])) {
        final geometry = feature is Map ? feature['geometry'] : null;
        if (geometry is Map && geometry['type'] == 'LineString') {
          return (geometry['coordinates'] as List)
              .map((c) => LatLng(
                    (c[1] as num).toDouble(),
                    (c[0] as num).toDouble(),
                  ))
              .toList();
        }
      }
    } catch (_) {}
    return const [];
  }

  // النصائح تجي نص واحد كل سطر يبدأ بـ "•"، نقسمه لقائمة
  static List<String> _parseTips(dynamic raw) {
    if (raw == null) return const [];
    return raw
        .toString()
        .split('\n')
        .map((line) => line.replaceFirst(RegExp(r'^[\s•\-\*]+'), '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  // نسخة معدّلة (نحتاجها عشان نحافظ على شارة "معتمد" من القائمة)
  Trail copyWith({bool? isCertified}) {
    return Trail(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      regionAr: regionAr,
      regionEn: regionEn,
      difficulty: difficulty,
      distance: distance,
      durationAr: durationAr,
      durationEn: durationEn,
      averageRating: averageRating,
      isCertified: isCertified ?? this.isCertified,
      coverImage: coverImage,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      images: images,
      startLat: startLat,
      startLng: startLng,
      tipsAr: tipsAr,
      tipsEn: tipsEn,
      routePoints: routePoints,
    );
  }

  // المسافة بدون ".0" لو رقم صحيح (9.0 تصير 9)
  String get distanceText =>
      distance % 1 == 0 ? distance.toStringAsFixed(0) : distance.toString();

  bool get hasStartPoint => startLat != null && startLng != null;

  // رابط الاتجاهات في خرائط قوقل
  String? get directionsUrl => hasStartPoint
      ? 'https://www.google.com/maps/dir/?api=1&destination=$startLat,$startLng'
      : null;

  // رابط عرض الموقع (للمشاركة)
  String? get locationUrl => hasStartPoint
      ? 'https://www.google.com/maps/search/?api=1&query=$startLat,$startLng'
      : null;
}