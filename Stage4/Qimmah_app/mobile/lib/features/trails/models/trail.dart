class Trail {
  final int id;
  final String name;
  final String region;
  final String difficulty; // easy أو moderate أو hard
  final double distance;
  final String? coverImage;

  Trail({
    required this.id,
    required this.name,
    required this.region,
    required this.difficulty,
    required this.distance,
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
}
