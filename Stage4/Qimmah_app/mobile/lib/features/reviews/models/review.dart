class Review {
  final int id;
  final int userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    // السيرفر يرجّع صاحب التقييم داخل "user": { id, name }
    final user = json['user'];
    return Review(
      id: json['id'] ?? 0,
      userId: user is Map ? (user['id'] ?? 0) : 0,
      userName: user is Map ? (user['name'] ?? '') : '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '')?.toLocal(),
    );
  }

  // التاريخ بشكل بسيط: 2026/11/1
  String get dateText {
    final d = createdAt;
    if (d == null) return '';
    return '${d.year}/${d.month}/${d.day}';
  }
}