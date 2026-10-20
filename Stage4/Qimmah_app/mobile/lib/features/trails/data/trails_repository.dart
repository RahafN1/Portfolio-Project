import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/trail.dart';

class TrailsRepository {
  final ApiClient api;

  TrailsRepository(this.api);

  // الرد شكله: { "trails": [ {...}, {...} ], "page": 1, "total": 13 }
  Future<List<Trail>> getTrails() async {
    final data = await api.get(ApiEndpoints.trails);
    final List list = data['trails'] ?? [];
    return list.map((item) => Trail.fromJson(item)).toList();
  }
}
