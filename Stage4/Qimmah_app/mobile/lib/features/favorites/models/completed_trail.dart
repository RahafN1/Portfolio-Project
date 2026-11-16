import '../../../l10n/l10n.dart';
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

  static List<String> get _months {
    final t = L10n.tr;
    return [
      t.favoritesMonthJan, t.favoritesMonthFeb, t.favoritesMonthMar,
      t.favoritesMonthApr, t.favoritesMonthMay, t.favoritesMonthJun,
      t.favoritesMonthJul, t.favoritesMonthAug, t.favoritesMonthSep,
      t.favoritesMonthOct, t.favoritesMonthNov, t.favoritesMonthDec,
    ];
  }

  // "12 سبتمبر 2026"
  String get completedAtText {
    final d = completedAt;
    if (d == null) return '';
    return L10n.tr.favoritesDate('${d.day}', _months[d.month - 1], '${d.year}');
  }
}