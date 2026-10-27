import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../trails/models/trail.dart';
import '../models/completed_trail.dart';
import '../../../core/network/api_exception.dart';

// طلبات "مساراتي": المحفوظة والمكتملة
class FavoritesRepository {
  final ApiClient api;

  FavoritesRepository(this.api);

  // الرد المتوقع: { "favorites": [ {ملخص المسار}, ... ] }
  Future<List<Trail>> getFavorites() async {
    final data = await api.get(ApiEndpoints.favorites);
    final List list = data['favorites'] ?? data['trails'] ?? [];
    return list.map((item) => Trail.fromJson(item)).toList();
  }

  Future<void> addFavorite(int trailId) async {
    try {
      await api.post(ApiEndpoints.favorites, {'trail_id': trailId});
    } on ApiException catch (e) {
      // 409 يعني المسار محفوظ من قبل، فما نعتبره خطأ
      if (e.statusCode != 409) {
        rethrow;
      }
    }
  }

  Future<void> removeFavorite(int trailId) async {
    await api.delete('${ApiEndpoints.favorites}/$trailId');
  }

  // الرد المتوقع: { "completed_trails": [ {ملخص المسار + completed_at}, ... ] }
  Future<List<CompletedTrail>> getCompletedTrails() async {
    final data = await api.get(ApiEndpoints.completedTrails);
    final List list = data['completed_trails'] ?? data['trails'] ?? [];
    return list.map((item) => CompletedTrail.fromJson(item)).toList();
  }

  Future<void> addCompleted(int trailId) async {
    await api.post(ApiEndpoints.completedTrails, {'trail_id': trailId});
  }

  Future<void> removeCompleted(int trailId) async {
    await api.delete('${ApiEndpoints.completedTrails}/$trailId');
  }
}