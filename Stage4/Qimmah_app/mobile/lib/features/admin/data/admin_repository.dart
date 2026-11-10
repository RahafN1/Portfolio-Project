import 'dart:typed_data';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/admin_models.dart';

// أرقام لوحة التحكم
class AdminStats {
  final int trails;
  final int reviews;
  final int users;

  const AdminStats({
    required this.trails,
    required this.reviews,
    required this.users,
  });
}

class AdminRepository {
  final ApiClient api;

  AdminRepository(this.api);

  Future<AdminStats> getStats() async {
    final data = await api.get(ApiEndpoints.adminStats);
    return AdminStats(
      trails: data['trails'] ?? 0,
      reviews: data['reviews'] ?? 0,
      users: data['users'] ?? 0,
    );
  }

  Future<List<AdminReview>> getReviews() async {
    final data = await api.get('${ApiEndpoints.adminReviews}?limit=100');
    final List list = data['reviews'] ?? [];
    return list.map((item) => AdminReview.fromJson(item)).toList();
  }

  Future<List<AdminUser>> getUsers() async {
    final data = await api.get('${ApiEndpoints.adminUsers}?limit=100');
    final List list = data['users'] ?? [];
    return list.map((item) => AdminUser.fromJson(item)).toList();
  }

  Future<void> deleteReview(int reviewId) async {
    await api.delete('${ApiEndpoints.adminReviews}/$reviewId');
  }

  // suspended = true يوقفه، false يلغي الإيقاف
  Future<void> setSuspended(int userId, bool suspended) async {
    final action = suspended ? 'suspend' : 'unsuspend';
    await api.patch('${ApiEndpoints.adminUsers}/$userId/$action');
  }


    // إضافة مسار جديد (ترجع رقم المسار الجديد)
  Future<int?> addTrail(Map<String, dynamic> data) async {
    final res = await api.post(ApiEndpoints.adminTrails, data);
    return res['trail']?['id'];
  }

  // رفع صور المسار
  Future<void> uploadTrailImages(int trailId, List<Uint8List> images) async {
    await api.postFiles(
      '${ApiEndpoints.adminTrails}/$trailId/images',
      'images',
      images,
    );
  }
  // تعديل مسار موجود
  Future<void> updateTrail(int trailId, Map<String, dynamic> data) async {
    await api.put('${ApiEndpoints.adminTrails}/$trailId', data);
  }


  Future<void> deleteTrail(int trailId) async {
    await api.delete('${ApiEndpoints.adminTrails}/$trailId');
  }
}
