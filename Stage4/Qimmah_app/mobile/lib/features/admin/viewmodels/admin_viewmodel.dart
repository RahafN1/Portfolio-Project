import 'package:flutter/material.dart';

import '../../trails/data/trails_repository.dart';
import '../../trails/models/trail.dart';
import '../data/admin_repository.dart';
import '../models/admin_models.dart';

// كل بيانات لوحة التحكم: الأرقام + المسارات + التقييمات + المستخدمين
class AdminViewModel extends ChangeNotifier {
  final AdminRepository repository;
  final TrailsRepository trailsRepository;

  AdminViewModel(this.repository, this.trailsRepository);

  int trailsCount = 0;
  int reviewsCount = 0;
  int usersCount = 0;

  List<Trail> trails = [];
  List<AdminReview> reviews = [];
  List<AdminUser> users = [];

  bool isLoading = true;
  String? errorMessage;

  // silent = true: نحدّث البيانات بدون ما نخفي الشاشة بدائرة تحميل
  Future<void> load({bool silent = false}) async {
    if (!silent) {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
    }
    try {
      final results = await Future.wait([
        repository.getStats(),
        trailsRepository.getTrails(limit: 100),
        repository.getReviews(),
        repository.getUsers(),
      ]);
      final stats = results[0] as AdminStats;
      trailsCount = stats.trails;
      reviewsCount = stats.reviews;
      usersCount = stats.users;
      trails = (results[1] as TrailsPage).trails;
      reviews = results[2] as List<AdminReview>;
      users = results[3] as List<AdminUser>;
      errorMessage = null;
    } catch (_) {
      if (!silent) errorMessage = 'ما قدرنا نحمّل بيانات لوحة التحكم';
    }
    isLoading = false;
    notifyListeners();
  }

  // كل الدوال ترجّع true لو نجحت


  // إضافة مسار جديد
  Future<bool> addTrail(Map<String, dynamic> data) async {
    try {
      await repository.addTrail(data);
    } catch (_) {
      return false;
    }
    // نجيب القوائم والأرقام من جديد عشان تظهر البيانات الجديدة
    await load(silent: true);
    return true;
  }

  // تعديل مسار موجود
  Future<bool> updateTrail(Trail trail, Map<String, dynamic> data) async {
    try {
      await repository.updateTrail(trail.id, data);
    } catch (_) {
      return false;
    }
    await load(silent: true);
    return true;
  }

  Future<bool> deleteReview(AdminReview review) async {
    try {
      await repository.deleteReview(review.id);
    } catch (_) {
      return false;
    }
    reviews.removeWhere((r) => r.id == review.id);
    if (reviewsCount > 0) reviewsCount--;
    notifyListeners();
    return true;
  }

  Future<bool> toggleSuspend(AdminUser user) async {
    final suspend = !user.isSuspended;
    try {
      await repository.setSuspended(user.id, suspend);
    } catch (_) {
      return false;
    }
    user.isSuspended = suspend;
    notifyListeners();
    return true;
  }

  Future<bool> deleteTrail(Trail trail) async {
    try {
      await repository.deleteTrail(trail.id);
    } catch (_) {
      return false;
    }
    trails.removeWhere((t) => t.id == trail.id);
    notifyListeners();
    // تقييمات المسار انحذفت معه، فنجيب الأرقام والقوائم من جديد
    await load(silent: true);
    return true;
  }
}