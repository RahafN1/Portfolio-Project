// تقييم كما يشوفه الأدمن (مع اسم صاحبه واسم المسار)
class AdminReview {
  final int id;
  final int trailId;
  final String userName;
  final String trailName;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  AdminReview({
    required this.id,
    required this.trailId,
    required this.userName,
    required this.trailName,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory AdminReview.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final trail = json['trail'];
    return AdminReview(
      id: json['id'] ?? 0,
      trailId: trail is Map ? (trail['id'] ?? 0) : 0,
      userName: user is Map ? (user['name'] ?? '') : '',
      trailName: trail is Map ? (trail['name'] ?? '') : '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '')?.toLocal(),
    );
  }

  // "قبل 3 أيام" بشكل بسيط
  String get timeAgo {
    final d = createdAt;
    if (d == null) return '';
    final diff = DateTime.now().difference(d);
    if (diff.inDays >= 30) return 'قبل ${diff.inDays ~/ 30} شهر';
    if (diff.inDays >= 1) return 'قبل ${diff.inDays} يوم';
    if (diff.inHours >= 1) return 'قبل ${diff.inHours} ساعة';
    return 'قبل دقائق';
  }
}

// مستخدم كما يشوفه الأدمن
class AdminUser {
  final int id;
  final String name;
  final String email;
  final int reviewsCount;
  bool isSuspended; // مو final لأنها تتغير لما نوقفه

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.reviewsCount,
    required this.isSuspended,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      reviewsCount: json['reviews_count'] ?? 0,
      isSuspended: json['is_suspended'] == true,
    );
  }
}