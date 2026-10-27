import 'package:flutter/material.dart';

import '../data/trails_repository.dart';
import '../models/trail.dart';

// صفحة التفاصيل: نبدأ ببيانات القائمة وبعدين نجيب التفاصيل الكاملة
class TrailDetailsViewModel extends ChangeNotifier {
  final TrailsRepository repository;

  Trail trail;
  bool isLoading = true; // نبدأ بتحميل لأن load() تنطلب مباشرة
  String? errorMessage;

  TrailDetailsViewModel(this.repository, this.trail);

  Future<void> load() async {
    try {
      final fresh = await repository.getTrail(trail.id);
      // شارة "معتمد" تجي من القائمة، فنحافظ عليها
      trail = fresh.copyWith(isCertified: trail.isCertified);
      errorMessage = null;
    } catch (_) {
      errorMessage = 'ما قدرنا نحمّل تفاصيل المسار';
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
}