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
  });

  factory Trail.fromJson(Map<String, dynamic> json) {
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
      coverImage: json['cover_image'],
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
}
