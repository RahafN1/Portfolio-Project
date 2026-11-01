import '../../trails/models/trail.dart';

// مسار مكتمل: بيانات المسار + تاريخ الإكمال
class CompletedTrail {
  final Trail trail;
  final DateTime? completedAt;

  CompletedTrail({required this.trail, this.completedAt});

  // السيرفر يرجّع ملخص المسار + completed_at بنفس المستوى
  factory CompletedTrail.fromJson(Map<String, dynamic> json) {
    final raw = json['completed_at'];
    return CompletedTrail(
      trail: Trail.fromJson(json),
      completedAt: raw == null ? null : DateTime.tryParse(raw.toString())?.toLocal(),
    );
  }

  static const _months = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  // "12 سبتمبر 2026"
  String get completedAtText {
    final d = completedAt;
    if (d == null) return '';
    return '${d.day} ${_months[d.month - 1]} ${d.year}';
  }
}