import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// الصورة تنزل مرة وحدة وتبقى على الجهاز حتى بعد إغلاق التطبيق
class AppImageCache {
  AppImageCache._();

  static final CacheManager instance = CacheManager(
    Config(
      'qimmahImages',
      stalePeriod: const Duration(days: 60), // نحتفظ بالصورة ٦٠ يوم
      maxNrOfCacheObjects: 500,              // أقصى عدد صور
    ),
  );
}