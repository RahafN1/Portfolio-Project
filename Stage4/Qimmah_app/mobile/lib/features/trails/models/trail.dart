class Trail {
  final int id;
  final String name;
  final String region;
  final String difficulty; // easy أو moderate أو hard
  final double distance;
  final String estimatedDuration; // مثل: "3 ساعات"
  final double? averageRating; // null لين تنضاف التقييمات
  final bool isCertified; // مسار معتمد
  final String? coverImage;

  // تفاصيل المسار (تجي كاملة من صفحة التفاصيل بس)
  final String description;
  final List<String> images;
  final double? startLat;
  final double? startLng;
  final List<String> safetyTips;

  Trail({
    required this.id,
    required this.name,
    required this.region,
    required this.difficulty,
    required this.distance,
    this.estimatedDuration = '',
    this.averageRating,
    this.isCertified = false,
    this.coverImage,
    this.description = '',
    this.images = const [],
    this.startLat,
    this.startLng,
    this.safetyTips = const [],
  });

  factory Trail.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List?)?.map((e) => e.toString()).toList() ??
        const <String>[];
    final start = json['start_point'];

    return Trail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      difficulty: json['difficulty'] ?? '',
      // double.tryParse لأن DECIMAL ممكن يوصل كنص
      distance: double.tryParse(json['distance'].toString()) ?? 0,
      estimatedDuration: json['estimated_duration'] ?? '',
      averageRating: double.tryParse(json['average_rating'].toString()),
      isCertified: json['is_certified'] == true,
      coverImage:
          json['cover_image'] ?? (images.isNotEmpty ? images.first : null),
      description: json['description'] ?? '',
      images: images,
      startLat: start is Map ? (start['lat'] as num?)?.toDouble() : null,
      startLng: start is Map ? (start['lng'] as num?)?.toDouble() : null,
      safetyTips: _parseTips(json['safety_tips']),
    );
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
      name: name,
      region: region,
      difficulty: difficulty,
      distance: distance,
      estimatedDuration: estimatedDuration,
      averageRating: averageRating,
      isCertified: isCertified ?? this.isCertified,
      coverImage: coverImage,
      description: description,
      images: images,
      startLat: startLat,
      startLng: startLng,
      safetyTips: safetyTips,
    );
  }

  // نعرض الصعوبة بالعربي
  String get difficultyArabic {
    if (difficulty == 'easy') return 'سهل';
    if (difficulty == 'moderate') return 'متوسط';
    if (difficulty == 'hard') return 'صعب';
    return difficulty;
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