import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../trails/models/trail.dart';
import '../models/completed_trail.dart';

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

  // الرد المتوقع: { "completed_trails": [ {ملخص المسار + completed_at}, ... ] }
  Future<List<CompletedTrail>> getCompletedTrails() async {
    final data = await api.get(ApiEndpoints.completedTrails);
    final List list = data['completed_trails'] ?? data['trails'] ?? [];
    return list.map((item) => CompletedTrail.fromJson(item)).toList();
  }

  Future<void> removeFavorite(int trailId) async {
    await api.delete('${ApiEndpoints.favorites}/$trailId');
  }

  Future<void> addFavorite(int trailId) async {
    await api.post(ApiEndpoints.favorites, {'trail_id': trailId});
  }
}