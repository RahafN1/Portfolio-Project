import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/trail.dart';

// صفحة وحدة من المسارات + الإجمالي الكلي (عشان نعرف فيه المزيد ولا لا)
class TrailsPage {
  final List<Trail> trails;
  final int page;//يعني اني خلاص ترا حطيت ذا المتغير وما بغير قيمته "متغير يمكن تعيين قيمته "مرة واحدة فقط"
  final int total;

  const TrailsPage({
    required this.trails,//ضروري تعطيني ذا ،this =Widget
    required this.page,
    required this.total,
  });
}

class TrailsRepository {
  final ApiClient api;

  TrailsRepository(this.api);

  //الحين ذي تقولل وعد اني اذا ناديتوني اني اصير كفو. واجيب لكم اللي تبون 
Future<TrailsPage> getTrails({
  int page = 1,
  int limit = 10,//حجم الصفحه يعني ذيك حقت المسار يكون ينعرض فيها ١٠
  String? search,//رح ناخذ ذول من الباك اند search/region/difficulty
  String? region,
  String? difficulty,
}) async {
  final params = <String, String>{
    'page': '$page',
    'limit': '$limit',
    if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
    if (region != null && region.isNotEmpty) 'region': region,
    if (difficulty != null && difficulty.isNotEmpty) 'difficulty': difficulty,
  };
  // Uri يرمّز النص العربي لنا
  final query = Uri(queryParameters: params).query;

  final data = await api.get('${ApiEndpoints.trails}?$query');
  final List list = data['trails'] ?? [];
  return TrailsPage(
    trails: list.map((item) => Trail.fromJson(item)).toList(),
    page: data['page'] ?? page,
    total: data['total'] ?? list.length,
  );
} // تفاصيل مسار واحد، الرد شكله: { "trail": {...} }
  Future<Trail> getTrail(int id) async {
    final data = await api.get('${ApiEndpoints.trails}/$id');
    return Trail.fromJson(data['trail'] ?? data);
  }
}