import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/trail.dart';

class TrailsRepository {
  final ApiClient api;

  TrailsRepository(this.api);

  // الرد شكله: { "trails": [ {...}, {...} ], "page": 1, "total": 13 }
  // نجيب أكبر عدد مسموح (100) والفلترة والبحث تصير عندنا بالتطبيق
  Future<List<Trail>> getTrails({int limit = 100}) async {
    final data = await api.get('${ApiEndpoints.trails}?limit=$limit');
    final List list = data['trails'] ?? [];
    return list.map((item) => Trail.fromJson(item)).toList();
  }

  // تفاصيل مسار واحد، الرد شكله: { "trail": {...} }
  Future<Trail> getTrail(int id) async {
    final data = await api.get('${ApiEndpoints.trails}/$id');
    return Trail.fromJson(data['trail'] ?? data);
  }
}