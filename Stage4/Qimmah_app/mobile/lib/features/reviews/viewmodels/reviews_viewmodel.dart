import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../data/reviews_repository.dart';
import '../models/review.dart';

// تقييمات مسار واحد: نجيبها، ننشر، ونحذف
class ReviewsViewModel extends ChangeNotifier {
  final ReviewsRepository repository;
  final int trailId;
  final int currentUserId; // 0 = ضيف

  ReviewsViewModel(this.repository, this.trailId, this.currentUserId);

  List<Review> reviews = [];
  double? averageRating;
  int total = 0;
  bool isLoading = true;
  bool hasLoaded = false; // صار عندنا بيانات من السيرفر
  String? errorMessage;

  // تقييمي أنا (لو كتبت تقييم لهذا المسار)
  Review? get myReview {
    if (currentUserId == 0) return null;
    for (final r in reviews) {
      if (r.userId == currentUserId) return r;
    }
    return null;
  }

  Future<void> load() async {
    try {
      final page = await repository.getReviews(trailId);
      reviews = page.reviews;
      averageRating = page.averageRating;
      total = page.total;
      errorMessage = null;
      hasLoaded = true;
    } catch (_) {
      errorMessage = 'ما قدرنا نحمّل التقييمات';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> retry() {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    return load();
  }

  // ينشر التقييم. يرجّع null لو نجح، أو رسالة الخطأ لو فشل
  Future<String?> submit({required int rating, required String comment}) async {
    try {
      await repository.addReview(trailId, rating, comment);
    } on ApiException catch (e) {
      if (e.statusCode == 401) return 'انتهت جلستك، سجّل دخولك مرة ثانية';
      return e.message;
    } catch (_) {
      return 'ما قدرنا ننشر التقييم، حاول مرة ثانية';
    }
    await load(); // نحدّث القائمة والمتوسط
    return null;
  }

  // يرجّع true لو انحذف
  Future<bool> deleteReview(Review review) async {
    try {
      await repository.deleteReview(review.id);
    } catch (_) {
      return false;
    }
    await load();
    return true;
  }
}
/*
بعد النشر والحذف نعيد جلب التقييمات من السيرفر
، فالقائمة والمتوسط دايماً صح. وmyReview 
يعرف تقييمك من مقارنة رقم المستخدم.
*/