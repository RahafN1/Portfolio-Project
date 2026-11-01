import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/review.dart';

// التقييمات + المتوسط + العدد الكلي
class ReviewsPage {
  final List<Review> reviews;
  final double? averageRating;
  final int total;

  const ReviewsPage({
    required this.reviews,
    required this.averageRating,
    required this.total,
  });
}

class ReviewsRepository {
  final ApiClient api;

  ReviewsRepository(this.api);

  // الرد: { "average_rating": 4.5, "reviews": [...], "page": 1, "total": 3 }
  Future<ReviewsPage> getReviews(int trailId, {int limit = 50}) async {
    final data = await api.get(
      '${ApiEndpoints.trailReviews(trailId)}?limit=$limit',
    );
    final List list = data['reviews'] ?? [];
    return ReviewsPage(
      reviews: list.map((item) => Review.fromJson(item)).toList(),
      averageRating: double.tryParse(data['average_rating'].toString()),
      total: data['total'] ?? list.length,
    );
  }

  // يحتاج تسجيل دخول (التوكن يروح تلقائي من ApiClient)
  Future<void> addReview(int trailId, int rating, String comment) async {
    await api.post(ApiEndpoints.trailReviews(trailId), {
      'rating': rating,
      'comment': comment.trim(),
    });
  }

  // السيرفر يسمح بس لصاحب التقييم
  Future<void> deleteReview(int reviewId) async {
    await api.delete(ApiEndpoints.review(reviewId));
  }
}